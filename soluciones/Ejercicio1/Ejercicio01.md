# Ejercicio 01

## Objetivos

- Tener un primer contacto con Terraform.
- Configurar proveedor de azure para utilizar un Service Principal.


## Solución

- Una vez tenemos terraform instalado, tenemos que inicializar un directorio y crear los archivos `main.tf` y `variables.tf`
  ```bash
  terraform init
  touch main.tf
  touch variables.tf
  ```

- Cuando tengamos terraform y AZ CLI instalados, hacemos login en Azure, nos lleva al navegador e iniciamos sesión
  ```bash
  az login

  ```

- Exportamos las variables de entorno para poder asignarnos el Service Principal y disponer de permisos
  ```bash
   export ARM_CLIENT_ID="<APPID_VALUE>"
   export ARM_CLIENT_SECRET="<PASSWORD_VALUE>"
   export ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"
   export ARM_TENANT_ID="<TENANT_VALUE>"
  ```

- Escribimos el código de `main.tf`
  
  
  ```terraform
  terraform {
    required_version = ">= 1.5"
    required_providers {
      azurerm ={
          source = "hashicorp/azurerm"
          version = "4.5.0"   
       }
    }
  }
  
  
  provider "azurerm"{
      features {}
      subscription_id = var.subscription_id
      tenant_id = var.tenant_id
  }
  
  
  resource "azurerm_storage_account" "example" {
    name                     = "abermudez"
    resource_group_name      = "rg-abermudez-dvfinlab"
    location                 = "West Europe"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }

 
  ```

- Realizamos el `terraform plan` y `terraform apply`

    - Terraform plan

  ![imagen](https://github.com/user-attachments/assets/35a7647c-e99c-412a-b4c1-5493279f91a0)

  ![imagen](https://github.com/user-attachments/assets/d606aeaf-5882-4dc9-ad7c-9e24f49b9f50)


    - Terraform apply

   ![imagen](https://github.com/user-attachments/assets/73e6d6cb-0785-4dea-8c70-35485891b3d9)


- Comprobamos en la web de Azure si nos ha creado la cuenta de almacenamiento
  
  ![imagen](https://github.com/user-attachments/assets/ec1bb3f1-3c33-458a-b944-b7ac9193100c)


