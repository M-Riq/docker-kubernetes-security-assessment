"""ops-dashboard: minimal cluster dashboard (intentionally vulnerable, see decision D3).

VULN: K8S-002 - no authentication at all; anyone reaching the NodePort sees cluster data.
VULN: RBAC-001/002 - every request uses the pod's ServiceAccount token; if that SA is
      over-privileged, the dashboard becomes a proxy to read Secrets cluster-wide.
"""
import requests
from flask import Flask, jsonify, abort

SA_DIR = "/var/run/secrets/kubernetes.io/serviceaccount"
API = "https://kubernetes.default.svc"

app = Flask(__name__)


def k8s_get(path):
    with open(f"{SA_DIR}/token") as f:
        token = f.read().strip()
    r = requests.get(
        f"{API}{path}",
        headers={"Authorization": f"Bearer {token}"},
        verify=f"{SA_DIR}/ca.crt",
        timeout=5,
    )
    if r.status_code != 200:
        abort(r.status_code, r.text)
    return r.json()


@app.route("/")
def index():
    return (
        "<h1>ops-dashboard</h1><ul>"
        "<li><a href='/api/namespaces'>namespaces</a></li>"
        "<li><a href='/api/pods'>pods</a></li>"
        "<li><a href='/api/secrets'>secrets</a></li>"
        "</ul>"
    )


@app.route("/api/namespaces")
def namespaces():
    return jsonify([i["metadata"]["name"] for i in k8s_get("/api/v1/namespaces")["items"]])


@app.route("/api/pods")
def pods():
    items = k8s_get("/api/v1/pods")["items"]
    return jsonify([f"{p['metadata']['namespace']}/{p['metadata']['name']}" for p in items])


@app.route("/api/secrets")
def secrets():
    # VULN: returns Secret data (base64) from every namespace
    items = k8s_get("/api/v1/secrets")["items"]
    return jsonify([
        {"ns": s["metadata"]["namespace"], "name": s["metadata"]["name"], "data": s.get("data", {})}
        for s in items
    ])


@app.route("/healthz")
def healthz():
    return "ok"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
