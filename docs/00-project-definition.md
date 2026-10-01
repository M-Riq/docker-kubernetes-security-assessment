# Phase A — Project Definition

> All testing described in this project targets an **intentionally vulnerable, controlled local laboratory**.
> No real production infrastructure, third-party systems or real credentials are used.

Legend: **[Exam]** = requirement from the examination brief. **[Design decision]** = choice made by the assessment team where the brief is silent.

---

## 1. Engagement Summary

| Item | Value |
|---|---|
| Client (fictional) | NovaPay Technologies — payments microservices startup **[Design decision]** |
| Assessor | External security assessment team |
| Engagement type | Pre-production Docker & Kubernetes security assessment / VAPT **[Exam]** |
| Target | Local `kind` cluster `novapay-lab` + lab container images **[Design decision]** |
| Approach | Grey-box: assessor has a workstation on the lab network and a low-privilege kubeconfig **[Design decision]** |

## 2. Objectives

| ID | Objective | Source |
|---|---|---|
| O1 | Assess container images, Docker config, Kubernetes config, RBAC, Secrets, Pods, Services, NetworkPolicies, exposed dashboards/APIs, container privileges | Exam |
| O2 | Follow Recon → Enumeration → Vulnerability Identification → Validation → Controlled Exploitation → Impact Analysis → Remediation → Reporting | Exam |
| O3 | Deliver architecture, container inventory, findings, evidence, risk analysis, remediation, secure configuration recommendations | Exam |
| O4 | Deliver a 13-section report and a 24-minute presentation | Exam |
| O5 | Close every finding with FIND → VALIDATE → FIX → VERIFY | Design decision |
| O6 | Lab reproducible on a laptop with free tools only | Design decision |

## 3. Scope

### In scope
- kind cluster `novapay-lab` (API server, nodes, namespaces `novapay-frontend`, `novapay-backend`, `novapay-data`, `monitoring`)
- Lab images: `web-frontend`, `payments-api`, `auth-svc`, `ops-dashboard`, `postgres`
- Local registry `localhost:5001`
- NodePorts exposed by the lab on localhost
- Repository source, Dockerfiles and manifests

### Out of scope
- Any internet or third-party host, cloud accounts
- The workstation host OS (except demonstrating that a container *could* reach it)
- Denial of service, social engineering, persistence, malware
- Other team members' labs

## 4. Assets & Attack Surface

| Asset | Type | Exposure | Testing point |
|---|---|---|---|
| Kubernetes API (:6443) | Control plane | Workstation | TP1 — RBAC / API |
| Local registry | Image store | Workstation | TP2 — image scanning |
| web-frontend (NodePort 30080) | nginx | External | TP3 |
| payments-api (NodePort 30500) | Flask API + debug endpoint | External | TP3 |
| auth-svc | Flask | Internal | TP5 — segmentation |
| postgres | Database | Internal | TP5 — segmentation |
| ops-dashboard (NodePort 30900) | Admin UI | External | TP4 |

## 5. Security Domains

1. Container images (CVEs, base images, secrets in layers)
2. Docker configuration (root, capabilities, socket)
3. Workload configuration (securityContext, host namespaces, hostPath)
4. RBAC
5. Secrets & ConfigMaps
6. Service exposure (NodePorts, dashboard, API)
7. Network segmentation (NetworkPolicies)
8. Cluster configuration (CIS benchmark)

## 6. Planned Intentional Weaknesses → Expected Findings

Severity is **provisional**; final ratings will be justified in Phase T (likelihood × impact + CVSS 3.1 vector).

| ID | Planned weakness | Asset | Provisional severity |
|---|---|---|---|
| DOCKER-001 | Outdated base image with known CVEs | payments-api | High |
| DOCKER-002 | Container runs as root, no USER directive | payments-api, ops-dashboard | Medium |
| SECRET-001 | Fake credential hardcoded in Dockerfile `ENV` (visible in `docker history`) | payments-api | High |
| SECRET-002 | DB password stored in a ConfigMap instead of a Secret | novapay-backend | Medium |
| SECRET-003 | Kubernetes Secret readable by over-privileged ServiceAccount (base64 ≠ encryption) | novapay-data | High |
| RBAC-001 | ServiceAccount bound to wildcard ClusterRole (`*/*/*`) | ops-dashboard | Critical |
| RBAC-002 | Default ServiceAccount token auto-mounted in all pods | all namespaces | Medium |
| POD-001 | Privileged container with `hostPath: /` mount | ops-dashboard | Critical |
| POD-002 | No securityContext (privilege escalation allowed, writable root FS, all default caps) | most workloads | Medium |
| K8S-001 | Unauthenticated debug endpoint leaking env vars | payments-api | High |
| K8S-002 | Unauthenticated admin dashboard exposed via NodePort | ops-dashboard | High |
| NET-001 | No NetworkPolicies — frontend can reach postgres directly | all namespaces | High |
| NET-002 | Internal services exposed as NodePort instead of ClusterIP | payments-api | Medium |

### Planned controlled attack chains (Phase R)
1. **Exposed dashboard → over-privileged token → read all Secrets** (K8S-002 + RBAC-001 + SECRET-003)
2. **Debug endpoint → leaked DB password → direct DB access from frontend pod** (K8S-001 + NET-001)
3. **Privileged pod → read host filesystem (read-only proof, e.g. `/etc/hostname`)** (POD-001)

