# Evidence Register

Every significant claim in the report is backed by an item below.

## Conventions
- Text output (preferred): `evidence/<phase>/<NNN>-<description>.txt`
- Screenshots (only when text cannot prove it): `evidence/screenshots/<NNN>-<description>.png`
- `NNN` is a global, increasing number. Figures in the report reuse it.

## Register

| # | File | Phase | Finding | Caption | Report section |
|---|---|---|---|---|---|
| 000 | `phase-b/000-tool-versions.txt` | B | — | Tool versions used for the assessment | 7 — Tools / Appendix |
| 001 | `screenshots/001-lab-architecture-diagram.png` | C | — | Lab architecture diagram (kind cluster, namespaces, exposures, attack paths) rendered from `docs/architecture/lab-architecture.mmd` | 3 — Introduction / 4 — Scope |
| 002 | `phase-d/002-image-build.txt` | D | DOCKER-001, DOCKER-002, SECRET-001 | Build of lab images: bases pinned by digest in output, full-OS sizes (web 1.47 GB, backend 1.62 GB vs ops-dashboard 228 MB), BuildKit `SecretsUsedInArgOrEnv` warnings for `DB_PASSWORD` / `API_KEY` | 8 — Findings / Appendix |
| 003 | `phase-e/003-cluster-versions.txt` | E | — | kind/Kubernetes/Calico versions, nodes, system pods, images loaded | 7 — Tools / Appendix |
