FROM python:3.11-slim

# Set the working directory
WORKDIR /app

# Copy application code first
COPY . .

# Install required Python packages. 
# We explicitly install both asyncpg and psycopg2-binary for SQLAlchemy compatibility.
RUN pip install --no-cache-dir \
    fastapi \
    uvicorn \
    gunicorn \
    sqlalchemy \
    pydantic \
    prometheus_client \
    asyncpg \
    psycopg2-binary

EXPOSE 8000

# Run FastAPI with Gunicorn + UvicornWorker
# Note: Assuming your application object 'app' is in 'main.py' at the root of /app
CMD ["gunicorn", "main:app", "-k", "uvicorn.workers.UvicornWorker", "-b", "0.0.0.0:8000"]
