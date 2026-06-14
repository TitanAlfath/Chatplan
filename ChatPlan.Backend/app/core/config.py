import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    JWT_SECRET: str = os.getenv("JWT_SECRET", "super-secret-key-change-this-in-production")
    JWT_ALGORITHM: str = os.getenv("JWT_ALGORITHM", "HS256")
    GOOGLE_CLIENT_ID: str = os.getenv("GOOGLE_CLIENT_ID", "your-google-client-id.apps.googleusercontent.com")
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7 # 7 hari default

settings = Settings()
