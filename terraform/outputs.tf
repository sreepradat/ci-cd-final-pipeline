output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "public_ips" {
  value = { for k, ip in azurerm_public_ip.pip : k => ip.ip_address }
}

output "private_ips" {
  value = { for k, nic in azurerm_network_interface.nic : k => nic.private_ip_address }
}

output "ssh_commands" {
  value = {
    for k, ip in azurerm_public_ip.pip :
    k => "ssh -i $HOME\\.ssh\\cicd-key ${var.admin_username}@${ip.ip_address}"
  }
}