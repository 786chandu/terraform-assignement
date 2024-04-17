variable "resource_group_name" {}
variable "virtual_network_location" {}
# First virtual network
variable "first_virtualnetwork_name" {}
variable "first_virtualnetwork_address_space" {
    type = string
}
variable "first_public_subnet_cidr" {
    type = string
}
variable "first_private_subnet1_cidr" {
    type = string
}
variable "first_private_subnet2_cidr" {
    type = string
}

variable "first_private_subnet3_cidr" {
  type = string
}

# Second virtual network
# variable "second_virtualnetwork_name" {}
# variable "second_virtualnetwork_address_space" {
#     type = string
# }
# variable "second_public_subnet_cidr" {
#     type = string
# }
# variable "second_private_subnet1_cidr" {
#     type = string
# }
# variable "second_private_subnet2_cidr" {
#     type = string
# }