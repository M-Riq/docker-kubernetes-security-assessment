# Docker & Kubernetes Security Assessment

> **Authorized security assessment of an intentionally vulnerable, controlled laboratory.**
> The client (*NovaPay Technologies*) is fictional. All credentials in this repository are fake
> (marked `FAKE-LAB`). No real production systems, third-party hosts or real credentials are involved.

**Status:** 🚧 In progress — Phase B (repository initialisation) complete.

## Overview
End-to-end security assessment (VAPT) of a containerised microservices platform running on Kubernetes:
DISCOVER → ENUMERATE → IDENTIFY → VALIDATE → ASSESS IMPACT → REMEDIATE → HARDEN → VERIFY → DOCUMENT.

## Client Scenario
NovaPay Technologies, a payments start-up, wants an independent assessment of its Docker/Kubernetes
platform before going to production. See [docs/00-project-definition.md](docs/00-project-definition.md).

## Objectives
See [Project definition §2](docs/00-project-definition.md#2-objectives).

## Architecture
_Planned — Phase C._

## Attack Surface
See [Project definition §4](docs/00-project-definition.md#4-assets--attack-surface).

## Security Assessment Methodology
Reconnaissance → Enumeration → Vulnerability Identification → Validation → Controlled Exploitation →
Impact Analysis → Remediation → Reporting.

## Technologies
Docker · kind (Kubernetes in Docker) · Calico · Python/Flask · nginx · PostgreSQL

## Tools
See [docs/tools.md](docs/tools.md).

## Laboratory Setup
_Planned — Phases D/E._ Prerequisite check: `./scripts/setup/check-prereqs.sh`

## Assessment Phases
See [roadmap](docs/00-project-definition.md#8-roadmap).

## Key Findings
_Planned — Phase Q._

## Risk Analysis
_Planned — Phase T._

## Remediation
_Planned — Phase U._

## Security Hardening
_Planned — Phase V._

## Evidence
See [evidence/README.md](evidence/README.md).

## Project Structure
```
docs/          Planning, tools, decisions, methodology, Rules of Engagement
lab/           Lab source: Dockerfiles, app code, vulnerable & hardened manifests (Phases D–F, U)
assessment/    Per-domain assessment notes and commands (Phases H–R)
scripts/       Setup, scanning, verification scripts
evidence/      Raw evidence (text output, screenshots) + figure register
reports/       Findings and final report (Phases S–Y)
presentation/  Slides outline, demo script, speaker notes (Phase Z)
```

## How to Reproduce the Lab
_Planned — Phase E._

## How to Run the Assessment
_Planned — Phases H–R._

## How to Verify Remediation
_Planned — Phase W._

## Lessons Learned
_Planned — Phase Z._

## Disclaimer
This project is for education and authorised testing only. The techniques shown must only be used
against systems you own or are explicitly authorised to test.
