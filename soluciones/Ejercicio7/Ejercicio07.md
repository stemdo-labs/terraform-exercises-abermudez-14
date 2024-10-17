# Ejercicio 07

## Objetivos

- Crear un módulo completo de terraform.

## Pre-requisitos

- Haber completado todos los ejercicios anteriores y la guía de aprendizaje hasta el bloque *"Expresiones, Iteraciones y Módulos"* (inclusive).

## Enlaces de Interés

- [Recurso para asociar Network Security Groups a Subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association)

## Enunciado

Haciendo uso de las recomendaciones para la estructuración de módulos de Terraform definidas por HashiCorp, modifica el módulo creado a lo largo de los ejercicios anteriores para cumplir con los siguientes requisitos:

- El módulo debe ser capaz de crear:
  - Una VNet sobre un grupo de recursos existente o crear dicho grupo si no existe.
  - Cero o varias subnets dentro de la VNet. _(Utiliza módulos anidados para esto)_
  - **[¡¡OPCIONAL!!]** Cero o varios network security groups asociados a una o varias subnets. _(Utiliza módulos anidados para esto)_
- El módulo debe contener las validaciones que consideres necesarias para asegurar su correcto funcionamiento. <br/>**Nota:** Recuerda que los recursos de azurerm ya contienen validaciones por defecto que no son necesarias repetir, solo utiliza las validaciones que aporten valor para tu caso de uso.
- No es necesario definir todos los argumentos de los recursos proporcionados por azurerm, solo los **obligatorios** (es decir, en la documentación de azurerm, solo deben usarse los argumentos especificados como obligatorios bajo la sección *Argument Reference*).

Una vez completado el módulo, crea un ejemplo de uso que contenga la creación de una VNet con dos subnets.

Si se ha decidido desarrollar el apartado opcional, crea también un network security group asociado a una de las subnets anteriores. No es necesario que las reglas del network security group tenga sentido, simplemente añade reglas de ejemplo.

El ejemplo de uso puede constar de un solo fichero `main.tf` si se desea.





## Solución

- Estructura de carpetas del ejercicio
> [!NOTE]
  > Los tres módulos se definen al mismo nivel, llamándolos desde el `main.tf` principal.

  ![image](https://github.com/user-attachments/assets/984d5be8-6b54-4dbe-8aae-2dce5b078287)

- Archivo `main.tf`

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
  
  
  
  module "subnet_abermudez" {
    source = "./modules/subnet_abermudez"
    subnet_name = var.subnet_name
    resource_group_name = var.existent_resource_group_name
    address_prefixes = var.address_prefixes
    virtual_network_name = module.vnet_abermudez.vnet_name
  
  
  }
  
  
  
  module "nsg_abermudez" {
    source = "./modules/nsg_abermudez"
    count = 2
    location = var.location
    resource_group_name = var.resource_group_name
    id = module.subnet_abermudez.subnet_lista[count.index].id
  }
  
  ```


- Diagrama de flujo

![image](https://github.com/user-attachments/assets/12e12422-1834-43ac-9827-06f347cb8a51)


- Ejecutamos con `terraform apply`

  - Network Security Group & asociar a subnet0
    
    ![image](https://github.com/user-attachments/assets/6e493280-bfb3-426e-82a9-8c55cd7566c9)

  - Network Security Group & asociar a subnet1
    
    ![image](https://github.com/user-attachments/assets/b54d5271-0b07-474c-8a59-2ed12c0bbc2d)

  - Crear subnets y vnet
    
    ![image](https://github.com/user-attachments/assets/5ce1a346-d17a-4786-973a-c61070191a59)


- Resultado en el portal de Azure

  - Grupo de seguridad y regla

    ![image](https://github.com/user-attachments/assets/a3b4a55c-9321-419a-a1fb-6531613bd4a1)

  - Topología de la vnet
    
    ![image](https://github.com/user-attachments/assets/dfbcafcb-8d62-4c42-acce-d59b70e83273)


  - Subredes
 
    - subnet0
      
    ![image](https://github.com/user-attachments/assets/6d66328a-fa42-4630-85d2-2aab7c3d8cfb)

    - subnet1
   
    ![image](https://github.com/user-attachments/assets/a7761b52-2fbd-4b31-b046-9078870ddd88)


