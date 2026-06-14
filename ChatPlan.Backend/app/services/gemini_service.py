import os
import json
import google.generativeai as genai
from dotenv import load_dotenv
from app.services.conversation_memory import conversation_memory

load_dotenv()

api_key = os.getenv("GEMINI_API_KEY")
if api_key and api_key != "YOUR_GEMINI_API_KEY_HERE":
    genai.configure(api_key=api_key)

class GeminiService:
    def __init__(self):
        # Instruksi sistem untuk memaksa model berperan sebagai klasifikator intent
        system_instruction = """Anda adalah asisten perencana jadwal pintar. Tugas Anda HANYA mengekstrak pesan pengguna ke dalam intent terstruktur.

Anda akan diberikan "RIWAYAT PERCAKAPAN" sebagai konteks untuk melengkapi informasi yang hilang pada pesan terbaru.
Contoh: Jika pesan riwayat "Rapat besok jam 8" dan pesan terbaru "Ubah jadi jam 10", maka Anda harus menghasilkan intent 'update_activity' dengan jam 10 untuk rapat tersebut.

Daftar intent yang didukung:
- create_activity (untuk membuat jadwal baru. Ekstrak data: title, date, time, description jika ada, priority ("Tinggi", "Sedang", "Rendah"), status ("Tertunda", "Sedang Berjalan", "Selesai"). WAJIB ISI date dengan tanggal hari ini dalam format YYYY-MM-DD jika pengguna tidak menyebutkan hari/tanggal secara spesifik!)
- show_activities (untuk melihat jadwal. Ekstrak data: filter_date jika ada)
- update_activity (untuk mengubah jadwal. Ekstrak data: activity_id, title, date, time, description, priority, status)
- delete_activity (untuk menghapus jadwal. Ekstrak data: activity_id, title)
- complete_activity (untuk menyelesaikan jadwal. Ekstrak data: activity_id, title)
- unknown (jika pesan tidak sesuai dengan manajemen jadwal)

PENTING: Output Anda HARUS selalu berformat JSON MURNI tanpa markdown (seperti ```json), sesuai struktur berikut:
{
  "intent": "nama_intent",
  "data": { ... }
}"""
        
        self.model = genai.GenerativeModel(
            model_name='gemini-1.5-flash-latest',
            system_instruction=system_instruction
        )
        
    def generate_response(self, db, message: str, user_id: str) -> dict:
        current_key = os.getenv("GEMINI_API_KEY")
        if not current_key or current_key == "YOUR_GEMINI_API_KEY_HERE":
            raise ValueError("API Key Gemini belum dikonfigurasi di file .env")
            
        try:
            # Ambil konteks riwayat percakapan sebelumnya
            history_context = conversation_memory.get_history_string(db, user_id)
            
            # Gabungkan dengan pesan terbaru
            full_prompt = f"{history_context}\nPESAN TERBARU USER:\n{message}"
            
            # Memaksa model untuk mengembalikan format JSON (Didukung di model terbaru)
            response = self.model.generate_content(
                full_prompt,
                generation_config={"response_mime_type": "application/json"}
            )
            
            # Pengecekan aman terhadap output
            raw_text = response.text.strip()
            
            # Bersihkan markdown json jika Gemini masih keras kepala
            if raw_text.startswith("```json"):
                raw_text = raw_text.replace("```json", "").replace("```", "").strip()
                
            try:
                parsed_data = json.loads(raw_text)
            except json.JSONDecodeError:
                raise ValueError("Respons Gemini tidak dapat di-parse sebagai JSON valid.")
                
            # Validasi format struktur
            if "intent" not in parsed_data or "data" not in parsed_data:
                raise ValueError("JSON kehilangan field 'intent' atau 'data'.")
                
            valid_intents = [
                "create_activity", "show_activities", "update_activity", 
                "delete_activity", "complete_activity", "unknown"
            ]
            
            if parsed_data["intent"] not in valid_intents:
                raise ValueError(f"Intent tidak valid atau tidak dikenali: {parsed_data['intent']}")
                
            # Jika semua berhasil, rekam ke memory agar diingat untuk percakapan berikutnya
            conversation_memory.add_message(db, user_id, "user", message)
            # Anda juga bisa mem-filter data yang disimpan agar hemat token, di sini kita simpan JSON utuhnya
            conversation_memory.add_message(db, user_id, "model", raw_text)
                
            return parsed_data
            
        except ValueError as ve:
            # Mengembalikan error spesifik terkait format
            raise ve
        except Exception as e:
            raise Exception(f"Gagal berkomunikasi dengan Gemini API: {str(e)}")

    def generate_conflict_resolution(self, existing_title: str, new_title: str, time: str, date: str) -> str:
        prompt = f"""Terdapat jadwal yang bertabrakan!
Pengguna mencoba menjadwalkan aktivitas baru bernama '{new_title}' pada tanggal {date} pukul {time}.
Namun, pada tanggal dan waktu yang sama, pengguna sudah memiliki aktivitas bernama '{existing_title}'.

Tugas Anda: Buatkan narasi singkat (1-2 kalimat) yang ramah sebagai asisten AI untuk memberitahukan konflik ini kepada pengguna, 
serta berikan saran/pertanyaan solutif (misal: memindahkan salah satunya ke jam lain, atau bertanya apakah ingin tetap ditumpuk).
Gunakan bahasa Indonesia yang santai tapi sopan. JANGAN gunakan format markdown, langsung berikan teks murni.
"""
        try:
            response = self.model.generate_content(prompt)
            return response.text.strip()
        except Exception as e:
            return f"Maaf, sepertinya jadwal '{new_title}' bertabrakan dengan '{existing_title}' pada pukul {time}. Apakah Anda ingin mengganti jamnya?"

gemini_service = GeminiService()
