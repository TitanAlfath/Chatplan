from sqlalchemy.orm import Session
from app.models.schema import ActivityDB
from app.models.activity import ActivityCreate, ActivityUpdate
from typing import List, Optional

def get_all_activities(db: Session, user_id: str) -> List[ActivityDB]:
    return db.query(ActivityDB).filter(ActivityDB.user_id == user_id).all()

def create_activity(db: Session, activity: ActivityCreate, user_id: str) -> ActivityDB:
    db_act = ActivityDB(**activity.model_dump(), user_id=user_id)
    db.add(db_act)
    db.commit()
    db.refresh(db_act)
    return db_act

def update_activity(db: Session, activity_id: str, activity_update: ActivityUpdate, user_id: str) -> Optional[ActivityDB]:
    db_act = db.query(ActivityDB).filter(ActivityDB.id == activity_id, ActivityDB.user_id == user_id).first()
    if not db_act:
        return None
    
    update_data = activity_update.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_act, key, value)
        
    db.commit()
    db.refresh(db_act)
    return db_act

def delete_activity(db: Session, activity_id: str, user_id: str) -> bool:
    db_act = db.query(ActivityDB).filter(ActivityDB.id == activity_id, ActivityDB.user_id == user_id).first()
    if not db_act:
        return False
    
    db.delete(db_act)
    db.commit()
    return True

def complete_activity(db: Session, activity_id: str, user_id: str) -> Optional[ActivityDB]:
    db_act = db.query(ActivityDB).filter(ActivityDB.id == activity_id, ActivityDB.user_id == user_id).first()
    if not db_act:
        return None
    
    db_act.status = "Selesai"
    db.commit()
    db.refresh(db_act)
    return db_act
