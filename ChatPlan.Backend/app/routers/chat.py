from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.models.chat import ChatRequest, ChatResponse
from app.services.gemini_service import gemini_service
from app.services.activity_service import activity_service
from app.models.activity import ActivityCreate, ActivityUpdate
from app.core.security import get_current_user_email
from app.storage.user_store import get_user_by_email


router = APIRouter(
    prefix="/chat",
    tags=["Chat"]
)

@router.post("/", response_model=ChatResponse)
def handle_chat(request: ChatRequest, email: str = Depends(get_current_user_email), db: Session = Depends(get_db)):
    try:
        user = get_user_by_email(db, email)
        if not user:
            raise HTTPException(status_code=404, detail="User not found")
        user_id = user.id

        # Panggil service Gemini untuk mengekstrak intent
        intent_result = gemini_service.generate_response(db, request.message, user_id)
        intent = intent_result.get("intent")
        extracted_data = intent_result.get("data", {})
        
        response_data = None
        
        # Eksekusi logika berdasarkan Intent
        if intent == "create_activity":
            from datetime import date
            if not extracted_data.get("date"):
                extracted_data["date"] = date.today().strftime("%Y-%m-%d")

            new_date = extracted_data.get("date")
            new_time = extracted_data.get("time")
            
            # Deteksi konflik jadwal
            if new_date and new_time:
                all_acts = activity_service.get_activities(db, user_id)
                clashing_act = next((a for a in all_acts if a.date == new_date and a.time == new_time), None)
                if clashing_act:
                    narrative = gemini_service.generate_conflict_resolution(
                        clashing_act.title, 
                        extracted_data.get("title", "Aktivitas Baru"), 
                        new_time,
                        new_date
                    )
                    return ChatResponse(success=False, error=narrative)

            new_act = activity_service.create_activity(db, ActivityCreate(**extracted_data), user_id)
            response_data = new_act.model_dump()
            
        elif intent == "show_activities":
            all_acts = activity_service.get_activities(db, user_id)
            response_data = [act.model_dump() for act in all_acts]
            
        elif intent == "update_activity":
            act_id = extracted_data.get("activity_id")
            if not act_id:
                raise ValueError("Harap sertakan ID aktivitas (activity_id) yang ingin diubah.")
            
            # Hapus activity_id dari payload untuk proses pembaruan
            update_payload = extracted_data.copy()
            update_payload.pop("activity_id", None)
            
            updated_act = activity_service.update_activity(db, act_id, ActivityUpdate(**update_payload), user_id)
            if updated_act:
                response_data = updated_act.model_dump()
            else:
                raise ValueError(f"Aktivitas dengan ID '{act_id}' tidak ditemukan.")
                
        elif intent == "delete_activity":
            act_id = extracted_data.get("activity_id")
            title = extracted_data.get("title")
            
            # Jika AI tidak mendapatkan ID, coba cari berdasarkan judul (title)
            if not act_id and title:
                all_acts = activity_service.get_activities(db, user_id)
                # Cari aktivitas yang judulnya mengandung kata yang diinputkan (case-insensitive)
                matching_act = next((a for a in all_acts if title.lower() in a.title.lower()), None)
                if matching_act:
                    act_id = matching_act.id
            
            if not act_id:
                raise ValueError("Harap sebutkan nama jadwal yang ingin dihapus dengan jelas.")
            
            success = activity_service.delete_activity(db, act_id, user_id)
            if success:
                response_data = {"message": "Aktivitas berhasil dihapus."}
            else:
                raise ValueError(f"Jadwal tersebut tidak ditemukan.")
                
        elif intent == "complete_activity":
            act_id = extracted_data.get("activity_id")
            if not act_id:
                raise ValueError("Harap sertakan ID aktivitas (activity_id) yang ingin diselesaikan.")
            
            completed_act = activity_service.complete_activity(db, act_id, user_id)
            if completed_act:
                response_data = completed_act.model_dump()
            else:
                raise ValueError(f"Aktivitas dengan ID '{act_id}' tidak ditemukan.")
                
        elif intent == "unknown":
            raise ValueError("Maaf, pesan Anda tidak dapat dipahami atau berada di luar konteks penjadwalan.")
        
        else:
            raise ValueError(f"Intent tidak tertangani: {intent}")

        # Gabungkan hasil dari Gemini dan hasil operasi layanan ke Response
        return ChatResponse(
            success=True,
            intent=intent,
            data={
                "extracted_info": extracted_data,
                "operation_result": response_data
            }
        )
        
    except ValueError as ve:
        return ChatResponse(
            success=False,
            intent=intent_result.get("intent") if 'intent_result' in locals() else None,
            error=str(ve)
        )
    except Exception as e:
        return ChatResponse(
            success=False,
            error=f"Terjadi kesalahan internal: {str(e)}"
        )

@router.get("/activities")
def get_all_activities_direct(email: str = Depends(get_current_user_email), db: Session = Depends(get_db)):
    user = get_user_by_email(db, email)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    all_acts = activity_service.get_activities(db, user.id)
    return [act.model_dump() for act in all_acts]
