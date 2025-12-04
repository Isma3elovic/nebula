# Use a lightweight base image
FROM python:3.11-slim

# Set the working directory
WORKDIR /app


# Copy the application code
COPY . .

# Expose the port (FastAPI default is 8000)
EXPOSE 8000

# Command to run the application (e.g., using uvicorn)
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
