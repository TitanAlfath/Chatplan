from pydantic import BaseModel
from typing import Any, Dict, Optional

class ChatRequest(BaseModel):
    message: str

class ChatResponse(BaseModel):
    success: bool
    intent: Optional[str] = None
    data: Optional[Any] = None
    error: Optional[str] = None
