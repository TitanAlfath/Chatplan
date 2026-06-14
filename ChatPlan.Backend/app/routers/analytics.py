from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.services.analytics_service import analytics_service
from app.models.analytics import AnalyticsResponse

router = APIRouter(
    prefix="/analytics",
    tags=["Analytics"]
)

@router.get("/", response_model=AnalyticsResponse)
def get_analytics(db: Session = Depends(get_db)):
    return analytics_service.get_analytics(db)
