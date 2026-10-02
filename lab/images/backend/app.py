"""Internal API of the lab application (intentionally vulnerable)."""
import os

import psycopg2
from flask import Flask, jsonify

app = Flask(__name__)


def conn():
    return psycopg2.connect(
        host=os.environ["DB_HOST"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
        dbname=os.environ.get("DB_NAME", "appdb"),
        connect_timeout=3,
    )


@app.route("/users")
def users():
    with conn() as c, c.cursor() as cur:
        cur.execute("SELECT id, username, email FROM users")
        rows = cur.fetchall()
    return jsonify([{"id": r[0], "username": r[1], "email": r[2]} for r in rows])


@app.route("/debug/env")
def debug_env():
    # VULN: SECRET-001 - leaks every environment variable, including DB_PASSWORD
    return jsonify(dict(os.environ))


@app.route("/healthz")
def healthz():
    return "ok"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
