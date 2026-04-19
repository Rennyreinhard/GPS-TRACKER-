from flask import Flask, request, jsonify, render_template
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from datetime import datetime

app = Flask(__name__)
CORS(app)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///tracking.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)


class Location(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    vehicle_id = db.Column(db.String(50))
    latitude = db.Column(db.Float)
    longitude = db.Column(db.Float)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)


@app.route("/")
def home():
    return "Vehicle Tracking Server Running"


VALID_TOKEN = "MY_SECURE_TOKEN_123"


@app.route("/update", methods=["POST"])
def update_location():
    data = request.json

    if data.get("token") != VALID_TOKEN:
        return jsonify({"error": "Unauthorized"}), 403

    location = Location(
        vehicle_id=data["vehicle_id"],
        latitude=data["latitude"],
        longitude=data["longitude"]
    )

    db.session.add(location)
    db.session.commit()

    return jsonify({"status": "success"})


@app.route("/locations/<vehicle_id>")
def get_locations(vehicle_id):
    location = (
        Location.query
        .filter_by(vehicle_id=vehicle_id)
        .order_by(Location.timestamp.desc())
        .first()
    )

    if location:
        return jsonify([{
            "lat": location.latitude,
            "lon": location.longitude,
            "time": location.timestamp.isoformat()
        }])
    else:
        return jsonify([])


@app.route("/TrackerWeb/<vehicle_id>")
def TrackerWeb_page(vehicle_id):
    return render_template("TrackerWeb.html", vehicle_id=vehicle_id)


if __name__ == "__main__":
    with app.app_context():
        db.create_all()

    app.run(host="127.0.0.1", port=5000, debug=True)

$$$from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    return "Server running"

if __name__ == "__main__":
    app.run(debug=True)
$$$
from flask import Flask, request, jsonify, render_template
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from datetime import datetime

app = Flask(__name__)
CORS(app)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///tracking.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Location(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    vehicle_id = db.Column(db.String(50))
    latitude = db.Column(db.Float)
    longitude = db.Column(db.Float)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)

@app.route("/")
def home():
    return "Vehicle Tracking Server Running"

@app.route("/update", methods=["POST"])
def update_location():
    data = request.json

    location = Location(
        vehicle_id=data["vehicle_id"],
        latitude=data["latitude"],
        longitude=data["longitude"]
    )

    db.session.add(location)
    db.session.commit()

    return jsonify({"status": "success"})

@app.route("/locations/<vehicle_id>")
def get_locations(vehicle_id):
    location = (
        Location.query
        .filter_by(vehicle_id=vehicle_id)
        .order_by(Location.timestamp.desc())
        .first()
    )

    if location:
        return jsonify([{
            "lat": location.latitude,
            "lon": location.longitude,
            "time": location.timestamp.isoformat()
        }])
    else:
        return jsonify([])

@app.route("/TrackerWeb/<vehicle_id>")
def tracker_page(vehicle_id):
    return render_template("TrackerWeb.html", vehicle_id=vehicle_id)

if __name__ == "__main__":
    with app.app_context():
        db.create_all()

    app.run(host="127.0.0.1", port=5000, debug=True)
