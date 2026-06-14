from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from app.models.user import GoogleAuthRequest, TokenResponse, User, UserCreate, UserLogin
from app.services.auth_service import auth_service
from app.core.security import get_current_user_email
from app.storage.user_store import get_user_by_email
from app.core.database import get_db

router = APIRouter(
    prefix="/auth",
    tags=["Authentication"]
)

@router.post("/register", response_model=TokenResponse)
def register(user_data: UserCreate, db: Session = Depends(get_db)):
    try:
        token = auth_service.register(db, user_data)
        return TokenResponse(access_token=token)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.post("/login", response_model=TokenResponse)
def login(user_data: UserLogin, db: Session = Depends(get_db)):
    try:
        token = auth_service.login(db, user_data)
        return TokenResponse(access_token=token)
    except ValueError as e:
        raise HTTPException(status_code=401, detail=str(e))

@router.post("/google", response_model=TokenResponse)
def auth_google(request: GoogleAuthRequest, db: Session = Depends(get_db)):
    try:
        token = auth_service.login_or_register_google(db, request)
        return TokenResponse(access_token=token)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.get("/me", response_model=User)
def get_me(email: str = Depends(get_current_user_email), db: Session = Depends(get_db)):
    user = get_user_by_email(db, email)
    if not user:
        raise HTTPException(status_code=404, detail="Pengguna tidak ditemukan")
    return user

