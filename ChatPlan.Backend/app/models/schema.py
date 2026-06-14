from sqlalchemy import Column, String, Boolean, DateTime, ForeignKey
from app.core.database import Base
from datetime import datetime
import uuid

class ActivityDB(Base):
    __tablename__ = "activities"

    id = Column(String, primary_key=True, index=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), index=True, nullable=False)
    title = Column(String, index=True)
    date = Column(String, nullable=True)
    time = Column(String, nullable=True)
    description = Column(String, nullable=True)
    status = Column(String, default="Sedang Berjalan")
    priority = Column(String, default="Sedang")
    created_at = Column(DateTime, default=datetime.utcnow)



class ChatHistoryDB(Base):
    __tablename__ = "chat_history"

    id = Column(String, primary_key=True, index=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), index=True, nullable=False)
    role = Column(String, nullable=False) # 'user' or 'model'
    message = Column(String, nullable=False)
    timestamp = Column(DateTime, default=datetime.utcnow)
