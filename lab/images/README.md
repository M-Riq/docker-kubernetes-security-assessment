# Lab Images (Phase D)

**Intentionally vulnerable. Lab use only. All secrets are fictional (`FAKE-LAB`).**
Every weakness is marked in the source with a `# VULN:` comment.

| Image | Tag | Base | Role | Planned findings |
|---|---|---|---|---|
| `web` | `vapt/web:lab` | `python:3.8` (EOL) | Public web front, calls backend | DOCKER-001 |
| `backend` | `vapt/backend:lab` | `python:3.9` | Internal API, talks to PostgreSQL | DOCKER-002, SECRET-001, POD-001/002 (when deployed) |
| `ops-dashboard` | `vapt/ops-dashboard:lab` | `python:3.11-slim` | Unauthenticated dashboard using its ServiceAccount token | K8S-002, RBAC-001/002 |
| `db` | `postgres:13` (upstream, no Dockerfile) | — | Application database | NET-001 (reachable from any pod), SECRET-002 |

PostgreSQL 13 is end-of-life (Nov 2025) and the `13` tag is a floating tag — both are deliberate.

## Build

```bash
bash scripts/lab/build-images.sh
```

Images are loaded into kind in Phase E (`kind load docker-image ...`).

## Hardened counterparts

Fixed versions live in `lab/hardened/` (Phase U): pinned slim/distroless bases by digest,
non-root user, no secrets in layers, multi-stage builds, updated dependencies.
