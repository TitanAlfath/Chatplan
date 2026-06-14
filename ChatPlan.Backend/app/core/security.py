import jwt
from datetime import datetime, timedelta, timezone
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from app.core.config import settings

security_scheme = HTTPBearer()

def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, settings.JWT_SECRET, algorithm=settings.JWT_ALGORITHM)
    return encoded_jwt

def decode_access_token(token: str):
    try:
        decoded_data = jwt.decode(token, settings.JWT_SECRET, algorithms=[settings.JWT_ALGORITHM])
        return decoded_data
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token sudah kedaluwarsa")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Token tidak valid")

def get_current_user_email(credentials: HTTPAuthorizationCredentials = Depends(security_scheme)) -> str:
    token = credentials.credentials
    payload = decode_access_token(token)
    email = payload.get("sub")
    if email is None:
        raise HTTPException(status_code=401, detail="Payload token tidak valid")
    return email
