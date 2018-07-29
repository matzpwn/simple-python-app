from flask import Flask
from flask import jsonify

app = Flask(__name__)

@app.route("/")
def index():
    response_data = {}
    response_data['message'] = "welcome"
    response_data['status'] = "ok"
    response = jsonify(response_data)
    return response