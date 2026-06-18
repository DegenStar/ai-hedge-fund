FROM python:3.11-slim

WORKDIR /app

# Set PYTHONPATH to include the app directory
ENV PYTHONPATH=/app

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# Copy only dependency files first for better caching
COPY pyproject.toml uv.lock /app/

# Install dependencies (no venv, system-level install)
RUN uv sync --frozen --no-dev --no-install-project

# Copy rest of the source code
COPY . /app/

# Default command (will be overridden by Docker Compose)
CMD ["python", "src/main.py"]
