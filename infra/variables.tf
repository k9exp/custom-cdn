variable "vm_map" {
  type = map(object({
    name     = string
    location = string
    size     = string
  }))

  default = {
    "vm1" = {
		name = "centralindia"
		location = "Central India"
		size = "Standard_B1s"
    }

	"vm2" = {
		name = "centralus"
		location = "Central US"
		size = "Standard_B1s"
	}

	"vm3" = {
		name = "westeurope"
		location = "West Europe"
		size = "Standard_B1s"
	}
  }
}

