resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    project = "ci-cd-final-pipeline"
    managed = "terraform"
  }
}

locals {
  vms = {
    jenkins = {
      size  = "Standard_B2ats_v2"
      ports = [22, 8080]
      zone  = null
    }
    app = {
      size  = "Standard_B2ats_v2"
      ports = [22, 80]
      zone  = null
    }
  }
}