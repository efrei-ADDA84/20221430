import os
import requests
import json
from flask import Flask, jsonify,request

app = Flask(__name__)

API_KEY = '79516e2aea37c0be1937220707cffd74'
#os.environ.get('API_KEY')

@app.route('/weather')
def get_weather():
    LATITUDE = request.args.get('lat')
    LONGITUDE = request.args.get('lon')
    url = f'https://api.openweathermap.org/data/2.5/weather?lat={LATITUDE}&lon={LONGITUDE}&appid={API_KEY}&units=metric'
    return requests.get(url).json()

if __name__ == '__main__':
    app.run(host = '0.0.0.0')
