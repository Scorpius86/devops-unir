# Creación de red
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network

resource "azurerm_virtual_network" "myNet" {
  name                = "kubernetesnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    environment = "UNIR"
  }
}

# Creación de subnet
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet

resource "azurerm_subnet" "mySubnet" {
  name                 = "terraformsubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.myNet.name
  address_prefixes     = ["10.0.1.0/24"]

}

# Create NIC
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface

resource "azurerm_network_interface" "myNic" {
  count               = length(local.vm_config)
  name                = "vmnic-${local.vm_config[count.index].name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "myipconfiguration-${local.vm_config[count.index].name}"
    subnet_id                     = azurerm_subnet.mySubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.vm_config[count.index].ip
    public_ip_address_id          = azurerm_public_ip.myPublicIp[index(azurerm_public_ip.myPublicIp.*.name, "vmip-${local.vm_config[count.index].name}-PublicIP")].id
  }

  tags = {
    environment = "UNIR"
  }

}

# IP pública
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip

resource "azurerm_public_ip" "myPublicIp" {
  count                         = length(local.vm_config)
  name                          = "vmip-${local.vm_config[count.index].name}-PublicIP"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  allocation_method             = "Dynamic"  
	domain_name_label             = "vmip-${local.vm_config[count.index].name}-publicip"
  sku                           = "Basic"
  tags = {
    environment = "UNIR"
  }
}