#!/usr/bin/env bash
# check-prereqs.sh — verifies that every assessment tool is installed and prints its version.
# Read-only: installs nothing and changes nothing.
# Usage:  ./scripts/setup/check-prereqs.sh | tee evidence/phase-b/000-tool-versions.txt
# Exit code = number of missing tools / failed checks (0 = all good).

set -u
missing=0

check() {
  name="$1"; shift
  if command -v "$name" >/dev/null 2>&1; then
    printf '[OK]      %-10s %s\n' "$name" "$("$@" 2>&1 | head -n 1)"
  else
    printf '[MISSING] %s\n' "$name"
    missing=$((missing + 1))
  fi
}

echo "== Assessment workstation prerequisites ($(date -u +%Y-%m-%dT%H:%M:%SZ)) =="
echo "OS: $(uname -s) $(uname -r) | CPU architecture: $(uname -m)"

check docker    docker --version
check kind      kind version
check kubectl   kubectl version --client
check trivy     trivy --version
check nmap      nmap --version
check kubescape kubescape version
check gitleaks  gitleaks version
check hadolint  hadolint --version
check curl      curl --version
check jq        jq --version

if docker info >/dev/null 2>&1; then
  echo "[OK]      Docker daemon is running"
else
  echo "[FAIL]    Docker daemon not reachable (start Docker Desktop)"
  missing=$((missing + 1))
fi

echo "== Result: ${missing} problem(s) =="
exit "$missing"
