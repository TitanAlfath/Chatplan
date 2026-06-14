from sqlalchemy.orm import Session
from app.models.schema import ChatHistoryDB
from typing import List, Dict

class ConversationMemoryService:
    def __init__(self, max_history: int = 10):
        self.max_history = max_history

    def add_message(self, db: Session, user_id: str, role: str, message: str):
        """Menambahkan pesan ke dalam riwayat di database."""
        db_msg = ChatHistoryDB(user_id=user_id, role=role, message=message)
        db.add(db_msg)
        db.commit()
        
        # Batasi jumlah maksimal pesan
        history_count = db.query(ChatHistoryDB).filter(ChatHistoryDB.user_id == user_id).count()
        if history_count > self.max_history * 2:
            # Hapus pesan paling lama
            oldest = db.query(ChatHistoryDB).filter(ChatHistoryDB.user_id == user_id).order_by(ChatHistoryDB.timestamp.asc()).first()
            if oldest:
                db.delete(oldest)
                db.commit()

    def get_history_string(self, db: Session, user_id: str) -> str:
        """Mengembalikan format string dari percakapan sebelumnya untuk konteks Gemini."""
        history = db.query(ChatHistoryDB).filter(ChatHistoryDB.user_id == user_id).order_by(ChatHistoryDB.timestamp.asc()).all()
        
        if not history:
            return ""
        
        formatted = "--- RIWAYAT PERCAKAPAN (KONTEKS) ---\n"
        for msg in history:
            role_name = "User" if msg.role == "user" else "Sistem/Aplikasi"
            formatted += f"{role_name}: {msg.message}\n"
        formatted += "--------------------------------------\n"
        return formatted

conversation_memory = ConversationMemoryService()
