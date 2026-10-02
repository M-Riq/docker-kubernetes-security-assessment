#!/usr/bin/env bash
# Build the intentionally vulnerable lab images (Phase D).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

for img in web backend ops-dashboard; do
  echo "== Building vapt/${img}:lab =="
  docker build -t "vapt/${img}:lab" "${ROOT}/lab/images/${img}"
done

echo "== Pulling upstream db image =="
docker pull postgres:13

echo "== Result =="
docker images --format '{{.Repository}}:{{.Tag}}  {{.ID}}  {{.Size}}' | grep -E '^(vapt/|postgres:13)'
