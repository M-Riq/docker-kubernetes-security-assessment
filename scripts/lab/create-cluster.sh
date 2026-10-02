#!/usr/bin/env bash
# Phase E - create the kind cluster, install Calico, load lab images, record evidence 003.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CLUSTER=vapt-lab
EVIDENCE="${ROOT}/evidence/phase-e/003-cluster-versions.txt"
IMAGES=(vapt/web:lab vapt/backend:lab vapt/ops-dashboard:lab postgres:13)

# Calico version: override with CALICO_VERSION=vX.Y.Z, otherwise latest GitHub release
CALICO_VERSION="${CALICO_VERSION:-$(curl -fsSL https://api.github.com/repos/projectcalico/calico/releases/latest | jq -r .tag_name)}"

echo "== 1/5 Create kind cluster ${CLUSTER} =="
if kind get clusters | grep -qx "${CLUSTER}"; then
  echo "Cluster already exists, skipping creation"
else
  kind create cluster --config "${ROOT}/lab/cluster/kind-config.yaml"
fi
kubectl config use-context "kind-${CLUSTER}"

echo "== 2/5 Install Calico ${CALICO_VERSION} =="
kubectl apply -f "https://raw.githubusercontent.com/projectcalico/calico/${CALICO_VERSION}/manifests/calico.yaml"

echo "== 3/5 Wait for nodes and Calico =="
kubectl -n kube-system rollout status daemonset/calico-node --timeout=300s
kubectl wait --for=condition=Ready nodes --all --timeout=300s

echo "== 4/5 Load lab images into all nodes =="
for img in "${IMAGES[@]}"; do
  kind load docker-image "${img}" --name "${CLUSTER}"
done

echo "== 5/5 Record evidence 003 =="
mkdir -p "$(dirname "${EVIDENCE}")"
{
  echo "== Cluster versions ($(date -u +%Y-%m-%dT%H:%M:%SZ)) =="
  echo "-- kind --";            kind version
  echo "-- kubectl / server --"; kubectl version
  echo "-- Calico --";          echo "${CALICO_VERSION}"
  kubectl -n kube-system get daemonset calico-node -o jsonpath='{.spec.template.spec.containers[0].image}{"\n"}'
  echo "-- Nodes --";           kubectl get nodes -o wide
  echo "-- Node image --";      docker inspect "${CLUSTER}-control-plane" --format '{{.Config.Image}}'
  echo "-- System pods --";     kubectl get pods -n kube-system -o wide
  echo "-- Images loaded on control-plane --"
  docker exec "${CLUSTER}-control-plane" crictl images | grep -E 'vapt/|postgres' || true
} | tee "${EVIDENCE}"

echo "Done. Evidence written to ${EVIDENCE}"
