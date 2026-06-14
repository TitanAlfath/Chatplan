from typing import Optional
from sqlalchemy.orm import Session
from app.models.user import DBUser, UserCreate
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

def get_user_by_email(db: Session, email: str) -> Optional[DBUser]:
    return db.query(DBUser).filter(DBUser.email == email).first()

def create_user(db: Session, user: UserCreate) -> DBUser:
    hashed_password = get_password_hash(user.password) if hasattr(user, "password") and user.password else None
    db_user = DBUser(
        email=user.email,
        name=user.name,
        hashed_password=hashed_password
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

def create_google_user(db: Session, email: str, name: str, avatar: str) -> DBUser:
    db_user = DBUser(
        email=email,
        name=name,
        avatar=avatar,
        hashed_password=None
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user
