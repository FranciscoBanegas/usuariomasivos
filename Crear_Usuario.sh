#!/bin/bash

:<<-!
Author: Francisco Banegas
Description: Crear Usuarios Masivo
Repo: https://github.com/FranciscoBanegas
Channel: Youtube.com/FranciscoBanegas
!

#::Verifica Privilegios
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script debe ejecutarse como root." >&2
    exit 1
fi
read -p "Indique la Ruta del Archivo:" file
read -p "Indique que shell se usara por defecto => Opciones: /bin/sh /bin/dash /bin/zsh " shell

#? Verificar si el archivo existe
if [ ! -f "$file" ]; then
    echo "Error: El archivo '$file' no existe."
    exit 1
fi


#? Limpia el archivo eliminando caracteres de retorno de carro (\r) y espacios en blanco al final de las líneas
sed -i 's/\r//g; s/[[:space:]]*$//' "$file"
#? Lee el archivo pero excluye líneas vacías
mapfile -t usuarios < <(grep -v '^[[:space:]]*$' "$file")
#::Validar shells Permitidos

valid_shells=("/bin/bash" "/bin/sh" "/bin/dash" "/bin/zsh")
#--Comprobar Si la variable shell es vacia
if [ -z "$shell" ]; then
    shell="/bin/bash"
else
#--Creo una variable nueva que la utilizo para comprobar si el shell es valido
    shell_valida=false
    for valid in "${valid_shells[@]}"; do
    #--Comprueba si el shell es valido si es valido se sale del bucle
        if [ "$shell" == "$valid" ]; then
            shell_valida=true
            break
        fi
    done
#--Si el shell no es valido invierte el valor de la variable shell_valida de false a true o viceversa
    if ! $shell_valida; then
        echo "Shell no válido. Usando /bin/bash por defecto."
        shell="/bin/bash"
    fi
fi
#::Crear Usuarios y Generar Contraseñas

> pass.txt  # Vacía el archivo antes de empezar
chmod 600 pass.txt  # Asegura que solo el propietario pueda leer/escribir

#?Recorre directamente todos los elementos del array usuarios
for usuario in "${usuarios[@]}"; do
    #? Convertir el nombre de usuario a minúsculas
      usuario=$(echo "$usuario" | tr 'A-Z' 'a-z')
    #? Validar que el nombre de usuario cumple con las reglas POSIX
    if [[ ! "$usuario" =~ ^[a-z_][a-z0-9_-]{0,31}$ ]]; then
        echo "Error: El nombre de usuario '$usuario' no es válido. Omitiendo."
        continue
    fi

    #? Generar contraseña aleatoria
    pass=$(tr -dc 'A-Za-z0-9!@#$%^&*()_+-=,.<>?;:' < /dev/urandom | head -c 12)

    if id "$usuario" &>/dev/null; then
        echo "Usuario $usuario ya existe en el sistema. Omitiendo creación."
    else
    
        if useradd -m -s "$shell" "$usuario"; then
            echo "Usuario $usuario creado."
            echo "$usuario:$pass" | chpasswd 2>/dev/null

            if [ $? -eq 0 ]; then
                echo "$usuario:$pass" >> pass.txt
                echo "Contraseña de $usuario creada y guardada en pass.txt."
                else
                echo "Error al asignar la contraseña de $usuario."
            fi

        else
            echo "Error al crear el usuario $usuario."
        fi
    fi
done
total=$(wc -l < pass.txt)
echo "Proceso finalizado. Se crearon $total usuarios nuevos."