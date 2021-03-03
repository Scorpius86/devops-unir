# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.1"
    }
  }
}

# crea un service principal y rellena los siguientes datos para autenticar
provider "azurerm" {
  features {}
  subscription_id = "48b47fa2-e2d4-4eb4-92be-f7410898af0b"
  client_id       = "72ec76c8-093b-4d4b-92f3-2325f09d67b6"
  client_secret   = "O5Sss.N02MIeyb0Gl6taJV2eqHQ2kROGeE"
  tenant_id       = "359f9a7d-18ce-42bf-80c8-7cff9e947cec"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group

resource "azurerm_resource_group" "rg" {
  name     = "kubernetes_rg"
  location = var.location

  tags = {
    environment = "CP2"
  }

}

# Storage account
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account

resource "azurerm_storage_account" "stAccount" {
  name                     = "staccountcp2erick"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "CP2"
  }

}
