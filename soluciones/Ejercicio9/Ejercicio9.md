# Ejercicio 09: Gestión de Recursos con Terraform Import y el Estado

## Objetivos
El objetivo de este ejercicio es comprender el uso de `terraform import` y los bloques de import introducidos en terraform 1.5 para manipular el `tfstate` en situaciones concretas. Se presentarán dos escenarios para explorar estos conceptos.

## Entregables

**IMPORTANTE:**
- Documentación del proceso (con capturas de pantalla).
- Código de Terraform utilizado (organizado en un directorio por separado).
- Archivo `respuestas.md` donde se incluirán las respuestas a las preguntas planteadas a lo largo del ejercicio.

## Primera Parte: Uso de `terraform import` y Bloques de Importación

Descompondremos esta parte en dos fases:

- Una primera fase de preparación, donde se desplegarán los recursos iniciales en Azure a través de Terraform. Estos recursos, en un escenario real, ya existirían en Azure y se asumirá que se han creado manualmente a través de la interfaz gráfica de usuario de Proveedor Cloud, sin terraform.<br>No obstante, por las limitaciones en permisos de Azure, se creará un archivo de configuración de Terraform para desplegar estos recursos usando el service principal que se os ha proporcionado.

- Una segunda fase (la de importación), en la que en un escenario real estaríamos creando un terraform que requiere importar en su `tfstate` recursos que ya existen en Azure.

### Pasos a seguir:

1. **Despliega los recursos iniciales:**
  - Crea un primer archivo de configuración Terraform (al que se denominará TF1 de ahora en adelante) en una carpeta de nombre "recursos_preexistentes" donde definas y despliegues los siguientes recursos en Azure:
    - Azure Key Vault 
    - Azure Storage Account
  - Ejecuta `terraform init`, `terraform plan` y `terraform apply` en TF1 para crear los recursos en Azure.

2. **Importa los recursos a otro archivo de configuración (TF2):**
  - Crea una segunda carpeta, denominada "segundo_despliegue" y, dentro de ella, crea un archivo de configuración terraform (al que se denominará TF2 de ahora en adelante) donde se debe definir lo necesario para realizar la importación de los siguientes recursos ya existentes (creados en TF1):
    - Azure Key Vault: Para importar este recurso, utiliza el comando de terraform correspondiente.
    - Azure Storage Account: Para importar este recurso, utiliza la metodología correspondiente al uso de bloque de importación.
  - Ejecuta los comandos necesarios en TF2 para importar los recursos y aplicar los cambios.

### Preguntas:
  - Revisa el código. ¿Qué observas? ¿El código generado es exactamente lo que esperabas?
  - ¿Qué sucede cuando ejecutas la creación de un recurso que ya existe en Azure pero no está reflejado en el archivo de configuración de Terraform?

## Segunda Parte: Gestión del `tfstate` Tras la Eliminación de un Recurso

En esta parte, se aprenderá a gestionar el archivo `tfstate` cuando un recurso que se lanzó con terraform es eliminado manualmente fuera de Terraform.

1. **Elimina el Key Vault:**
  - Utilizando TF1, destruye el recurso Azure Key Vault previamente desplegado.

2. **Actualiza el estado de TF2:**
  - Haz un backup del archivo `tfstate` de TF2 antes de realizar el resto de operaciones.
  - Gestiona el `tfstate` de TF2 para reflejar la eliminación del AKV en la infraestructura:
    - Usa el comando adecuado para eliminar el AKV del `tfstate` sin destruir otros recursos (consulta la documentación).
    - Edita la configuración de TF2 con los cambios necesarios para reflejar la situación actual de la infraestructura. Es decir, que el AKV ya no existe.
    - Ejecuta los comandos necesarios para aplicar los cambios: ¿Qué sucede? ¿Es lo que esperabas?

### Preguntas:
  - ¿Qué diferencias observas entre el backup del tfstate de TF2 y el resultado de aplicar las operacines previas?
  - ¿Qué problemática podrías enfrentar en el `tfstate` de un terraform si un recurso de su configuración es eliminado manualmente (sin usar ese terraform)?
  - ¿Qué maneras se te ocurren para comprobar que el `tfstate` refleja el estado real de los recursos?
  - ¿Es necesario mantener los bloques de importación en el archivo `main.tf` de TF2 después de realizar las operaciones anteriores?

## Enlaces de interés

