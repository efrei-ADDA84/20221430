# TP3 : DevOps

###	Configurer un workflow Github action pour créer une image (sous forme d'API) sur Azure Container Registry et la déployer sur Azure Container Instance 

* Le déclencheur de ce workflow est un push sur la branche master. Cela signifie que le workflow sera exécuté chaque fois qu'un push est effectué sur la branche master.
```
name: Azure

on:
  push:
    branches: [master] 
```

Passons aux différentes tâches : les jobs


* Cette étape "Checkout repository" utilise l'action actions/checkout@v2 pour récupérer le contenu du référentiel GitHub dans le runner GitHub Actions.

```
jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
        - name: Checkout repository
          uses: actions/checkout@v2
```

* L'étape "Login to Azure" utilise l'action azure/login@v1 pour se connecter à Azure en utilisant les informations d'identification fournies dans le secret github AZURE_CREDENTIALS. 

```
 - name: Login to Azure
          uses: azure/login@v1
          with:
            creds: ${{ secrets.AZURE_CREDENTIALS }}
```

* L'étape "Build and push Docker image" utilise l'action azure/docker-login@v1 pour se connecter à mon Azure Container Registry (ACR) en utilisant les informations d'identification fournies dans les secrets REGISTRY_LOGIN_SERVER, REGISTRY_USERNAME et REGISTRY_PASSWORD. 
Ensuite, la commande docker build est utilisée pour construire l'image Docker en se basant sur le Dockerfile spécifié (./TP3) et la version v1. Puis l'image Docker est poussée vers l'ACR.

```
 - name: Build and push Docker image
          uses: azure/docker-login@v1
          with:
            login-server: ${{ secrets.REGISTRY_LOGIN_SERVER }}
            username: ${{ secrets.REGISTRY_USERNAME }}
            password: ${{ secrets.REGISTRY_PASSWORD }}
        - run: |
            docker build ./TP3 -t ${{ secrets.REGISTRY_LOGIN_SERVER }}/20221430:v1
            docker push ${{ secrets.REGISTRY_LOGIN_SERVER }}/20221430:v1
```


* L'étape "Deploy to Azure Container Instance (ACI)" utilise l'action azure/aci-deploy@v1 pour déployer l'image Docker précédemment construite sur un Azure Container Instance (ACI). Les paramètres suivants sont spécifiés :

	- resource-group: Le groupe de ressources Azure dans lequel déployer l'ACI.
	- dns-name-label: L'étiquette du nom de domaine DNS pour l'ACI.
	- image: L'image Docker à déployer, spécifiée à l'aide du secret REGISTRY_LOGIN_SERVER et de la version.
	- registry-login-server, registry-username et registry-password: Les informations d'identification de notre ACR.
	- name: Le nom de l'ACI.
	- location: La région Azure dans laquelle déployer l'ACI.
	- ports: Les ports à exposer sur l'ACI (dans cet exemple, le port 80 est exposé). Et sur le quel les réponses de notre reqête API seront affichées.
	- secure-environment-variables: Variable API_KEY qui est récupérée à partir du secret API_KEY. C'est aussi la variable d'environnement utilisée dans notre wrapper.

```
        - name: Deploy to Azure Container Instance (ACI)
          uses: azure/aci-deploy@v1
          with:
            resource-group: ${{ secrets.RESOURCE_GROUP }}
            dns-name-label: devops-20221430
            image: ${{ secrets.REGISTRY_LOGIN_SERVER }}/20221430:v1
            registry-login-server: ${{ secrets.REGISTRY_LOGIN_SERVER }}
            registry-username: ${{ secrets.REGISTRY_USERNAME }}
            registry-password: ${{ secrets.REGISTRY_PASSWORD }}
            name: 20221430
            location: westeurope
            ports: 80 
            secure-environment-variables: API_KEY=${{ secrets.API_KEY }}
```

On peut verifier ces actions (build/push) sur Github (si un commit a été fait) et Azure  grâce au timestamp.


* Cette commande permet de requêter sur l'API. Elle prend en paramètres:
	- le nom du container instance (20221430)
	- le nom du domaine (westeurope)
	- la root (weather)
	- le numéro de port (80)
	- les paramètres de latitude, longitude

```
curl "http://devops-20221430.westeurope.azurecontainer.io:80/weather?lat=5.902785&lon=102.754175"
```
Réponse:
```
{"base":"stations","clouds":{"all":81},"cod":200,"coord":{"lat":5.9028,"lon":102.7542},"dt":1685222309,"id":1736405,"main":{"feels_like":25.95,"grnd_level":980,"humidity":76,"pressure":1007,"sea_level":1007,"temp":25.95,"temp_max":25.95,"temp_min":25.95},"name":"Jertih","sys":{"country":"MY","sunrise":1685228009,"sunset":1685272752},"timezone":28800,"visibility":10000,"weather":[{"description":"broken clouds","icon":"04n","id":803,"main":"Clouds"}],"wind":{"deg":237,"gust":2.45,"speed":2.46}}

```








