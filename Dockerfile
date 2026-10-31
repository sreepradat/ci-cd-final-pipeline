# 1. Start from a small official Python image
FROM python:3.12-slim

# 2. Python settings: no .pyc files, show logs immediately
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# 3. Working folder inside the container
WORKDIR /app

# 4. Install libraries first (Docker caches this layer = faster rebuilds)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy the rest of the code
COPY . .

# 6. Security: don't run as root
RUN useradd --create-home appuser
USER appuser

# 7. The app listens on port 5000
EXPOSE 5000

# 8. Docker checks /health every 30s to know if the app is healthy
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')" || exit 1

# 9. Start the app with Gunicorn (production server)
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "app:app"]