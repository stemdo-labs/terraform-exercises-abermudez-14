# Ejercicio 02

## Objetivo

- Parametrizar un módulo raíz básico de Terraform.
- Introducción al uso de bloques "data" en Terraform.

## Pre-requisitos

- Disponer de un `resource group` en Azure sobre el que poder desplegar los recursos de este ejercicio.

## Enunciado

Desarrolla un módulo de terraform que permita desplegar una Virtual Network (VNet) sobre un Resource Group pre-existente en Azure. Para esto, crea los ficheros:

- `main.tf`, para los recursos terraform.
- `variables.tf`, para la definición de las variables de entrada.
- `terraform.tfvars`, para los valores de las variables de entrada.

El módulo debe contener una parametrización adecuada para aceptar el contenido del siguiente fichero `terraform.tfvars` (adapta los valores entre los símbolos `< >`):

```hcl
existent_resource_group_name = "<nombre_de_un_rg_ya_existente>"
vnet_name = "vnet<tunombre>tfexercise01"
vnet_address_space = ["10.0.0.0/16"]
```

Además debe existir una variable adicional, `location`, que permita indicar la localización donde se desplegará la VNet. Si no se especifica su valor en el tfvars, se debe utilizar `West Europe` por defecto.

Despliega el recurso en Azure utilizando el módulo desarrollado, documentando el proceso en el entregable.

## Entregables

**IMPORTANTE:** ¡Cuidado con exponer los valores sensibles!

- Documentación del proceso (con capturas de pantalla).
- Código de Terraform utilizado (como un directorio propio dentro del entregable).



## Solución


- Escribimos el código del `main.tf` estableciendo la red que queremos crear.

  ```terraform

  provider "azurerm" {
    features {}
  }
  
  data "azurerm_resource_group" "existent_rg" {
    name = var.existent_resource_group_name
  }
  
  resource "azurerm_virtual_network" "vnet" {
    name                = var.vnet_name
    address_space       = var.vnet_address_space
    location            = var.location
    resource_group_name = data.azurerm_resource_group.existent_rg.name
  
  }
    

  ```

- Declaramos las variables en `variables.tf` y sus respectivas entradas en `terraform.tfvars`


  - variables.tf
 
  ```terraform 
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
  
  ```


  - terraform.tfvars

  ```terraform

  existent_resource_group_name = "rg-abermudez-dvfinlab"
  vnet_name = "vnet-abermudez-tfexercise01"
  vnet_address_space = ["10.0.0.0/16"]  

  ```

- Realizamos `terraform apply`

  ![imagen](https://github.com/user-attachments/assets/7f64b876-2bfd-48dd-94e5-f61a09fe4a2e)

- Comprobamos en la web de Azure que nos ha creado la Vnet con su rango de direcciones IP correspondiente.

  ![imagen](https://github.com/user-attachments/assets/90f1fb1e-6bc3-4dff-914b-2224cefdac86)

  
