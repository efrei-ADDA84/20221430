# TP4 : DevOps

###	Objectifs:
## *Créer une machine virtuelle Azure (VM) avec une adresse IP publique dans un réseau existant ( network-tp4 )
## *Utiliser Terraform
## *Se connecter à la VM avec SSH

Le premier code Terraform ptoviders.tf est utilisé pour déployer et gérer des ressources sur Microsoft Azure.

Le code que vous avez partagé comprend deux parties principales : 

La première partie,  est utilisée pour spécifier le fournisseur `azurerm` et sa version 3.0.0. 

```
required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
```

La deuxième partie, `provider "azurerm"`, configure le fournisseur Azure lui-même. Dans notre cas il n'y a pas de paramètres supplémentaires configurés dans la section `features{}`. 

Ensuite, la propriété `subscription_id` est définie pour spécifier l'ID d'abonnement Azure sur lequel les ressources seront déployées: `765266c6-9a23-4638-af32-dd1e32613047`.


```
provider "azurerm" {
  features {}
  
  subscription_id = "765266c6-9a23-4638-af32-dd1e32613047"
}
```

Ce deuxième code Terraform est utilisé pour déployer une machine virtuelle Linux sur Microsoft Azure. Pour cela il utilise des ressources comme une adresse IP publique, une interface réseau, une clé SSH et une machine virtuelle Linux.

1. La première partie utilise la ressource "data" pour récupérer des informations sur un sous-réseau existant. Le sous-réseau est spécifié par son nom, le nom du réseau virtuel et le nom du groupe de ressources auquel il appartient.

```
data "azurerm_subnet" "example" {
  name = "internal"
  virtual_network_name = "network-tp4"
  resource_group_name = "ADDA84-CTP"
}
```

2. La ressource "azurerm_public_ip" edéfinit une adresse IP publique (qui servira pour la futur machine virtuelle). Cette ressource possède un nom, une région, le nom du groupe de ressources et la méthode d'allocation ("Dynamic" dans cet exemple).

```
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "sarankan-ip"
  location            = "francecentral"
  resource_group_name = data.azurerm_subnet.example.resource_group_name
  allocation_method   = "Dynamic"
}
```

3. Ensuite, la ressource "azurerm_network_interface" est créée pour définir une interface réseau. Elle spécifie un nom, une région, le nom du groupe de ressources et les configurations IP. L'adresse IP du sous-réseau récupéré précédemment et l'ID de l'adresse IP publique créée précédemment sont utilisées.

```
resource "azurerm_network_interface" "my_terraform_nic" {
  name                = "sarankan-Nic"
  location            = "francecentral"
  resource_group_name = data.azurerm_subnet.example.resource_group_name

  ip_configuration {
    name                          = data.azurerm_subnet.example.name
    subnet_id                     = data.azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
}
```

4. La ressource "tls_private_key" est utilisée pour générer une clé SSH privée. Dans cet exemple, une clé RSA de 4096 bits est générée.

```
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
```

5. Enfin, la ressource principale "azurerm_linux_virtual_machine" est créée pour déployer une machine virtuelle Linux. Cette ressource est définit par un nom, une région, le nom du groupe de ressources, l'ID de l'interface réseau créée précédemment (et d'autres configurations telles que la taille de la machine virtuelle, le disque système, l'image source), le nom d'utilisateur pour se connecter à la machine virtuelle (devops). La clé SSH publique générée précédemment est également spécifiée pour permettre la connexion SSH à la machine virtuelle.

Grâce à ce terraform et en exécutant la commande `terraform apply`, on peut déployer la machine virtuelle Linux avec les ressources associées sur Microsoft Azure.


Le dernier terraform 
permet de récupérer "tls_private_key", la clé privée TLS générée dans le code précédent. Cette sortie est utile pour récupérer la clé privée générée après le déploiement de l'infrastructure, dans le fichier 'private_key.txt'.

Enfin, cette commande permet d'établir une connexion SSH vers une machine virtuelle à l'adresse IP 20.19.174.235 en utilisant une clé privée spécifiée dans le fichier "private_key.txt".

```
ssh -i private_key.txt devops@20.19.174.235
```