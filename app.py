import os
import socket

from flask import Flask, jsonify

app = Flask(__name__)

APP_VERSION = os.environ.get("APP_VERSION", "dev")


@app.route("/")
def home():
    return f"""
    <h1>Hello from the CI/CD Pipeline!</h1>
    <p>Version: {APP_VERSION}</p>
    <p>Served by: {socket.gethostname()}</p>
    """


@app.route("/health")
def health():
    return jsonify(status="ok", version=APP_VERSION)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)