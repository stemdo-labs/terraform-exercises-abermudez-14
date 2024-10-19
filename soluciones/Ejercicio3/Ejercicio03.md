## Ejercicio3
## Enunciado

Modifica el ejercicio anterior e incluye tres nuevas variables:

- `owner_tag`:
  - Tipo: `string`
  - Obligatoria.
  - Describe el propietario de la VNet.
- `environment_tag`:
  - Tipo: `string`
  - Obligatoria.
  - Describe el entorno de la VNet (`dev`, `test`, `prod`, etc).
- `vnet_tags`:
  - Tipo: `mapa de strings`
  - Opcional, siendo su valor por defecto un mapa vacío.
  - Describe los tags adicionales que se aplicarán a la VNet.

El módulo debe utilizar estas variables para formar los tags de la VNet, incluyendo los tags obligatorios `owner` y `environment` y los tags adicionales que se especifiquen en `vnet_tags`. Si en `vnet_tags` se especifica un tag con el mismo nombre que `owner` o `environment`, se debe sobreescribir el valor de estos últimos por el valor de `vnet_tags`.

Despliega el recurso en Azure utilizando el módulo desarrollado, documentando el proceso en el entregable.


## Solución

- Modificamos el `main.tf` , para combinar los tags y sobreescribir aquel que fuera necesario. 

  ```terraform

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

- Añadimos las nuevas variables al `variables.tf`

  ```terraform
  variable "owner_tag" {
      description = "El propitario de la vnet"
      type = string
        
  }
  
  variable "environment_tag" {
    description = "El entorno de la vnet"
    type = string
  }
  
  variable "vnet_tags" {
    description = "Tags adicionales"
    type = map(string)
  }

  ```


- Realizamos el plan, introduciendo los valores de los tags

  ![imagen](https://github.com/user-attachments/assets/f7112e59-7640-4bb9-9678-866e8ba28cbe)

- Realizamos el apply y comprobamos en el portal de Azure que la Vnet se ha creado correctamente con los tags correspondientes.

  ![imagen](https://github.com/user-attachments/assets/828fae50-83de-4783-b7fa-62da02d9d928)



  
