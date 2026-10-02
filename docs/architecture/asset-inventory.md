# Planned Asset Inventory

Target assets of the lab. The **observed** container inventory is produced in Phase I
(`assessment/enumeration/`) and must be reconciled with this table.

| ID | Asset | Namespace | Type | Exposure | Linked finding(s) |
|---|---|---|---|---|---|
| A01 | kube-apiserver | kube-system | Control plane | `127.0.0.1:6443` | K8S-001 |
| A02 | Cluster configuration (nodes, kubelet, etcd) | kube-system | Config | Internal | kube-bench / Kubescape |
| A03 | `web` Deployment + Service | vuln-app | Workload | NodePort 30080 | DOCKER-001, NET-002 |
| A04 | `backend` Deployment | vuln-app | Workload | ClusterIP | POD-001, POD-002, SECRET-001 |
| A05 | `db` Deployment + Service | vuln-app | Workload | ClusterIP | NET-001 |
| A06 | Application Secrets / ConfigMaps | vuln-app | Secret | API | SECRET-002, SECRET-003 |
| A07 | Container images + Dockerfiles | — | Image | Local registry / kind load | DOCKER-001, DOCKER-002, SECRET-001 |
| A08 | `ops-dashboard` Deployment + Service | ops | Workload | NodePort 30090 | K8S-002 |
| A09 | `ops-dashboard` ServiceAccount + bindings | ops | RBAC | API | RBAC-001, RBAC-002 |
| A10 | NetworkPolicies (absent) | vuln-app, ops | Network | — | NET-001 |
| — | `assessor` pod | assessor | Tooling | — | Out of scope (assessor) |

Finding IDs follow [exam-requirements-traceability.md](../exam-requirements-traceability.md).
