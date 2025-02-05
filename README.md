# IFDC0112
### Certificado de profesionalidad

[Enlace a algo](https://github.com/adam-p/markdown-here/wiki/markdown-cheatsheet)


```c
#include <stdio.h>
int main(void)
{
  printf("Hola mundo");
retun r (0);  
}
```

Ahora voy a hacer unas pruebas de **negrita**, *subrayado*
Ahora voy a hacer unas pruebas de __negrita__, _subrayado_

|num|nombre|
|---:|-:|
|01 |Pol apellido 1 apellido 2|
|02| Eric|
|03|Alex|
|04|Eric|


# Comandos bash 

+ Quine soy `whoami`
+ change directory (`cd <dir>`)
+ make directory (mkdir <dir>)
+ change ownership (chown <owner>:<group> <file>)
+ change permissions (chmod <num> <file>)  El numero de tres cifras otorga los permisos al owner, al grupo y a otros
+ copia archivos  cp <origen> <destino>
+ cambia el nombre a un archivo o directorio mv <inicial> <final>
+ list directous (ls <directory>  flsgs: -l long format.  -a all files.))
+ grep <patron> <archivo>
+ cat amd.csv | awk -F';' '$3==8' filtra los registros que tiene un 8 en la tercera columna
+ awk -F';' '{print $3} ' amd_commas.csv  extrae la tercera columna de un archivo
+ $ awk -F';' '{print $3}' tirame_escritura.csv | sort | uniq muestras las configuracione únicas del numero de nucleos que tiene
+ basic calculator  (obase=2 para pasar de decimal a binario) (ibase=2 para pasar de binario a decimal)
+ contar lineas de un archivo  wc -l

# Comandos vim

+ salir :q 
+ salir sin salvar cambios :q!
+ salvar :w
+ editar un archivo :e <nombre>
+ substituir en todo el archivo :% s/original/substitucion/g
+ cambiar una palabra cw (sin los dos puntos. estando encima de la palabra.)
+ deshacer u (si los dos puntos)
+ insertar i (sin los dos puntos)
+ finalizar la insercion, pulsa esc


# Comandos git
+ git add .                    // Pone en modo seguimiento todos los archivos del repo
+ git add file                 // Pone en mode seguimiento el archivo file
+ git commit                   // Sube al **stage** los ficheros que están en modo seguimiento **Y** abre el editor para documentar el commit.
+ git push                     // Sube las modificaciones al repositorio en la nube GitHub
+ git pull                     // Baja desde el repositorio en la nube GitHub al directorio en la máquina local la version actual.

### Hay varios manuales de buenas prácticas para documentar los commits
### Agrupa los modificaciones relacionadas en un mismo commit 



 # Bash grupos y usuarios

+ crea un nuevo grupo marketing
  
sudo groupadd marketing

+ crea un nuevo usuario y añadelo al grupo recien creado
  
sudo useradd -g marketing username

+ define un nuevo password para un usuario
  
sudo passwd username

+ verifica a que grupos pertenece un usuario
  
groups username

+ añade el usuario codespace al grupo tirame
  
 sudo usermod -aG tirame codespace

+ borra el usuario codespace del grupo tirame
  
 sudo gpasswd -d codespace tirame

+ lista todos los grupos existentes
  
cat /etc/group o bien getent group

+ lista todos los usuarios existentes
  
  cat /etc/passwd

