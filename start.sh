#!/bin/bash
set -e

# Start Redis server in the background (if running everything in one container, e.g. for free tiers)
# NOTE: In a true production environment with multiple containers, Redis should be its own service.
# If REDIS_URL points to an external service, we skip local redis.
if [[ "$REDIS_URL" == *"localhost"* ]] || [[ "$REDIS_URL" == *"127.0.0.1"* ]]; then
    apt-get update && apt-get install -y redis-server
    redis-server --daemonize yes
fi

# Start Celery worker in the background
echo "Starting Celery worker..."
celery -A app.core.celery_app worker --loglevel=info &

# Start FastAPI application
echo "Starting FastAPI server..."
uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 4
