FROM python:3.11-slim

WORKDIR /app

# Install system dependencies (bila ada package python yang membutuhkan kompilasi C)
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy seluruh source code
COPY . .

# Set python agar log langsung dialirkan (tidak tertahan di buffer)
ENV PYTHONUNBUFFERED=1

# Expose port default
EXPOSE 5000

# Jalankan menggunakan gunicorn dengan dynamic PORT atau fallback ke 5000
CMD gunicorn --bind 0.0.0.0:${PORT:-5000} run:app --workers 1 --threads 4 --timeout 120
