from flask import Flask, request, jsonify, render_template
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from flask_socketio import SocketIO
from datetime import datetime

# app = Flask(__name__)
# CORS(app)

# app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///tracking.db'
# app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# db = SQLAlchemy(app)


app = Flask(__name__)
CORS(app)

# 🔴 DATABASE CONFIG (MISSING IN YOUR CODE)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///tracking.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# 🔴 NOW CREATE DB
db = SQLAlchemy(app)

# 🔴 SOCKET IO
socketio = SocketIO(app, cors_allowed_origins="*")


class Vehicle(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    vehicle_id = db.Column(db.String(50), unique=True)
    latitude = db.Column(db.Float)
    longitude = db.Column(db.Float)
    timestamp = db.Column(
        db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)


@app.route("/phone")
def phone():
    return render_template("Myphonetracker.html")


@app.route("/")
def home():
    return render_template("FleetDashboard.html")


@app.route("/update", methods=["POST"])
def update_location():
    data = request.json

    vehicle = Vehicle.query.filter_by(vehicle_id=data["vehicle_id"]).first()

    if vehicle:
        vehicle.latitude = data["latitude"]
        vehicle.longitude = data["longitude"]
        vehicle.timestamp = datetime.utcnow()
    else:
        vehicle = Vehicle(
            vehicle_id=data["vehicle_id"],
            latitude=data["latitude"],
            longitude=data["longitude"]
        )
        db.session.add(vehicle)

    db.session.commit()

    return jsonify({"status": "success"})


@app.route("/vehicles")
def get_vehicles():
    try:
    vehicles = Vehicle.query.all()

    return jsonify([
        {
            "vehicle_id": v.vehicle_id,
            "latitude": v.latitude,
            "longitude": v.longitude
        }
        for v in vehicles
    ])
except Exception as e:
        return jsonify({"error": str(e)}), 500

        
if __name__ == "__main__":
    with app.app_context():
        db.create_all()

    app.run(host="0.0.0.0", port=5000)
 #   socketio.run(
     #   app,
      #  host="0.0.0.0",   # 🔴 THIS IS THE KEY FIX
      #  port=5000,
     #   debug=True,
      #  allow_unsafe_werkzeug=True
   # )
# if __name__ == "__main__":
    # db.create_all()

    # app.run(host="127.0.0.1", port=5000, debug=True)
# socketio.run(app, host="0.0.0.0", port=5000, debug=True)

      
 #   app.run(host="1.2.3.4", port=5000, debug=True)..YOU WILL NEED TO FIND YOUR OWN PC HOST AND PORT EG("0.0.0.1")


