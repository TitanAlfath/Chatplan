from typing import List
from app.models.activity import Activity

# Penyimpanan In-Memory untuk sementara (tidak menggunakan database)
activities: List[Activity] = []
