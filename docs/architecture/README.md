# Lab Architecture (Phase C)

Describes the **controlled Kubernetes environment** built for the assessment (see decision D9).
Satisfies the exam deliverable *"Kubernetes architecture"*.

Diagram: [lab-architecture.mmd](lab-architecture.mmd) · Targets: [asset-inventory.md](asset-inventory.md)

## 1. Host

| Item | Value |
|---|---|
| Workstation | MacBook Pro 2020 Intel x86_64, 16 GB RAM, macOS (D1) |
| Runtime | Docker Desktop (D8), ~6 GB RAM / 4 CPUs allocated |
| Cluster tool | kind (D2) |

## 2. Cluster topology

| Node | Role | Notes |
|---|---|---|
| `vapt-lab-control-plane` | control-plane | API server, etcd, scheduler, controller-manager; `extraPortMappings` to localhost |
| `vapt-lab-worker` | worker | Workloads |
| `vapt-lab-worker2` | worker | Workloads (allows cross-node pod traffic tests) |

- **CNI:** Calico (kind default CNI disabled) — required to enforce NetworkPolicies.
- **Kubernetes API:** `https://127.0.0.1:6443` (kind default binding, localhost only).

## 3. Namespaces

| Namespace | Purpose | Intentional weaknesses |
|---|---|---|
| `vuln-app` | Deliberately misconfigured application (web + backend + DB) | Vulnerable/unpinned images, hardcoded secrets, privileged pods, no NetworkPolicy |
| `ops` | `ops-dashboard` (D3) | Unauthenticated UI exposed via NodePort; ServiceAccount bound to `cluster-admin`-like rights |
| `assessor` | Assessor pod (internal recon) | None — assessor tooling only, out of target scope |
| `kube-system` | Cluster components | Assessed with kube-bench / Kubescape (read-only) |

## 4. Exposure (macOS consequence of D1)

kind node IPs (172.18.x.x) are not routable from macOS, so NodePorts are published on `localhost`:

| Service | NodePort | Host mapping | Phase |
|---|---|---|---|
| `vuln-app/web` | 30080 | `127.0.0.1:30080` | O |
| `ops/ops-dashboard` | 30090 | `127.0.0.1:30090` | O |

## 5. Data flows

1. Assessor (macOS) → `127.0.0.1:30080` / `:30090` → NodePort → pods (external view).
2. Assessor (macOS) → `127.0.0.1:6443` → API server (kubectl, RBAC checks).
3. `assessor` pod → any pod / Service in cluster (internal view; proves missing isolation).
4. `vuln-app/web` → `vuln-app/backend` → `vuln-app/db`.
5. `ops-dashboard` → API server using its ServiceAccount token.

## 6. Trust boundaries

- **B1** Host ↔ cluster (localhost port mappings).
- **B2** Namespace ↔ namespace (expected to be isolated; NET-001 shows it is not).
- **B3** Pod ↔ node (broken by privileged pods / hostPath: POD-001).
- **B4** Workload ↔ API server (broken by over-privileged ServiceAccounts: RBAC-001/002).

## 7. Hardened variant

`lab/hardened/` mirrors the same topology with fixes (Phases U–V): pinned/scanned images,
non-root + read-only rootfs, default-deny NetworkPolicies, least-privilege RBAC,
secrets out of manifests, dashboard not exposed / authenticated.

## 8. Build phases

| Phase | Output |
|---|---|
| D | Images (`lab/images/`) |
| E | `kind` cluster config + Calico (`lab/cluster/`) |
| F | Vulnerable manifests deployed (`lab/vulnerable/`) |
