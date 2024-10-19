
### Preguntas Parte 1

  - Revisa el código. ¿Qué observas? ¿El código generado es exactamente lo que esperabas?

    Si es lo que esperaba, ya que al importar el recurso, terraform lo almacena en el `tfstate`, y no hubo cambios en azure al ejecutar el TF2 porque los recursos que se definen en él están siendo      correctamente importados.   

 --- 
    
  - ¿Qué sucede cuando ejecutas la creación de un recurso que ya existe en Azure pero no está reflejado en el archivo de configuración de Terraform?
  
    Terraform intentará crear el recurso otra vez, lo que puede darnos un error si el recurso ya existe o puede intentar modificarlo, por eso se importa el recurso al archivo de estado, para evitar     estos errores.

---
---

### Preguntas Parte 2


  - ¿Qué diferencias observas entre el backup del tfstate de TF2 y el resultado de aplicar las operaciones previas?

      La principal diferencia es que en el backup del tfstate, el Key Vault aún aparece como un recurso, mientras que tras eliminarlo del tfstate , ya no aparece reflejado en el archivo de estado.

---

  -  ¿Qué problemática podrías enfrentar en el tfstate de un terraform si un recurso de su configuración es eliminado manualmente (sin usar ese terraform)?


      Si un recurso es eliminado manualmente sin ser reflejado en el tfstate, Terraform no puede saberlo. Esto puede dar errores ya que no hay la misma cofiguración entre el tfstate y el portal de Azure, causando que Terraform intente          crear el recurso otra vez.
    
---


  -  ¿Qué maneras se te ocurren para comprobar que el tfstate refleja el estado real de los recursos?


      Usando el comando `terraform plan` , o haciéndole un `cat` al archivo `terraform.tfstate` y comprobando manualmente si el estado que hay ahí se corresponde con el portal de Azure. 

---

  - ¿Es necesario mantener los bloques de importación en el archivo main.tf de TF2 después de realizar las operaciones anteriores?


      No, los bloques de importación solo se utilizan para el proceso de inicial. Después de importar los recursos, se pueden eliminar.

---
