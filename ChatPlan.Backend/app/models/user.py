from pydantic import BaseModel, Field, EmailStr
import uuid
from typing import Optional
from sqlalchemy import Column, String
from app.core.database import Base

class DBUser(Base):
    __tablename__ = "users"

    id = Column(String, primary_key=True, index=True, default=lambda: str(uuid.uuid4()))
    email = Column(String, unique=True, index=True, nullable=False)
    name = Column(String, nullable=False)
    avatar = Column(String, nullable=True)
    hashed_password = Column(String, nullable=True) # Nullable for Google Auth users

class User(BaseModel):
    id: str
    email: str
    name: str
    avatar: Optional[str] = None

    class Config:
        from_attributes = True

class UserCreate(BaseModel):
    name: str
    email: EmailStr
    password: str

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class GoogleAuthRequest(BaseModel):
    id_token: str

class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"

