from fastapi import FastAPI
from datetime import datetime, timezone
import os

app = FastAPI(title="OpsPulse API", version="1.0.0")

@app.get("/")
def root():
    return {
        "service": "OpsPulse",
        "message": "Cloud operations portfolio service is running."
    }

@app.get("/health")
def health():
    return {
        "status": "healthy",
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "environment": os.getenv("APP_ENV", "development")
    }

@app.get("/ready")
def ready():
    return {"ready": True}
