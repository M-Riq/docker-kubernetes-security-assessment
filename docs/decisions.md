# Decisions Log

Records every **[Design decision]** taken where the examination brief is silent.

| ID | Decision | Status | Rationale |
|---|---|---|---|
| D1 | Workstation: MacBook Pro 2020, 16 GB RAM, macOS | Confirmed | Assessor hardware |
| D2 | Cluster: kind + Calico | Confirmed | Lightweight, scriptable; Calico required because kindnet does not enforce NetworkPolicies |
| D3 | Custom minimal `ops-dashboard` instead of official Kubernetes Dashboard | Confirmed | Same risk (unauthenticated UI + over-privileged ServiceAccount), easier to understand and demo |
| D4 | Fictional secrets committed, marker `FAKE-LAB`, allow-listed in `.gitleaks.toml` | Confirmed | Lab must be reproducible; values are obviously fake |
| D5 | Report written in Markdown, exported to PDF | Proposed | Diffable, versioned |
| D6 | Documentation in English | Confirmed | Portfolio audience |
| D7 | Official exam brief to be cross-checked | Pending | Document not yet received |
| D8 | Container runtime: Docker Desktop (free for personal/education use); Colima as open-source fallback | Proposed | Required by kind on macOS |

## macOS-specific consequences (D1)

1. **Docker runs inside a VM on macOS.** kind node IPs (172.18.x.x) are *not* routable from the Mac.
   - NodePorts will be published to `localhost` with kind `extraPortMappings` (Phase E).
   - External recon (Nmap) targets `127.0.0.1` mapped ports.
   - Internal recon (pod-to-pod, service discovery) runs from a dedicated assessor pod inside the cluster.
2. **CPU architecture.** MacBook Pro 2020 exists in Intel and Apple Silicon (M1) versions.
   On M1 (`arm64`), some tool images are `amd64`-only (e.g. kube-hunter) and run under emulation;
   all lab images will be built for the native architecture.
3. **Resources.** Allocate ~6 GB RAM / 4 CPUs to Docker Desktop (Settings → Resources).
