from google.oauth2 import id_token
from google.auth.transport import requests
from sqlalchemy.orm import Session
from app.core.config import settings
from app.models.user import DBUser, UserCreate, UserLogin, GoogleAuthRequest
from app.storage.user_store import get_user_by_email, create_user, create_google_user, verify_password
from app.core.security import create_access_token

class AuthService:
    def verify_google_token(self, token: str) -> dict:
        try:
            # Mekanisme bypass sementara jika Client ID belum diisi
            if settings.GOOGLE_CLIENT_ID == "your-google-client-id.apps.googleusercontent.com" or not settings.GOOGLE_CLIENT_ID:
                if token == "mock-google-token":
                    return {"email": "test@example.com", "name": "Test User", "picture": ""}
                
            idinfo = id_token.verify_oauth2_token(
                token, requests.Request(), settings.GOOGLE_CLIENT_ID
            )
            return idinfo
        except ValueError as e:
            raise ValueError(f"Token Google tidak valid: {str(e)}")

    def login_or_register_google(self, db: Session, auth_request: GoogleAuthRequest) -> str:
        idinfo = self.verify_google_token(auth_request.id_token)
        email = idinfo.get("email")
        name = idinfo.get("name", "Pengguna Tidak Diketahui")
        avatar = idinfo.get("picture", "")
        
        if not email:
            raise ValueError("Token tidak berisi alamat email.")
            
        user = get_user_by_email(db, email)
        if not user:
            user = create_google_user(db, email=email, name=name, avatar=avatar)
            
        access_token = create_access_token({"sub": user.email})
        return access_token

    def register(self, db: Session, user_data: UserCreate) -> str:
        existing_user = get_user_by_email(db, user_data.email)
        if existing_user:
            raise ValueError("Email sudah terdaftar.")
        
        user = create_user(db, user_data)
        access_token = create_access_token({"sub": user.email})
        return access_token

    def login(self, db: Session, user_data: UserLogin) -> str:
        user = get_user_by_email(db, user_data.email)
        if not user or not user.hashed_password:
            raise ValueError("Email atau password salah.")
        
        if not verify_password(user_data.password, user.hashed_password):
            raise ValueError("Email atau password salah.")
            
        access_token = create_access_token({"sub": user.email})
        return access_token

auth_service = AuthService()
