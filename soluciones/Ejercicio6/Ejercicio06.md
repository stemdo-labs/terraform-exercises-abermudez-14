# Ejercicio 06

## Objetivos

- Introducción a la utilización de módulos remotos.

## Pre-requisitos

- Haber completado el ejercicio05

## Enlaces de Interés

- [Uso de source en bloques de tipo Module](https://developer.hashicorp.com/terraform/language/modules/sources).

## Enunciado

Sube el módulo creado en el ejercicio anterior a un repositorio de GitHub (si se han seguido las instrucciones, ya debería estar localizado en la entrega del ejercicio previo).

Crea un nuevo fichero `main.tf` que haga uso del módulo localizado en el repositorio remoto.

Añade también un fichero `variables.tf` para definir las variables de entrada del módulo, un fichero `outputs.tf` para definir las salidas del módulo y un fichero `terraform.tfvars` para definir los valores de las variables de entrada (reutiliza todo lo que sea posible del ejercicio anterior).


## Solución


- Creamos un repo público en GitHub para alojar el módulo y poder acceder a él remotamente

  ![imagen](https://github.com/user-attachments/assets/f3dd1d5b-d60c-4356-93e1-61fb21ea54da)


- Modificación del `main.tf` para apuntar a GitHub y no al módulo localmente

  ```terraform
  provider "azurerm" {
    features {}
  }
  
  module "vnet_abermudez" {
      source = "git::github.com/abermudez-14/ejercicio6-tf/modules/vnet_abermudez"
  
  
      owner_tag = var.owner_tag
      environment_tag = var.environment_tag
      location = var.location
      vnet_address_space = var.vnet_address_space
      vnet_tags = var.vnet_tags
      vnet_name = var.vnet_name
      existent_resource_group_name = var.existent_resource_group_name
  }
  
  ```

- Archivo `outputs.tf` de dentro del módulo; apuntamos a el tipo de recurso, su nombre, y el nombre de la variable que queremos mostrar.

  ```terraform
  output "vnet_name" {
    value = azurerm_virtual_network.vnet.name
    description = "El nombre de la red virtual creada"
  }
  ```

- Archivo `outputs.tf` de fuera del módulo; apuntamos al nombre del módulo, y después a la variable de dentro del módulo que contiene el nombre de la red virtual.

  ```terraform
  output "vnet_abermudez_name" {
    value = module.vnet_abermudez.vnet_name
    description = "El nombre de la red virtual creada"
  }

  ```

- Salida con el comando `terraform output`

  ![imagen](https://github.com/user-attachments/assets/97ca8a81-6fca-4091-93ea-ddd0a9442b59)


- Salida con el comando `terraform apply`

  ![imagen](https://github.com/user-attachments/assets/0c37081e-f1f2-49fb-bc98-656d04ec50b9)

- Comprobación en el portal de Azure

  ![imagen](https://github.com/user-attachments/assets/7716d66b-67a0-46b4-9896-0770a9429740)




