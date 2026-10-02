#!/usr/bin/env bash
# Delete the lab cluster (frees RAM/CPU). Images stay in Docker.
set -euo pipefail
kind delete cluster --name vapt-lab
