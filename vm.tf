resource "azurerm_virtual_network" "this" {
  count               = var.use_vm ? 1 : 0
  name                = "${var.server_name}-vm-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}


resource "azurerm_subnet" "this" {
  count                = var.use_vm ? 1 : 0
  name                 = "${var.server_name}-vm-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this[0].name
  address_prefixes     = ["10.0.2.0/24"]


}

resource "azurerm_public_ip" "this" {
  count               = var.use_vm ? 1 : 0
  name                = "${var.server_name}-vm-public-ip"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

}


resource "azurerm_network_interface" "this" {
  count               = var.use_vm ? 1 : 0
  name                = "${var.server_name}-vm-nic"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name


  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.this[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this[0].id
  }


}


resource "azurerm_network_security_group" "this" {
  count               = var.use_vm ? 1 : 0
  name                = "${var.server_name}-vm-nsg"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


}

resource "azurerm_network_interface_security_group_association" "this" {
  count                     = var.use_vm ? 1 : 0
  network_interface_id      = azurerm_network_interface.this[0].id
  network_security_group_id = azurerm_network_security_group.this[0].id

}




resource "azurerm_ssh_public_key" "this" {
  count               = var.use_vm ? 1 : 0
  name                = "ssh-key"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  public_key          = var.public_key

}

resource "azurerm_linux_virtual_machine" "this" {
  count = var.use_vm ? 1 : 0

  name                = "${var.server_name}-vm"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  admin_username = var.vm-username




  admin_ssh_key {
    public_key = azurerm_ssh_public_key.this[0].public_key
    username   = var.vm-username
  }

  priority = "Spot"

  eviction_policy = "Deallocate"
  max_bid_price   = "0.06"


  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
    disk_size_gb         = 30

  }

  size = var.vm_size

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }


  network_interface_ids = [azurerm_network_interface.this[0].id]



  custom_data = base64encode(templatefile("azure-user-data.tftpl", {
    username = var.vm-username,
    password = var.password,
    domain   = "jenkins.${var.dns-zone}",
  }))


}

