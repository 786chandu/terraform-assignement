terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.99.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "task-test-rg"
    storage_account_name = "tasktesttf"
    container_name       = "terraform-state"
    key                  = "poc-terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}