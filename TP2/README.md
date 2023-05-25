# TP2 : DevOps

*	Configurer un workflow Github action

Nom de l’action qu’on souhaite effectuer, en l’occurrence un build et push d’une image. Ici on souhaite le faire sur la branche Master
```
name: Docker Build and Push Images

on:
  push:
    branches: [master]
```

Passons aux différentes tâches : les jobs




Cette étape permet de build une image. 

```
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      -
        name: Checkout
        uses: actions/checkout@v3
```

Ici, on se connecte au docker hub, où on veut push l’image. On se connecte grâce aux variables secrètes DOCKER_USERNAME et DOCKER_TOKEN, qui sont respectivement les nom d’utilisateurs et mot de passe.
```
name: Login to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}
```

Push de l’image sur Docker.
```
name: Build and push
        uses: docker/build-push-action@v4
        with:
          context: ./TP1
          push: true
          tags: ${{ secrets.DOCKERHUB_USERNAME }}/my-weather-app-2:latest
```

On peut verifier ces actions (build/push) sur Github (si un commit a été fait) et sur Dockerhub (si une image a été push).


*	Transformer un Wrapper en API

Pour cette étape j’ai repris le code du TP1, et adapté pour qu’on puisse avoir un résultat sur un site web et plus particulièrement sur un local host.

Import des librairies nécessaires dont Flask.
```
import os
import requests
import json
from flask import Flask, jsonify,request
```

Cette variable API_KEY est la clé permettant de requêter sur l’API openweather. Ici on la récupère (variable d’environnement) pour éviter de l’écrire en dur.
```
API_KEY = os.environ.get('API_KEY')
```

Décorateur de la fonction get_weather qui permet de définir un chemin pour l’API. Plus précisément, on devra ajouter ‘/weather’ à l’URL genérée par cette fonction avant d’interroger l’api.
```
@app.route('/weather')
```

Permet de générer une page web en local host (0.0.0.0).
```
if __name__ == '__main__':
    app.run(host = '0.0.0.0')
```


*	Commandes pour build, push, requêter et afficher une réponse


Permet d’éxecuter le workflow et donc de build/push une image
```
docker rmi -f sarankansivananthan/my-weather-app-2:latest
```
Permet d’utiliser une image (sarankansivananthan/my-weather-app-2:latest) et obtenir un résultat sur le local host 5000 après execution du script python
```
docker run -p 5000:5000 --env API_KEY=79516e2aea37c0be1937220707cffd74 -it sarankansivananthan/my-weather-app-2:latest
```
L’étape précédente permet de générer un URL en local host et la commande suivante permet de requêter l’API et afficher sa réponse sur ce local host : 

```
curl "http://127.0.0.1:5000/?lat=5.902785&lon=102.754175"
