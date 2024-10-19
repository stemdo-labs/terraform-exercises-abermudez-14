
### Preguntas Parte 1

  - Revisa el código. ¿Qué observas? ¿El código generado es exactamente lo que esperabas?

    Si es lo que esperaba, ya que al importar el recurso, terraform lo almacena en el `tfstate`, y no hubo cambios en azure al ejecutar el TF2 porque los recursos que se definen en él están siendo      correctamente importados.   

 --- 
    
  - ¿Qué sucede cuando ejecutas la creación de un recurso que ya existe en Azure pero no está reflejado en el archivo de configuración de Terraform?
  
    Terraform intentará crear el recurso otra vez, lo que puede darnos un error si el recurso ya existe o puede intentar modificarlo, por eso se importa el recurso al archivo de estado, para evitar     estos errores.

### Preguntas Parte 2











































































1. ¿Qué diferencias observas entre el backup del tfstate de TF2 y el resultado de aplicar las operaciones previas?
Respuesta:

La principal diferencia es que en el backup del tfstate, el Key Vault aún está registrado como un recurso existente, mientras que tras eliminarlo del tfstate usando el comando adecuado, ya no aparece reflejado en el archivo de estado. El tfstate actualizado refleja la situación real de la infraestructura.

2. ¿Qué problemática podrías enfrentar en el tfstate de un terraform si un recurso de su configuración es eliminado manualmente (sin usar ese terraform)?
Respuesta:

Si un recurso es eliminado manualmente sin ser reflejado en el tfstate, Terraform no tiene forma de saberlo. Esto puede llevar a inconsistencias entre el tfstate y la realidad, causando que Terraform intente recrear el recurso o aplique configuraciones que ya no son válidas.

3. ¿Qué maneras se te ocurren para comprobar que el tfstate refleja el estado real de los recursos?
Respuesta:

Puedes usar el comando terraform plan para verificar si hay diferencias entre el tfstate y los recursos actuales en la infraestructura. Además, puedes sincronizar el tfstate con los recursos reales usando terraform refresh o manualmente con importaciones.

4. ¿Es necesario mantener los bloques de importación en el archivo main.tf de TF2 después de realizar las operaciones anteriores?
Respuesta:

No, los bloques de importación solo se utilizan para el proceso de importación inicial. Después de importar correctamente los recursos al tfstate, puedes eliminar esos bloques ya que ya no son necesarios para el estado actual.
