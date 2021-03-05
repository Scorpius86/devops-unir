
# crea un service principal y rellena los siguientes datos para autenticar
provider "azurerm" {
  features {}
  subscription_id = "48b47fa2-e2d4-4eb4-92be-f7410898af0b"
  client_id       = "72ec76c8-093b-4d4b-92f3-2325f09d67b6" # appID
  client_secret   = "O5Sss.N02MIeyb0Gl6taJV2eqHQ2kROGeE"   # password
  tenant_id       = "359f9a7d-18ce-42bf-80c8-7cff9e947cec" # tenant
}