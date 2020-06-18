output "storagekey" {
  value = azurerm_storage_account.haristorage.primary_access_key
}

output "server_password" {
    value = random_password.password.result
}

output "app_service_id" {
  value = azurerm_app_service.appservice.id
}