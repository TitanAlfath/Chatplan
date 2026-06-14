from pydantic import BaseModel

class AnalyticsResponse(BaseModel):
    total: int
    completed: int
    pending: int
    productivity: float