- [Documentación oficial de Terraform](https://registry.terraform.io/)
- [Terraform import: Generating Configuration](https://developer.hashicorp.com/terraform/language/import/generating-configuration)
- [Terraform state rm](https://developer.hashicorp.com/terraform/cli/commands/state/rm)

---
---
---

# Solución 


## Primera parte

### Desplegar los recursos iniciales

- Se despliegan mediante el archivo `TF1.TF`
  

```terraform
provider "azurerm" {
  features {}
}

resource "azurerm_key_vault" "vault_abermudez" {
  name                        = "vaultabermudez"
  location                    = "West Europe"
  resource_group_name         = "rg-abermudez-dvfinlab"
  tenant_id                   = "2835cee8-01b5-4561-b27c-2027631bcfe"
  sku_name                    = "standard"
}

resource "azurerm_storage_account" "sta_abermudez" {
  name                     = "cuentaabermudez"
  resource_group_name      = "rg-abermudez-dvfinlab"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

```

- Ejecutamos `terraform apply`

  ![image](https://github.com/user-attachments/assets/418ab3b2-77ba-4370-9f9f-a434a75aa2d6)

- Resultado en el portal de Azure

  ![image](https://github.com/user-attachments/assets/572904b5-6cba-4f92-9507-0c0fb85f4738)

  
### Importar los recursos a otro archivo de configuración

- Importar utilizando el comando `terraform import`

  ![image](https://github.com/user-attachments/assets/f1c758ba-3527-468e-bc62-e873ab8e7f6c)


- Importar utilizando el bloque te terraform `import`

  - Archivo TF2.tf  
    
  ```terraform

  provider "azurerm" {
  features {}
  }
  
  resource "azurerm_key_vault" "vault_abermudez" {
    name                        = "vaultabermudez"
    location                    = "West Europe"
    resource_group_name         = "rg-abermudez-dvfinlab"
    tenant_id                   = "2835cee8-01b5-4561-b27c-2027631bcfe1"
    sku_name                    = "standard"
  }
  
  
  resource "azurerm_storage_account" "sta_abermudez" {
    name                     = "cuentaabermudez"          
    resource_group_name      = "rg-abermudez-dvfinlab"    
    location                 = "West Europe"              
    account_tier             = "Standard"                 
    account_replication_type = "LRS"                      
  }
  
  import {
    to = azurerm_storage_account.sta_abermudez
    id = "/subscriptions/86f76907-b9d5-46fa-a39d-aff8432a1868/resourceGroups/rg-abermudez-dvfinlab/providers/Microsoft.Storage/storageAccounts/cuentaabermudez"
  }

  ```

  - Ejecutamos `terraform apply`

    ![image](https://github.com/user-attachments/assets/0407ded4-eeff-4410-9d48-29713c1a34cc)


## Segunda parte


- Eliminar el Key Vault utilizando TF1

  - Lo hacemos mediante el comando `terraform destroy -target=azurerm_key_vault.vault_abermudez` 

> [!CAUTION]
> El error que nos muestra es porque no tenemos permisos para purgar el almacén de claves después de eliminarlo, pero como podemos ver después en el portal de Azure, ya no aparece.

    
  ![image](https://github.com/user-attachments/assets/8d7aab4a-3c37-4a95-9bd3-64f31254ea2e)
    
  - Comprobación en el portal de Azure

    ![image](https://github.com/user-attachments/assets/4b7804aa-20ba-4321-81b0-e9b0413a9276)


- Gestionar el estado del tfsate de TF2

  - Realizamos el backup

    ![image](https://github.com/user-attachments/assets/eb7cdacc-5b94-41a5-8ee1-8233df461c0e)

  - Eliminamos el recurso del archivo de estado utilizando `terraform state rm` 

    ![image](https://github.com/user-attachments/assets/21b22aac-fed7-41d3-bfe1-88b3176f48f2)

  - Eliminamos el bloque del recurso `azurerm_key_vault` del archivo `TF2.tf`

  ```terraform
      provider "azurerm" {
    features {}
  }
  
  
  resource "azurerm_storage_account" "sta_abermudez" {
    name                     = "cuentaabermudez"          
    resource_group_name      = "rg-abermudez-dvfinlab"    
    location                 = "West Europe"              
    account_tier             = "Standard"                 
    account_replication_type = "LRS"                      
  }
  
  import {
    to = azurerm_storage_account.sta_abermudez
    id = "/subscriptions/86f76907-b9d5-46fa-a39d-aff8432a1868/resourceGroups/rg-abermudez-dvfinlab/providers/Microsoft.Storage/storageAccounts/cuentaabermudez"
  }

  ```

  - Ejecuta los comandos necesarios para aplicar los cambios

    - Ejecutamos `terraform plan`

  ![image](https://github.com/user-attachments/assets/fd76fe3c-19b7-47e5-9f5e-b787a6f2664b)

> [!NOTE]
> Como podemos observar , muestra que no hay ningún cambio pendiente, ya que hemos borrado el recurso primero del archivo de estado `terraform.tfsate` y después de nuestro archivo de configuración `TF2.tf`
    
  
