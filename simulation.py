import requests
import time
import random

SERVER_URL = "http://127.0.0.1:5000/update"
VEHICLE_ID = "CAR_001"

CENTER_LAT = -0.303099
CENTER_LON = 36.080025

lat = CENTER_LAT
lon = CENTER_LON

while True:
    # Simulate small movements
    lat += random.uniform(-0.0005, 0.0005)
    lon += random.uniform(-0.0005, 0.0005)

    data = {
        "vehicle_id": VEHICLE_ID,
        "latitude": lat,
        "longitude": lon
    }

    try:
        response = requests.post(SERVER_URL, json=data)
        print("Sent:", data, response.json())
    except Exception as e:
        print("Error:", e)

    time.sleep(10)

#for desired locations
"""import requests
import time
import random

SERVER_URL = "http://127.0.0.1:5000/update"
VEHICLE_ID = "CAR_001"

# Define a route as a list of (lat, lon) tuples
ROUTE = [
    (-0.303099, 36.080025),
    (-0.303200, 36.080100),
    (-0.303300, 36.080200),
    (-0.303400, 36.080300),
    (-0.303500, 36.080400),
]

route_index = 0

while True:
    lat, lon = ROUTE[route_index]

    # Optional small random wobble
    lat += random.uniform(-0.00005, 0.00005)
    lon += random.uniform(-0.00005, 0.00005)

    data = {
        "vehicle_id": VEHICLE_ID,
        "latitude": lat,
        "longitude": lon
    }

    try:
        response = requests.post(SERVER_URL, json=data)
        print("Sent:", data, response.json())
    except Exception as e:
        print("Error:", e)

    # Move to next point in route
    route_index += 1
    if route_index >= len(ROUTE):
        route_index = 0  # loop back to start

    time.sleep(5)  # every 5 seconds
