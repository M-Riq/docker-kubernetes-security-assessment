"""Public web front of the lab application (intentionally vulnerable)."""
import os

import requests
from flask import Flask, jsonify

app = Flask(__name__)
BACKEND_URL = os.environ.get("BACKEND_URL", "http://backend.vuln-app.svc.cluster.local:5000")


@app.route("/")
def index():
    return "<h1>VAPT Lab - Web</h1><p>Try <a href='/users'>/users</a></p>"


@app.route("/users")
def users():
    r = requests.get(f"{BACKEND_URL}/users", timeout=3)
    return jsonify(r.json())


@app.route("/healthz")
def healthz():
    return "ok"


if __name__ == "__main__":
    # VULN: debug mode enabled -> interactive debugger / stack traces exposed
    app.run(host="0.0.0.0", port=8080, debug=True)
