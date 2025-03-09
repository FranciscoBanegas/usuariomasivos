# Creación Masiva de Usuarios en Linux

Con este sencillo script podrás crear usuarios de forma masiva con contraseñas autogeneradas.

## 🚀 Instrucciones de Uso

### 1️⃣ Clona el repositorio 

    git clone https://github.com/FranciscoBanegas/usuariomasivos.git
    
### 2️⃣ Otorga permisos al archivo `Crear_Usuario.sh`:

    chmod 755 Crear_Usuario.sh

### 3️⃣  Ejecuta el script `Crear_Usuario.sh`:


    ./Crear_Usuario.sh


## 📒Nombre de usuarios

Al momento de ejecutar el script te pedirá que le indique la ruta en donde se encuentra usuarios.txt, dicho archivo deberá contener los nombre escrito en forma de lista:

Ejemplo  `Usuarios.txt`:


      Usuario1
      Usuario2
      Usuario3
      Usuario4
      Usuario5
      ETC


## Shell

Se le pedirá que indique la Shell que se le asignara a los usuario generado esta Shell se le asignara a todas, si no se elige una Shell, asumirá Bash como Shell por defecto

### Shell Validas

      /bin/sh
      /bin/zsh
      /bin/bash
    
## 🔐 Generacion de contraseña 

### 1️⃣ Las contraseña se genera de manera aleatorias, al momento de crear los usuario.
### 2️⃣ Se genera un archivo `pass.txt` que contendrá las contraseña en el orden asignada en el archivo `Usuarios.txt`.
