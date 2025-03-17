module "marketplace_vm" {
  source              = "./module/marketplace_vm"
  subscription_id     = var.subscription_id   
  resource_group_name = "Mytest-rg"
  location            = "East US"
  vm_name             = "Test-vm"
  vnet_cidr           = "10.0.0.0/16"
  subnet_cidr         = "10.0.1.0/24"
  vm_size             = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "SecurePass123!"
  image_publisher     = "checkpoint"
  image_offer         = "cloudguard"
  image_sku           = "standard"
}
