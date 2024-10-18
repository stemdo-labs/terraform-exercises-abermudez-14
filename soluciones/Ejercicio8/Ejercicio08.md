# Ejercicio 08

## Objetivos

- Configurar almacenamiento de estado remoto en Azure Blob Storage.

## Pre-requisitos

- Tener una cuenta de almacenamiento en Azure con un contenedor creado.

## Enunciado

Toma como base uno de los módulos desarrollados en ejercicios anteriores y configura el almacenamiento de estado remoto para Terraform en Azure Blob Storage.

Documenta los pasos necesarios para llevar a cabo el proceso con una breve explicación (en una línea) de cada uno; desde los cambios necesarios en azure, si los hubiera, hasta el resultado final tras la destrucción de la infraestructura.


## Solución

> [!NOTE]
> Se toma como base el ejercicio 5

----

### Modificación del `main.tf`

> [!WARNING]
> Primero debemos hacer el `terraform apply` sin el bloque de `backend` para crear el contenedor, de lo contrario nos dará un error.
```terraform
  terraform {
    backend "azurerm" {
      resource_group_name   = "rg-abermudez-dvfinlab"
      storage_account_name  = "staabermudezdvfinlab"
      container_name        = "contenedorabermudez"
      key                   = "terraform.tfstate"  
    }
  }
  
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
  
  resource "azurerm_storage_container" "ctn_abermudez" {
    name = "contenedorabermudez"
    storage_account_name = "staabermudezdvfinlab"
    container_access_type = "private"
  }


  ```


### Backend

- Con el contenedor ya creado, añadimos el bloque `backend` y ejecutamos `terraform init`

  ![image](https://github.com/user-attachments/assets/eab604ac-d75b-414b-864c-ee1115c70352)


### Portal de Azure

- Como hemos iniciado sesión con nuestro usuario y no con el `service principal` , no tenemos permisos para listar los items del contenedor

  ![image](https://github.com/user-attachments/assets/06fcdbbd-2252-449e-ba53-ef3a2cd585c4)



