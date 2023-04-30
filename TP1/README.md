# TP1 : DevOps

*	Créer un repository Github avec pour nom votre identifiant EFREI

https://github.com/efrei-ADDA84/20221430.git


*	Créer un wrapper qui retourne la météo d’un lieu donné avec sa latitude et longitude (passées en variable d’environnement) en utilisant openweather API

```
import os
import requests
API_KEY = os.environ.get('API_KEY') #'79516e2aea37c0be1937220707cffd74'
LATITUDE = os.environ.get('LAT') #'31.2504'
LONGITUDE = os.environ.get('LONG') #'-99.2506'

def get_weather(LATITUDE, LONGITUDE, API_KEY):
    url = f'https://api.openweathermap.org/data/2.5/weather?lat={LATITUDE}&lon={LONGITUDE}&appid={API_KEY}&units=metric'
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        temperature = data['main']['temp']
        weather_description = data['weather'][0]['description']
        feeled_temp = data['main']['feels_like']
        wind_speed = data['wind']['speed']

        return f'Temperature: {temperature}°C\nFeels like: {feeled_temp}°C\nWind speed: {wind_speed} km/h\nWeather: {weather_description}'
    else:
        return 'Error getting weather data'

print(get_weather(LATITUDE, LONGITUDE, API_KEY))
```


1.	Les modules os et requests sont importés pour utiliser respectivement les variables d'environnement et effectuer des requêtes HTTP. 
2.	Les variables d'environnement API_KEY, LATITUDE et LONGITUDE sont définies à l'aide de la méthode os.environ.get(). API_KEY est la clé d'API OpenWeatherMap, LATITUDE est la latitude du lieu recherché, et LONGITUDE est sa longitude. 
3.	Une fonction get_weather est définie, prenant en paramètres la latitude, la longitude et la clé d'API. Cette fonction va utiliser ces informations pour effectuer une requête à l'API OpenWeatherMap, en utilisant la méthode requests.get(). La requête contient les informations nécessaires pour récupérer les données de météo pour le lieu spécifié, en utilisant l'URL de l'API. 
4.	Si la réponse HTTP renvoyée par l'API a un code de statut 200 (OK), alors la réponse est analysée en utilisant la méthode response.json(), et les données de météo requises sont extraites de cette réponse JSON. Ces données incluent la température, la description de la météo, la température ressentie et la vitesse du vent. Ces données sont retournées sous forme de chaîne de caractères. 
5.	Si la réponse HTTP a un code de statut différent de 200, la fonction get_weather retourne la chaîne de caractères "Error getting weather data". 
6.	Enfin, la fonction get_weather est appelée avec les variables LATITUDE, LONGITUDE et API_KEY, et le résultat est affiché à l'aide de la fonction print(). 



*	Packager son code dans une image Docker

docker pull python:3.9.7 : cette ligne de commande est une commande Docker qui permet de télécharger l'image Docker Python version 3.9.7 à partir du hub Docker.
Elle télécharge une image Docker pré-construite contenant l'installation de Python version 3.9.7 et stocke localement sur le pc Docker.

docker build -t my-weather-app : permet de construire une image Docker personnalisée en se basant sur les instructions du fichier Dockerfile situé dans le répertoire courant. Elle construit une nouvelle image Docker en utilisant le Dockerfile situé dans le répertoire courant, et la nomme my-weather-app à l'aide du paramètre -t. 

docker tag my-weather-app sarankansivananthan/my-weather-app : permet de renommer une image Docker existante. Elle renomme l'image Docker nommée my-weather-app en la renommant en sarankansivananthan/my-weather-app. Cela signifie que l'image existante peut être référencée par deux noms différents, ce qui peut être utile pour faciliter l'identification et la gestion des images dans un projet.



* Mettre à disposition son image su Dockerhub 


docker push sarankansivananthan/my-weather-app

Permet de pousser une image Docker vers un registre Docker. Elle envoie l'image Docker nommée sarankansivananthan/my-weather-app vers le registre Docker. Une fois que l'image est poussée vers le registre Docker, elle peut être récupérée et utilisée par d'autres utilisateurs ou systèmes. 


*	Appel du wrapper

docker run --env LAT="31.2504" --env LONG="-99.2506" --env api_key="79516e2aea37c0be1937220707cffd74" sarankansivananthan/my-weather-app:latest

