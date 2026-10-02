# VULN: floating tag, full (non-slim) base image
FROM python:3.9

# VULN: SECRET-001 - hardcoded credentials baked into the image layers
# (visible with `docker history` / `docker inspect`, found by Trivy and Gitleaks)
ENV DB_HOST=db.vuln-app.svc.cluster.local \
    DB_USER=appuser \
    DB_PASSWORD=FAKE-LAB-Db-P4ssw0rd \
    API_KEY=FAKE-LAB-api-key-0000000000

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

# VULN: copies the whole build context (could include .env, keys, .git)
COPY . .

# VULN: DOCKER-002 - no USER instruction -> process runs as root (UID 0)
EXPOSE 5000
CMD ["python", "app.py"]
