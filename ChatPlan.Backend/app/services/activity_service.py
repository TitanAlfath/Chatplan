from sqlalchemy.orm import Session
from app.models.activity import Activity, ActivityCreate, ActivityUpdate
from app.storage import activity_store
from typing import List, Optional

class ActivityService:
    
    def create_activity(self, db: Session, data: ActivityCreate, user_id: str) -> Activity:
        db_act = activity_store.create_activity(db, data, user_id)
        return Activity.model_validate(db_act)
        
    def get_activities(self, db: Session, user_id: str) -> List[Activity]:
        db_acts = activity_store.get_all_activities(db, user_id)
        return [Activity.model_validate(a) for a in db_acts]
        
    def update_activity(self, db: Session, activity_id: str, data: ActivityUpdate, user_id: str) -> Optional[Activity]:
        db_act = activity_store.update_activity(db, activity_id, data, user_id)
        return Activity.model_validate(db_act) if db_act else None
        
    def delete_activity(self, db: Session, activity_id: str, user_id: str) -> bool:
        return activity_store.delete_activity(db, activity_id, user_id)
        
    def complete_activity(self, db: Session, activity_id: str, user_id: str) -> Optional[Activity]:
        db_act = activity_store.complete_activity(db, activity_id, user_id)
        return Activity.model_validate(db_act) if db_act else None

activity_service = ActivityService()