All actions are read-only proofs; no destructive commands.

## 7. Tools

| Tool | Purpose | Status |
|---|---|---|
| Docker | Build / inspect images | Exam baseline |
| kubectl | Enumeration, `auth can-i`, apply fixes | Exam baseline |
| Trivy | Image CVEs, secrets, IaC misconfig | Exam baseline |
| kube-bench | CIS benchmark | Exam baseline |
| kube-hunter | Cluster attack surface (note: no longer actively maintained) | Exam baseline |
| Nmap | Port / NodePort discovery | Exam baseline |
| kind + Calico | Local cluster with **enforced** NetworkPolicies (kindnet does not enforce them) | Design decision |
| Kubescape | Workload posture (NSA/MITRE mapping) | Design decision |
| Gitleaks | Secret scanning of repo | Design decision |
| Hadolint | Dockerfile linting | Design decision |
| rbac-tool | RBAC visualisation / who-can | Design decision |
| curl | HTTP request/response evidence | Design decision |

Versions are pinned and recorded in `docs/tools.md` during Phase B.

## 8. Roadmap

| Phase | Name | Main deliverable |
|---|---|---|
| A | Project definition | this document |
| B | Repository initialisation | README skeleton, LICENSE, .gitignore, tools.md |
| C | Lab architecture | Mermaid diagram, asset inventory |
| D | Docker environment | Dockerfiles + app code |
| E | Kubernetes environment | kind config, Calico, namespaces, workloads |
| F | Vulnerability injection | `lab/vulnerable/` manifests |
| G | Rules of Engagement | `docs/rules-of-engagement.md` |
| H | Reconnaissance | Nmap results |
| I | Enumeration | Container & K8s inventory |
| J | Container assessment | Trivy, Hadolint, docker inspect/history |
| K | K8s config assessment | kube-bench, Kubescape, kube-hunter |
| L | RBAC assessment | can-i matrix, rbac-tool |
| M | Secrets assessment | Gitleaks, Trivy secrets |
| N | Pod privilege assessment | securityContext review |
| O | Services & API assessment | curl evidence |
| P | Network policy assessment | connectivity matrix |
| Q | Validation | confirmed findings, false positives removed |
| R | Controlled exploitation | 3 attack chains |
| S | Impact analysis | business impact per finding |
| T | Risk assessment | rated risk register |
| U | Remediation | `lab/hardened/` |
| V | Hardening | Pod Security Admission `restricted`, default-deny |
| W | Verification | re-scan + `scripts/verify.sh` |
| X | Evidence organisation | figure register |
| Y | Final report | `reports/final-report.md` → PDF |
| Z | Presentation | slides outline, demo script |

## 9. Evidence Strategy

- Text output is preferred (diffable, searchable): `evidence/<phase>/<NNN>-<description>.txt`
- Screenshots only when they prove something text cannot (e.g. browser dashboard): `evidence/screenshots/<NNN>-<description>.png`
- Every figure is registered in `evidence/README.md` with number, caption, finding ID and report section.
- Each documentation step needing a capture is marked `[SCREENSHOT REQUIRED]`.

## 10. Report & Presentation

**Report [Exam]:** Cover · Executive Summary · Introduction · Scope · Rules of Engagement · Methodology · Tools · Findings · Risk Analysis · Remediation · Conclusion · References · Appendix.

**Finding template:** ID · Title · Severity · Affected Asset · Category · Description · Technical Evidence · Validation/Exploitation · Impact · Risk · Remediation · Verification · References.

**Presentation (24 min) [Exam]:** Introduction 2 · Scope & Methodology 3 · Technical Assessment 5 · Live Demo 8 · Business Impact 3 · Remediation 3.

## 11. Git Workflow

- Working branch: `project/docker-kubernetes-security-assessment`
- Conventional commits: `feat(lab)`, `feat(k8s)`, `feat(findings)`, `fix(remediation)`, `docs(report)` …
- One commit (or small set) per phase; merge to default branch at the end.

## 12. Validation Strategy

- Manifests: `kubectl apply --dry-run=server` and `trivy config`
- Dockerfiles: `hadolint`
- Repo: `gitleaks detect` (fake secrets allow-listed explicitly in `.gitleaks.toml`)
- Remediation: same command run before and after; `scripts/verify.sh` prints PASS/FAIL per finding.

## 13. Assumptions & Open Decisions

| # | Item | Proposed choice |
|---|---|---|
| D1 | Host OS | Linux or Windows + WSL2, ≥ 8 GB RAM |
| D2 | Cluster | kind + Calico (minikube as fallback) |
| D3 | Dashboard | Custom minimal ops-dashboard instead of the official Kubernetes Dashboard |
| D4 | Fake secrets in repo | Allowed, clearly labelled `LAB_`/`TEST_`/`DEMO_`, allow-listed in Gitleaks |
| D5 | Report format | Markdown in repo, exported to PDF |
| D6 | Documentation language | English (portfolio audience) |
| D7 | Exam document | Requirements taken from the master instruction; to be cross-checked against the official brief |
