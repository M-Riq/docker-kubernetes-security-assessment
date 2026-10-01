# Exam Requirements Traceability

Source: *VAPT Level 4 — Final Group Projects*, Group 6 — "Container and Kubernetes Security Assessment".
Each requirement is mapped to where it is satisfied in this repository.

## Objectives (assess the security of)

| Requirement | Phase | Planned finding(s) |
|---|---|---|
| Container images | J | DOCKER-001, DOCKER-002 |
| Docker configuration | J | DOCKER-002, SECRET-001 |
| Kubernetes configuration | K | kube-bench / Kubescape results |
| Kubernetes RBAC | L | RBAC-001, RBAC-002 |
| Secrets | M | SECRET-001/002/003 |
| Pods | N | POD-001, POD-002 |
| Services | O | NET-002 |
| Network policies | P | NET-001 |
| Exposed dashboards/APIs | O | K8S-001, K8S-002 |
| Container privileges | N | POD-001, POD-002 |

## Areas to investigate

| Area | Finding(s) |
|---|---|
| Vulnerable container images | DOCKER-001 |
| Hardcoded secrets | SECRET-001 |
| Excessive container privileges | POD-001, POD-002, DOCKER-002 |
| Insecure Kubernetes RBAC | RBAC-001, RBAC-002 |
| Exposed services | K8S-002, NET-002 |
| Misconfigured workloads | POD-002 |
| Weak network isolation | NET-001 |
| Insecure Kubernetes secrets | SECRET-002, SECRET-003 |
| Poor configuration management | SECRET-002, unpinned image tags (Phase J/K) |

## Suggested tools

Docker, kubectl, Trivy, kube-bench, kube-hunter, Nmap, Kubernetes security tools (Kubescape, rbac-tool) — see [tools.md](tools.md).

## Deliverables

| Deliverable | Location (planned) |
|---|---|
| Kubernetes architecture | `docs/architecture/` (Phase C) |
| Container inventory | `assessment/enumeration/` (Phase I) |
| Security assessment | `assessment/` (Phases H–R) |
| Vulnerability findings | `reports/findings/` |
| Evidence | `evidence/` |
| Risk analysis | `reports/` (Phase T) |
| Remediation | `lab/hardened/` + report §10 (Phase U) |
| Secure configuration recommendations | report §10 + `lab/hardened/` (Phase V) |

## Common requirements

| Requirement | Where |
|---|---|
| 1. Team structure (Team Lead, Recon/Enumeration Analyst, Vulnerability Analyst, Exploitation Analyst, Documentation/Reporting Lead) | RoE §Engagement roles (Phase G); see decision D10 |
| 2. Rules of Engagement (client, scope, targets, period, methodology, tools, limitations, prohibited activities, evidence handling) | `docs/rules-of-engagement.md` (Phase G) |
| 3. Evidence, each screenshot explained | `evidence/README.md` register |
| 4. Finding format (Title, Description, Affected Asset, Technical Evidence, Validation/Exploitation, Impact, Risk, Remediation, Verification) | `reports/findings/_template.md` |

## Final report

| Section | Notes from brief |
|---|---|
| 1. Cover page | University, Course, Project title, Group number, Group members, Lecturer, Date |
| 2. Executive summary | Non-technical: what, why, major observations, overall implications, key recommendations |
| 3–13 | Introduction, Scope, RoE, Methodology, Tools, Findings, Risk Analysis, Remediation, Conclusion, References, Appendix |

## Presentation (24 min)

Introduction 2 · Scope & Methodology 3 · Technical Assessment 5 · Live Demonstration 8 · Business Impact 3 · Remediation 3 → `presentation/` (Phase Z).

## Information still needed for the cover page

University · Course · Group members · Lecturer · Submission date.
