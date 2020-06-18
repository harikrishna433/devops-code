provider "azurerm" {
 version ="~>1.35"

 subscription_id  = var.subscription_id
 client_id = var.client_id
 client_secret = var.client_secret
 tenant_id =  var.tenant_id 
}

terraform {
  backend "azurerm" {
    storage_account_name = "backend433"
    container_name       = "hari433"
    key                  = "prod2.terraform.tfstate"
    access_key = " "
     }
}

resource "azurerm_resource_group" "hari" {
  name     = "${var.prefix}-rg"
  location = var.location

  tags = var.tags
  }

  resource "azurerm_app_service_plan" "appservice" {
  name                = "${var.prefix}-appserviceplan"
  location            = var.location
  resource_group_name = azurerm_resource_group.hari.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}
  
 resource "azurerm_app_service" "appservice" {
  name                = "${var.prefix}-ASPhari"
  location            = var.location
  resource_group_name  = "${var.prefix}-rg"
  app_service_plan_id = azurerm_app_service_plan.appservice.id
}

  resource "azurerm_application_insights" "appinsight" {
  name                = "${var.prefix}-appinsight"
  location            = var.location
  resource_group_name = azurerm_resource_group.hari.name
  application_type    = "web"
}
  
resource "azurerm_storage_account" "haristorage" {
  name                     = "${var.prefix}433"
  resource_group_name      = azurerm_resource_group.hari.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags = var.tags
  }

resource "random_password" "password" {
  length = 16
  special = true
  override_special = "_%@#£"
}
resource "azurerm_sql_server" "sq" {
  for_each = var.server_regions
  name                         = "${var.prefix}-sqlserver-${each.key}"
  resource_group_name          = azurerm_resource_group.hari.name
  location                     = each.value
  version                      = "12.0"
  administrator_login          = "adminuser"
  administrator_login_password = random_password.password.result

  tags = var.tags
}
resource "azurerm_sql_database" "sd" {
  for_each = var.server_regions
  name                = "${var.prefix}database"
  resource_group_name = azurerm_resource_group.hari.name
  location            = each.value
  server_name         = azurerm_sql_server.sq[each.key].name


  }