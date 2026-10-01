# Decisions Log

Records every **[Design decision]** taken where the examination brief is silent.

| ID | Decision | Status | Rationale |
|---|---|---|---|
| D1 | Workstation: MacBook Pro 2020 **Intel (x86_64)**, 16 GB RAM, macOS (Darwin 25.5) | Confirmed | Assessor hardware; amd64 = all tool images run natively, no emulation |
| D2 | Cluster: kind + Calico | Confirmed | Lightweight, scriptable; Calico required because kindnet does not enforce NetworkPolicies |
| D3 | Custom minimal `ops-dashboard` instead of official Kubernetes Dashboard | Confirmed | Same risk (unauthenticated UI + over-privileged ServiceAccount), easier to understand and demo |
| D4 | Fictional secrets committed, marker `FAKE-LAB`, allow-listed in `.gitleaks.toml` | Confirmed | Lab must be reproducible; values are obviously fake |
| D5 | Report written in Markdown, exported to PDF | Proposed | Diffable, versioned |
| D6 | Documentation in English | Confirmed | Portfolio audience |
| D7 | Official exam brief received and mapped | Confirmed | See [exam-requirements-traceability.md](exam-requirements-traceability.md) |
| D8 | Container runtime: Docker Desktop | Confirmed | Docker 29.6.2 already installed |
| D9 | The brief says the group "has been provided with a controlled Kubernetes environment". No environment was supplied, so the assessor **builds** the controlled lab (Phases C–F) | Proposed | Assumption to confirm with lecturer |
| D10 | Exam requires team roles. Each student performs all roles in their own repo; roles are documented as engagement roles in the RoE, and mapped to presentation sections | Proposed | Satisfies brief without splitting the technical work |

## macOS-specific consequences (D1)

1. **Docker runs inside a VM on macOS.** kind node IPs (172.18.x.x) are *not* routable from the Mac.
   - NodePorts are published to `localhost` with kind `extraPortMappings` (Phase E).
   - External recon (Nmap) targets `127.0.0.1` mapped ports.
   - Internal recon (pod-to-pod, service discovery) runs from a dedicated assessor pod inside the cluster.
2. **CPU architecture: x86_64.** No multi-arch concerns; kube-hunter and kube-bench images run natively.
3. **Resources.** Allocate ~6 GB RAM / 4 CPUs to Docker Desktop (Settings → Resources).
