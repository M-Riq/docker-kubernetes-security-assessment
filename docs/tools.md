# Tools

All tools are free and/or open source. Versions are recorded from
`scripts/setup/check-prereqs.sh` output (`evidence/phase-b/000-tool-versions.txt`).

| Tool | Purpose | Install (macOS) | Used in phase |
|---|---|---|---|
| Docker Desktop | Container runtime for images and kind nodes | https://docs.docker.com/desktop/setup/install/mac-install/ | D, J |
| kind | Local Kubernetes cluster in Docker | `brew install kind` | E |
| kubectl | Kubernetes CLI: enumeration, `auth can-i`, apply fixes | `brew install kubectl` | E–W |
| Calico | CNI that enforces NetworkPolicies | Manifest applied in Phase E | E, P, V |
| Trivy | Image CVEs, secrets in layers, IaC misconfig | `brew install trivy` | J, K, M |
| kube-bench | CIS Kubernetes Benchmark | Runs as a Job inside the cluster | K |
| kube-hunter | Cluster attack-surface scan (exam tool; no longer actively maintained) | Runs as a pod / container | K |
| Nmap | Port and NodePort discovery | `brew install nmap` | H, O |
| Kubescape | Workload posture (NSA/CISA, MITRE) | `brew install kubescape` | K, N |
| Gitleaks | Secret detection in repo and files | `brew install gitleaks` | M |
| Hadolint | Dockerfile linting | `brew install hadolint` | J |
| rbac-tool | RBAC analysis (`who-can`, policy rules) | `kubectl krew install rbac-tool` (requires `brew install krew`) | L |
| curl / jq | HTTP evidence and JSON parsing | `brew install curl jq` | O, R |

One-shot install of the CLI tools:

```bash
brew install kind kubectl trivy nmap kubescape gitleaks hadolint jq krew
```

## Recorded versions

Source: [evidence 000](../evidence/phase-b/000-tool-versions.txt) — captured 2026-10-02T02:33:25Z
on Darwin 25.5.0, x86_64. Result: 0 problem(s).

| Tool | Version |
|---|---|
| Docker | 29.6.2 (build dfc4efb) |
| kind | v0.33.0 (go1.27.0, darwin/amd64) |
| kubectl (client) | v1.36.1 |
| Trivy | 0.75.0 |
| Nmap | 7.991 |
| Kubescape | 4.0.15 |
| Gitleaks | 8.30.1 |
| Hadolint | 2.15.1 |
| curl | 8.7.1 (LibreSSL 3.3.6) |
| jq | 1.7.1-apple |

Not yet recorded (run inside the cluster or installed later):

| Tool | Recorded in |
|---|---|
| Calico | Phase E |
| Kubernetes server (kind node image) | Phase E |
| kube-bench | Phase K |
| kube-hunter | Phase K |
| rbac-tool / krew | Phase L (not covered by `check-prereqs.sh`) |
