import os
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
from sqlalchemy.orm import DeclarativeBase

# --- Connection Logic Fix ---
# The Kubernetes Deployment YAML sets the full DATABASE_URL.
# We MUST prioritize reading the full URL from the environment.

DATABASE_URL = os.getenv("DATABASE_URL")

if not DATABASE_URL:
    # FALLBACK (Only executes if DATABASE_URL is NOT set in the environment)
    # This block ensures that if the app is run locally without K8s, it still works.
    POSTGRES_USER = os.getenv("POSTGRES_USER", "admin")
    POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD", "admin123")
    POSTGRES_DB = os.getenv("POSTGRES_DB", "mydb")
    POSTGRES_HOST = os.getenv("POSTGRES_HOST", "postgres")
    POSTGRES_PORT = os.getenv("POSTGRES_PORT", "5432")

    # Use the asynchronous driver 'postgresql+asyncpg'
    DATABASE_URL = f"postgresql+asyncpg://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:{POSTGRES_PORT}/{POSTGRES_DB}"


# Create async engine
engine = create_async_engine(
    DATABASE_URL,
    echo=True,
    future=True
)

# Create async session factory
AsyncSessionLocal = async_sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False
)

# Base class for models
class Base(DeclarativeBase):
    pass

# Dependency to get database session
async def get_db():
    async with AsyncSessionLocal() as session:
        try:
            yield session
        finally:
            await session.close()
