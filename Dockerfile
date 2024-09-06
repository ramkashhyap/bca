# Step 1: Use a base image with Python 3.12-slim
FROM python:3.12-slim

# Step 2: Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    libpq-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Step 3: Set the working directory
WORKDIR /app/src/src

# Step 4: Install Poetry
RUN pip install poetry==1.8.3

# Step 5: Copy pyproject.toml and poetry.lock files
COPY pyproject.toml poetry.lock /app/src/src/

# Step 6: Install dependencies
RUN poetry install --no-root --only main

# Step 7: Copy the rest of the application code into the container
COPY . /app/src

# Step 8: Set PYTHONPATH
ENV PYTHONPATH=/app/src

# Step 9: Expose the port and define the entry point
EXPOSE 8000
CMD ["poetry", "run", "uvicorn", "sample_api.main:app", "--host", "0.0.0.0", "--port", "8000"]
