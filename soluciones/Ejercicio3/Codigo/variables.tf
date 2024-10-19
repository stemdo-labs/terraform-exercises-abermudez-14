variable "owner_tag" {
    description = "El propitario de la vnet"
    type = string
      
}

variable "environment_tag" {
  description = "El entorno de la vnet"
  type = string
}

variable "vnet_tags" {
  description = "Tags adicionales"
  type = map(string)
}


variable "existent_resource_group_name" {
  description = "El nombre del rg"
  type        = string
}

variable "vnet_name" {
  description = "El nombre de la VNet "
  type        = string
}

variable "vnet_address_space" {
  description = "Las direcciones IP de la red"
  type        = list(string)
}

variable "location" {
  description = "La localización de la red , por defecto West Europe"
  type        = string
  default     = "West Europe"
}

