import json
from flask import Flask, request
import db

DB = db.DatabaseDriver()

app = Flask(__name__)

@app.route("/")
def server():
    return {
        "version": "1.0.0",
        "status": "running",
        "message": "Server is up and running!"
    }


@app.route("/login", methods=["POST"])
def login():
    username = request.form.get("username")
    password = request.form.get("password")

    if username == "admin" and password == "password":
        # change soon shit system
        return {
            "status": "success",
            "message": "Login successful!"
        }
    else:
        return {
            "status": "error",
            "message": "Invalid credentials!"
        }, 401
    

