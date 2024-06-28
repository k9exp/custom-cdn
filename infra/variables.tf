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

	"vm4" = {
		name = "australiacentral"
		location = "Australia Central"
		size = "Standard_B1s"
	}


	"vm5" = {
		name = "japanwest"
		location = "Japan West"
		size = "Standard_B1s"
	}

	"vm6" = {
		name = "southafricanorth"
		location = "South Africa North"
		size = "Standard_B1s"
	}

	"vm7" = {
		name = "brazilsouth"
		location = "Brazil South"
		size = "Standard_B1s"
	}
  }
}
