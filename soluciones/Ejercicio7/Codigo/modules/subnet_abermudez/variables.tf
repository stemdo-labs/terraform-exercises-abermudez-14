variable "subnet_name" {
  type = string
  default = "subnet0"
}


variable "resource_group_name" {
  type = string
}



variable "virtual_network_name" {
  type = string
  default = "vnetabermudeztfexercise07"
}



variable "address_prefixes" {
  type = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"] 
}