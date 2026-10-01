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
_To be filled from `evidence/phase-b/000-tool-versions.txt`._
