from pydantic import BaseModel, Field, ConfigDict
from typing import Optional
import uuid
from datetime import datetime

class Activity(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    title: str
    date: Optional[str] = None
    time: Optional[str] = None
    description: Optional[str] = None
    status: str = "Sedang Berjalan"
    priority: str = "Sedang"
    user_id: str
    created_at: datetime = Field(default_factory=datetime.now)

class ActivityCreate(BaseModel):
    title: str
    date: Optional[str] = None
    time: Optional[str] = None
    description: Optional[str] = None
    status: Optional[str] = "Sedang Berjalan"
    priority: Optional[str] = "Sedang"

class ActivityUpdate(BaseModel):
    title: Optional[str] = None
    date: Optional[str] = None
    time: Optional[str] = None
    description: Optional[str] = None
    status: Optional[str] = None
    priority: Optional[str] = None
