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

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5002)