terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~> 3.0.2"
        }
    }

    required_version = ">= 1.8.5"
}

provider "azurerm" {
    features {
        resource_group {
            prevent_deletion_if_contains_resources = false
        }
    }
}

resource "azurerm_resource_group" "custom-cdn" {
    name = "custom-cdn-ResourceGroup"
    location = "Central India" # location has no effect
    # since resouce group is just a container for other resource
}

resource "azurerm_virtual_network" "custom-cdn" {
    for_each = var.vm_map

    name = "${each.value.name}-VNET"
    location = each.value.location
    address_space = [ "10.0.0.0/16" ]
    resource_group_name = azurerm_resource_group.custom-cdn.name
}

resource "azurerm_subnet" "custom-cdn" {
    for_each = var.vm_map

    name = "${each.value.name}-Subnet"
    resource_group_name = azurerm_resource_group.custom-cdn.name
    virtual_network_name = azurerm_virtual_network.custom-cdn[each.key].name  
    address_prefixes = [ "10.0.1.0/24" ]
}

resource "azurerm_public_ip" "custom-cdn" {
    for_each = var.vm_map

    name = "${ each.value.name }-PublicIp"
    location = each.value.location
    resource_group_name = azurerm_resource_group.custom-cdn.name
    allocation_method = "Static"
}

resource "azurerm_network_interface" "custom-cdn" {
    for_each = var.vm_map

    name = "${ each.value.name }-NIC"
    location = each.value.location
    resource_group_name = azurerm_resource_group.custom-cdn.name

    ip_configuration {
        name = "${each.value.name}-public"
        subnet_id = azurerm_subnet.custom-cdn[each.key].id
        public_ip_address_id = azurerm_public_ip.custom-cdn[each.key].id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_virtual_machine" "custom-cdn" {
    for_each = var.vm_map

    name = "${ each.value.name }-VM"
    location = each.value.location
    resource_group_name = azurerm_resource_group.custom-cdn.name
    network_interface_ids = [ azurerm_network_interface.custom-cdn[each.key].id ]
    vm_size = each.value.size

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04-LTS"
        version   = "latest"
    }

    storage_os_disk {
        name              = "${ each.value.name }-OsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    os_profile {
        computer_name  = each.value.name
        admin_username = "custom-cdn"
        admin_password = "Password1234!"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }
}

output "custom_cdn_public_ip" {
    value = {
        for vm in azurerm_public_ip.custom-cdn : vm.name => vm.ip_address
    }
}