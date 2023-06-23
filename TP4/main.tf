data "azurerm_subnet" "example" {
  name = "internal"
  virtual_network_name = "network-tp4"
  resource_group_name = "ADDA84-CTP"
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "sarankan-ip"
  location            = "francecentral"
  resource_group_name = data.azurerm_subnet.example.resource_group_name
  allocation_method   = "Dynamic"
}

# Create network interface
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

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = "devops-20221430"
  location              = "francecentral"
  resource_group_name   = data.azurerm_subnet.example.resource_group_name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
  size                  = "Standard_D2s_v3"

  os_disk {
    name                 = "sarankan-OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  computer_name                   = "sarankan-vm"
  admin_username                  = "devops"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "devops"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }
}