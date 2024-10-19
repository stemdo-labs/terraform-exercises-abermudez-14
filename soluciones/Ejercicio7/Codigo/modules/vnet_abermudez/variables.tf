# Variables de la vnet

variable "owner_tag" {
    description = "El propitario de la vnet"
    type = string
    validation {
      condition = var.owner_tag != null && length(var.owner_tag) > 0
      error_message = "El nombre del propietario no puede estar vacío"
    }
}



variable "environment_tag" {
  description = "El entorno de la vnet"
  type = string
  validation {
    condition = var.environment_tag != null && var.environment_tag != ""
    error_message = "El entorno no puede estar vacío"
  }
  validation {
    condition = contains(["dev","pro","test","pre"], lower(var.environment_tag))
    error_message = "El entorno debe ser Dev, Pro, Test o Pre"
  }
}




variable "vnet_tags" {
  description = "Tags adicionales"
  type = map(string)

  
  validation {
    condition = var.vnet_tags != null 
    error_message = "Los tags no pueden estar vacíos"
  }
  validation {
    condition = alltrue([for vnet_tag in var.vnet_tags : length(vnet_tag) > 0  && vnet_tag != null])
    error_message = "Los tags no pueden ser nulos o estar vacíos"
  }
}




variable "existent_resource_group_name" {
  description = "El nombre del rg"
  type        = string
}



variable "vnet_name" {
  description = "El nombre de la VNet "
  type        = string
  validation {
    condition = var.vnet_name != null && length(var.vnet_name) > 0
    error_message = "El nombre de la Vnet no puede estar vacío"
  }
  validation {
    condition = can(regex("^vnet[a-z]{2,}tfexercise\\d{2,}$", var.vnet_name))
    error_message = "El nombre de la vnet debe empezar por 'vnet' , seguido de 2 o más caracteres de a-z, seguido de tfexercise y 2 dígitos"
  }
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
