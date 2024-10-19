# Ejercicio 05

## Objetivos

- Introducción a la utilización de módulos.
- Importación de módulos locales.

## Pre-requisitos

- Haber completado el ejercicio 04.

## Enlaces de Interés

- [Uso de source en bloques de tipo Module](https://developer.hashicorp.com/terraform/language/modules/sources).

## Enunciado

Utilizando el contenido desarrollado durante los ejercicios anteriores, crea un módulo de terraform siguiendo la estructura recomendada por HashiCorp.

Una vez hecho esto, procede con los siguientes pasos:

Crea un nuevo módulo que disponga de un fichero `main.tf`. Añade también un fichero `variables.tf` para definir las variables de entrada, un fichero `outputs.tf` para definir las salidas y un fichero `terraform.tfvars` para definir los valores de las variables de entrada (reutiliza los valores del `ejercicio04`). Este módulo debe utilizar el módulo creado en el proceso anterior, que aún debe estar en local.


## Solución

- Creación del módulo; creamos una carpeta llamada `modules`, y dentro el módulo `vnet_abermudez`

  - Archivo `main.tf` del módulo

    ```terraform
    data "azurerm_resource_group" "existent_rg" {
      name = var.existent_resource_group_name
    }
    
    
    resource "azurerm_virtual_network" "vnet" {
      name                = var.vnet_name
      address_space       = var.vnet_address_space
      location            = var.location
      resource_group_name = data.azurerm_resource_group.existent_rg.name
      
      tags = local.todas_tags
        
    }
    locals {
      todas_tags = merge(
        {
          owner       = var.owner_tag,
          environment = var.environment_tag
        },
        var.vnet_tags
      )
    }
    ```
  - Archivo `variables.tf` del módulo
    ```terraform
    variable "owner_tag" {
    
    }
    
    
    
    variable "environment_tag" {
    
    }
    
    
    variable "vnet_tags" {
    
    }
    
    
    variable "existent_resource_group_name" {
    
    }
    
    variable "vnet_name" {
    
    }
    
    variable "vnet_address_space" {
    
    }
    
    variable "location" {
    
    }
    
    ```












- Modificación del `main.tf` principal; utilizamos source para lanzar el módulo que hemos creado

  ```terraform
  provider "azurerm" {
    features {}
  }
  
  module "vnet_abermudez" {
      source = "./modules/vnet_abermudez"
  
      owner_tag = var.owner_tag
      environment_tag = var.environment_tag
      location = var.location
      vnet_address_space = var.vnet_address_space
      vnet_tags = var.vnet_tags
      vnet_name = var.vnet_name
      existent_resource_group_name = var.existent_resource_group_name
  }

  ```

- Salida al realizar `terraform apply`

![imagen](https://github.com/user-attachments/assets/ad8a34f9-f9be-44e4-9068-9654621d117f)

- Comprobación en Azure

![imagen](https://github.com/user-attachments/assets/3215371d-deeb-4a8b-9280-60245ac75da4)



  
