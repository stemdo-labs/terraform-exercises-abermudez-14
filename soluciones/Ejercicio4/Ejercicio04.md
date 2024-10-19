# Ejercicio 04

## Objetivos

- Practicar la validación de variables en módulos de Terraform.
- Combinar el uso de funciones de terraform.
- Introducción opcional al uso de expresiones regulares como herramienta para validación.

## Enlaces de Interés

- [Funciones de Terraform](https://developer.hashicorp.com/terraform/language/functions)
- [terraform console](https://developer.hashicorp.com/terraform/cli/commands/console)
- [Expresiones en Terraform](https://developer.hashicorp.com/terraform/language/expressions)

## Enunciado

Modifica el ejercicio anterior para que se cumplan las siguientes condiciones:

- `owner_tag`,`environment_tag` y `vnet_name` no pueden ser cadenas vacías ni ***nullable***.
- En `environment_tags`, los valores de los tags solo pueden contener uno de los siguientes valores, sin tener en cuenta mayúsculas o minúsculas (es decir, tanto 'dev', como 'DEv', como 'DEV' son valores aceptados): 'DEV', 'PRO', 'TES', 'PRE'.<br/>**Consejo:** Utiliza la función `contains` de Terraform en combinación con otras.
- `vnet_tags` no pueder null y además ninguno de los valores del mapa puede ser null o cadena vacía. 

Se debe elegir una de las siguientes opciones para validar la variable `vnet_name`:

### Opción 1 (Menor dificultad)

Debe cumplirse que comience siempre por `vnet`.

### Opción 2 (Mayor dificultad)

**Nota**: Esta opción está ideada para el uso de expresiones regulares. 


## Solución

#### Validación de variables (no nulas ni vacías)

```terraform
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
    condition = can(regex("^vnet[a-z]{2,}tfexercise\\d{2}$", var.vnet_name))
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

```

### Se comprueba que todas las variables cumplan con las condiciones correspondientes, si no es así nos mostrará los mensajes de error de cada una

 ![imagen](https://github.com/user-attachments/assets/aef93db9-064b-4eac-8be5-0dcd631130d4)

### Salida sin errores

 ![imagen](https://github.com/user-attachments/assets/55b36c14-4959-4518-825e-5102741b9ff1) 

### Comprobación en Azure  

![imagen](https://github.com/user-attachments/assets/486bf1a0-f6f3-4998-8bc8-14fc6c88d166)


  
