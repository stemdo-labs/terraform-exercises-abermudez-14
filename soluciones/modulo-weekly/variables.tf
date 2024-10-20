variable "maquinas" {
  type = map(object({
    vm_size = string
    admin_username = string

    image   = map(string)
  }))


}


variable "admin_password" {
  description = "Contraseña para las máquinas virtuales"
  type        = string
  sensitive   = true
}



variable "rg" {
  description = "Grupo de recursos"
  type = string
}

variable "location" {
  description = "Location"
  type = string
}
