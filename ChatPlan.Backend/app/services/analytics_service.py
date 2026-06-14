from sqlalchemy.orm import Session
from app.storage.activity_store import get_all_activities
from app.models.analytics import AnalyticsResponse

class AnalyticsService:
    def get_analytics(self, db: Session) -> AnalyticsResponse:
        activities = get_all_activities(db)
        total = len(activities)
        completed = sum(1 for act in activities if act.is_completed)
        pending = total - completed
        
        productivity = 0.0
        if total > 0:
            productivity = (completed / total) * 100
            
        return AnalyticsResponse(
            total=total,
            completed=completed,
            pending=pending,
            productivity=round(productivity, 2)
        )

analytics_service = AnalyticsService()
