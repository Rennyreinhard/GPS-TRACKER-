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
$$$$
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Fleet Dashboard</title>

  <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />

  <style>
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      display: flex;
      height: 100vh;
      overflow: hidden;
    }

    /* Sidebar */
    .sidebar {
      width: 300px;
      background: #111827;
      color: white;
      padding: 20px;
      box-sizing: border-box;
    }

    .title {
      font-size: 20px;
      font-weight: bold;
      margin-bottom: 20px;
    }

    .vehicle {
      background: #1f2937;
      padding: 10px;
      margin-bottom: 10px;
      border-radius: 8px;
      cursor: pointer;
    }

    .status {
      font-size: 12px;
      margin-top: 5px;
    }

    .online {
      color: #22c55e;
    }

    .offline {
      color: #ef4444;
    }

    /* Map */
    #map {
      flex: 1;
      height: 100vh;
    }
  </style>
</head>
<body>

  <div class="sidebar">
    <div class="title">🚗 Fleet Dashboard</div>

    <div class="vehicle" onclick="focusVehicle('CAR_001')">
      CAR_001
      <div class="status online">● Online</div>
      <div style="font-size:12px;">Last update: just now</div>
    </div>

    <div class="vehicle" onclick="focusVehicle('CAR_002')">
      CAR_002
      <div class="status offline">● Offline</div>
      <div style="font-size:12px;">Last update: 2h ago</div>
    </div>
  </div>

  <div id="map"></div>

  <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>

  <script>
    const map = L.map('map').setView([-1, 36], 6);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19
    }).addTo(map);

    const marker = L.marker([-1, 36]).addTo(map);

    let currentVehicle = "CAR_001";

    async function fetchData() {
      try {
        const res = await fetch(`/locations/${currentVehicle}`);
        const data = await res.json();

        if (data.length > 0) {
          const lat = data[0].lat;
          const lon = data[0].lon;

          marker.setLatLng([lat, lon]);
          map.setView([lat, lon], 14);
        }
      } catch (err) {
        console.log(err);
      }
    }

    function focusVehicle(id) {
      currentVehicle = id;
      fetchData();
    }

    setInterval(fetchData, 3000);
    fetchData();
  </script>

</body>
</html>
