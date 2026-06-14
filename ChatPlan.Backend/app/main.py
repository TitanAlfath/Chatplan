from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import chat, analytics, auth
from app.core.database import Base, engine, SessionLocal
from app.models.user import UserCreate
from app.services.auth_service import auth_service
from app.storage.user_store import get_user_by_email

# Inisialisasi Tabel Database
Base.metadata.create_all(bind=engine)

def seed_demo_user():
    db = SessionLocal()
    try:
        if not get_user_by_email(db, "demo@chatplan.com"):
            demo_user = UserCreate(name="Demo User", email="demo@chatplan.com", password="password123")
            auth_service.register(db, demo_user)
            print("Demo user created successfully!")
    except Exception as e:
        print(f"Error seeding demo user: {e}")
    finally:
        db.close()

seed_demo_user()

app = FastAPI(title="Chat Plan API")

# Konfigurasi CORS agar frontend (seperti Flutter web/mobile) bisa mengakses API
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Dalam produksi, ganti dengan domain spesifik
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(chat.router)
app.include_router(analytics.router)
app.include_router(auth.router)

@app.get("/")
def health_check():
    return {
        "status": "running",
        "app": "Chat Plan API"
    }
