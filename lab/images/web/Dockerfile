# VULN: DOCKER-001 - end-of-life base image (Python 3.8, EOL Oct 2024), full Debian = many OS CVEs
# VULN: floating tag (not pinned by digest) - content can change between builds
FROM python:3.8

WORKDIR /app

# VULN: outdated, vulnerable Python dependencies (see requirements.txt)
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY app.py .

# VULN: no USER instruction -> runs as root
EXPOSE 8080
CMD ["python", "app.py"]
