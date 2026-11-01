resource "azurerm_linux_virtual_machine" "vm" {
  for_each            = local.vms
  name                = "${each.key}-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = each.value.size
  zone                = each.value.zone
  admin_username      = var.admin_username

  network_interface_ids = [azurerm_network_interface.nic[each.key].id]

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(pathexpand(var.ssh_public_key_path))
  }

  os_disk {
    name                 = "${each.key}-vm-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 64
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "shutdown" {
  for_each           = local.vms
  virtual_machine_id = azurerm_linux_virtual_machine.vm[each.key].id
  location           = azurerm_resource_group.rg.location
  enabled            = true

  daily_recurrence_time = "2300"
  timezone              = "India Standard Time"

  notification_settings {
    enabled = false
  }
}