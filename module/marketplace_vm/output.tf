output "vm_id" {
  description = "The ID of the deployed VM"
  value       = azurerm_linux_virtual_machine.vm.id
}

output "vm_public_ip" {
  description = "Public IP of the VM (if assigned)"
  value       = azurerm_linux_virtual_machine.vm.public_ip_address
}
