import serial
import requests
import time

SERVER_URL = "http://127.0.0.1:5000/update" #"https://potbelly-irreplaceable-tera.ngrok-free.devpython" SERVER_URL = "https://your-ngrok-url.ngrok-free.app/update"

TOKEN = "MY_SECURE_TOKEN_123"

ser = serial.Serial("COM3", baudrate=9600, timeout=1)  # replace COM3 with your port

def parse_gpgga(sentence):
    parts = sentence.split(",")
    try:
        if parts[2] and parts[4]:
            lat_deg = int(float(parts[2]) / 100)
            lat_min = float(parts[2]) - lat_deg * 100
            lat = lat_deg + lat_min / 60

            lon_deg = int(float(parts[4]) / 100)
            lon_min = float(parts[4]) - lon_deg * 100
            lon = lon_deg + lon_min / 60

            if parts[3] == "S":
                lat = -lat
            if parts[5] == "W":
                lon = -lon

            return lat, lon
    except:
        pass
    return None, None

while True:
    line = ser.readline().decode(errors='ignore')
    if "GPGGA" in line:
        lat, lon = parse_gpgga(line)
        if lat and lon:
            print("Sending:", lat, lon)
            try:
                response = requests.post(SERVER_URL, json={
                    "vehicle_id": "CAR_001",
                    "latitude": lat,
                    "longitude": lon,
                    "token": TOKEN
                })
                print(response.json())
            except Exception as e:
                print("Error sending data:", e)
    time.sleep(5)
