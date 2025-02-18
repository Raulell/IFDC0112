# Comandos básicos para un análisis exploratior con bash

## Ver las primeras 5 líneas del fichero.

``` bash
head -5 <file>
```

## Ver las últimas  7 líneas del fichero.

``` bash
tail -7 <file>
```

## Contar el número de columnas de un fichero csv que separa las campos con dos puntos.

1.- Extraemos la primera linea del fichero con `head`.

2.- Substituimos los separadores ":" por un retorno de línea (\n) con el editor de flujos (stream editor) `sed`. El comando `sed` ejecuta el comando de substitución `s/texto_buscado/texto_substitucion/g` Siendo la g necesaria para que globalmente substituya. si no la ponemos substituye solo la primera ocurrencia.

3.- Contamos las líneas con el comando Word count `wc`.


Encadenamos las salidas de un comando con la entrada del siguiente mediante una tubería o pipe, que se indica con una barra vertical.

```bash
head -1 flags.csv | sed -e 's/:/\\n/g' |wc -l
```


## Extraer datos de una columna

### Con awk (Aho, Weinberger, and Kernighan fueron los creadores de este comando)

Como el separador de las columnas de nuestro fichero son los dos puntos lo indicamos con el `-F`

```bash
awk -F: '{print $10}' flags.csv | head -5
```

### Con cut
Extraer un subconjunto de columnas.



```bash
cut -d: -f1,10,11 flags.csv
```


## Sumar los valores de la octava columna.

awk separa las columnas del archivo csv por el separador coma ",". En la variable sum acumula los valores de la columna 8. Cuando termine (END) ejecuta la instrucción print.

```bash
awk -F ',' ' {sum += $8} END {print sum}' detalles_banderas.csv 
```

## ¿Cuál es el máximo valor de los valores de una columna?

Sort ordena la octava columna (-k8) con un criterío numérico (-n) de mayor a menor (-r) y muestra las dos primeras filas

```bash
    sort -k8 -n  -r detalles_banderas.csv | head -2
```

## ¿Cuál es el mínimo valor de los valores de una columna
Sort ordena la octava columna (-k8) con un criterío numérico (-n) de menor a mayor y muestra las dos primeras filas

```bash
sort -k8 -n  detalles_banderas.csv | head -2
```

## ¿De cuantos continente hay banderas en el ficheros?

El indicador (-v) de grep filtra los que no tienen el texto "Continent". Esto puede ser lento para quitar la cabecera. Mejor quitar la cabecera con `tail -n +2` 

```bash
cut -d: -f11 flags.csv | sort | uniq | grep -v Continent | wc -l
cut -d: -f11 flags.csv | sort -u | grep -v Continent | wc -l
tail -n + 2 flags.csv | cut -d: -f11 | sort -u | wc -l
```


## ¿Hay paises repetidos?
Analizo los valores únicos y los comparo con el total de líneas del fichero.

```bash
cut -d: -f10 flags.csv | sort -u | grep -v Name | wc -l
```

## Encontrar las lineas que están vacías. 
Usamos las capacidades Regex de grep. Bucamos la cadena vacía con el patron '^$'.
En este caso la columna 17 tiene 187 lineas vacias. queremos contarlas

```bash
cut -d: -f17 flags.csv | sort | grep -v Text | grep '^$'| wc -l
```    

## Para saber cuantas veces aparece en la columna 9 cada valor único.
Le pedimos que `uniq` que cuente (-c) cuantas veces aparece cada uno de los valores únicos.

```bash
cut -d\; -f9 Electric_Vehicle_Population_Data.csv | sort | uniq -c
```

    78828 Battery Electric Vehicle (BEV)
        1 Electric Vehicle Type
    20956 Plug-in Hybrid Electric Vehicle (PHEV)


     

## para saber valor único que aparece **más** veces en la columna 8
   
```bash
grep -i Nissan Electric_Vehicle_Population_Data.csv | cut -d';' -f8 | sort | uniq -c | sort -t' ' -k1 -r | head -1
```   

## para saber valor único que aparece **menos** veces en la columna 8

```bash
grep -i Nissan Electric_Vehicle_Population_Data.csv | cut -d';' -f8 | sort | uniq -c | sort -t' ' -k1  | head -1
```  

## Para saber el **valor medio** de un valor en la columna 11 por las categorías que tenemos en la columna 7

Usamos dos maps/diccionarios/hash, en los que las clave son los diferentes valores de la columna 7. 

Un diccionario lo usamos para contar cuantas veces aparece un valor. `count[$7]++` suma uno al elemento de count que contiene el valor que hay en la columna 7.
Un diccionario lo usamos para sumar el valor de la columna $11 con el acumulado para el valor $7 de esa linea.
Al finalizar el tratamiento del archivo, (END), para cada clave en el diccionario count, imprimimos la clave y el resultado de dividir la suma por le numero de ocurencias 

```bash
awk -F";" '{count[$7]++; suma[$7]=suma[$7] + $11;} END {for (make in count) print make, suma[make]/count[make]}' datos.csv
``` 

## ¿Que porcentaje de valores diferentes tiene una columna?
  
Aprendemos aquí a guardar valores en una variable.

Vemos como ejecutar varios comandos en uno.

En la variable LINES guardamos el número de líneas. Paso la salida de `wc` por awk para quitar el nombre del archivo que por defecto imprime `wc`.
En la variable DISTINCT guardamos el número de valores distintos en la columna.
EN la variable PERCENT guardamos el porcentaje que representas los valores únicos sobre el total de líneas. Uso el basic calculator `bc` para hacer el cálculo con dos decimales de precisión (scale=2) 

```bash
LINES=$(wc -l Electric_Vehicle_Population_Data.csv | awk '{print $1}');DISTINCT=$(cut -d\; -f1 Electric_Vehicle_Population_Data.csv | uniq | wc -l  )  ;PERCENT=$(bc <<< "scale=2; $DISTINCT / $LINES * 100") ; echo "$(head -1 Electric_Vehicle_Population_Data.csv | cut -d\; -f1) tiene $DISTINCT valores distintos de un total de $LINES registros.Esto representa $PERCENT%"
``` 

# Detectar columnas sin información

Con la ayuda de AWK, generamos un nuevo fichero en el que se substituye las columnas vacias por  "NA".

```bash
awk -F';' -v OFS=';' '{for (i=1; i<=NF; i++) if ($i == "") $i = "NA"; print}' Electric_Vehicle_Population_Data.csv > cars01.csv
```

OFS es el Output Field Separator.

NF se refiere al numero de columnas.

$i se refiere a la una columna.


## ¿En que líneas tengo las columnas vacias?

```bash
grep -n "\;NA\;" cars01.csv 

```






# No repitas consultas. Haz un script!!!!

Puedes crear un script bash para no repetir preguntas, como la de averiguar en que columna hay una información.

## Averigua dónde está bash en tu máquina 

```bash
$ which bash
/usr/bin/bash
```

Usa esa ruta como la  de un guion o script de bash. yo lo llamo **columnas.sh**

```bash
$ echo "#\!/usr/bin/bash" > columnas.sh
$ echo "head -1 flags.csv | sed -e 's/:/:\n/g'| grep -n ':'" >> columnas.sh
$ chmod +x columnas.sh
$ ./columnas.sh
```

Notad el diferente uso del primer `>` y del segundo `>>`.

chmod +x le da permisos de ejecución al guión.





# Reduce el tamaño del fichero

A partir de consulta que hemos visto arriba ...
    
## Para saber cuantas veces aparece en la columna 9 cada valor único

```bash
cut -d\; -f9 Electric_Vehicle_Population_Data.csv | sort | uniq -c
```

Con este resultado ..... (el texto con el uno es la cabecera). 
    

```bash
78828 Battery Electric Vehicle (BEV)
1 Electric Vehicle Type
20956 Plug-in Hybrid Electric Vehicle (PHEV)
```
    
Para quitar la cabecera usad el comando `tail -n +2 <fichero>'

Podemos intuir que una **recodificación** nos haría más pequeño el fichero.
    
Contando los carácteres de la columna ... 3 260 974
    
``` bash
tail -n + 2 Electric_Vehicle_Population_Data.csv | cut -d\; -f9  | wc
```

Representan un %13.52% sobre los 24 112 773 carácters del fichero. 
Los 3 260 974 carácteres se pueden convertir en unos 99785 si dejamos solamente la "B" para el totalmente electrico y la "P" para el enchufable. 

Reduziríamos el tamaño del fichero un 13,11%.

Editamos el fichero sin abrirlo con la ayuda de sed
    
```bash
sed -i -e 's/Plug-in Hybrid Electric Vehicle (PHEV)/P/g' Electric_reduccion_1.csv
sed -i -e 's/Battery Electric Vehicle (BEV)/B/g' Electric_reduccion_1.csv 
```

Ahora los valores únicos pasan a tener este aspecto

    78828 B
    20956 P

## Creacion de un Script para hacer esta normalizacion


### Creo el shebang del script que voy a crear. El shebank le dice al script que shell lo tiene que ejecutar.

```bash 
echo "#!/usr/bin/bash" > cars_type.sh
```
### Elabora la tabla de tipos de coches. Quito la cabecera. Corto los valores de la columna 9. Ordeno los valores. Elijo los valores únicos. Número los valores únicos, separando el número del valor con una coma. El número tiene un ancho (width) mínimo de 1 caracter 

```bash
tail -n+2 cars01.csv | cut -d\; -f9|sort|uniq|nl -s',' -w1 >cars_types.csv
```

Este es el aspecto de la tabla generada

```bash
cars_types_PK,cars_types_name
1,Battery Electric Vehicle (BEV)
2,Plug-in Hybrid Electric Vehicle (PHEV)
```

### Para cada tipo de coche crea una línea de recodificación a aplicar en la tabla general. 
Este proceso implica varios pasos:
+ Para cada una de las líneas de la tabla de tipos de coches inserto en el script que estoy creando una instrucción sed.
+ La instrucción sed, substituirá el nombre del typo por su clave primaria.
+ El comando printf de awk, me ayuda a generar la instrucción sed. cada %s y en orden se substituye por $2 y $1. 
+ $2 y $1 son el segundo y el primer campo  que Awk extrae de cada linea del fichero cars_types.csv teniendo en cuenta que sus columnas están separadas por una coma.
+ Normalmente el comando sed va entre comillas simples. Aqui lo pongo entre "#" para no romper el la instrucción de awk. Por eso traduzco con tr el "#" por "'".
+ Por cada línea de cars_types.csv se inserta una línea de cars_type.sh

```bash
awk -F',' '{printf "sed -i -e #s/%s/%s/g# cars01.csv \n", $2, $1}' cars_types.csv| tr '#' "'" >> cars_type.sh
```

Este es el aspecto del script generado

```bash
#!/usr/bin/bash
sed -i -e 's/Battery Electric Vehicle (BEV)/1/g' cars01.csv 
sed -i -e 's/Plug-in Hybrid Electric Vehicle (PHEV)/2/g' cars01.csv 
```


+ Insertamos las cabeceras de la tabla cars_types.csv. con sed, inline (-i) en la línea uno inserta (1i) el texto  "cars_types_PK,cars_types_name"

```bash
sed -i '1i cars_types_PK,cars_types_name' cars_types.csv


+ Hacemos ejecutable el Script.

```bash
chmod +x cars_type.sh
```

+ Recodificamos los tipos de vehículos por su primary key en el fichero general
./cars_type.sh


# Cronometra tus comandos

    El comando time imprime cuánto tarda en ejecutarse un comando.
    
    Hay un `time` que viene en el BASH que no acepta el flag -f para formatear la salida del cronometraje.

    En codespaces no viene instalado el comando time que si lo acepta [compruebalo con `which time`] ....

    Lo instalamos así:

```bash
sudo apt-get update
sudo apt-get install time
 ```

`sorting_time.sh` muestra el tiempo que lleva ordenar un millon de lineas usando un diferente numero the **hilo** o **hebras** o **threads**.
Para lograr tener un millon de lineas he concatenado 10 veces nuestro fichero con el script make_one_million.sh

En `sorting_time.sh' el "&" indica que se ejecute en el background. 
    
Si usamos `&`, ejecutaremos en paralello los commandos del script. 

```bash
08-->53.52 Sec   8.57 Sec   0.12 Sec  
09-->53.82 Sec   8.54 Sec   0.15 Sec  
40-->53.96 Sec   8.56 Sec   0.15 Sec  
50-->54.27 Sec   8.54 Sec   0.15 Sec  
30-->54.50 Sec   8.55 Sec   0.16 Sec  
20-->54.58 Sec   8.58 Sec   0.13 Sec  
10-->54.90 Sec   8.57 Sec   0.13 Sec  
06-->61.97 Sec   8.57 Sec   0.15 Sec  
07-->62.27 Sec   8.57 Sec   0.14 Sec  
05-->62.52 Sec   8.56 Sec   0.14 Sec  
04-->62.84 Sec   8.56 Sec   0.14 Sec  
03-->68.49 Sec   8.50 Sec   0.16 Sec  
02-->68.60 Sec   8.52 Sec   0.12 Sec  
00-->68.74 Sec   8.54 Sec   0.10 Sec  
01-->70.56 Sec   6.59 Sec   0.11 Sec  
```
    
Si no usamos `&` lo ejecutamos secuencialmente.
    
```bash
00-->4.86 Sec   8.10 Sec   0.12 Sec  
01-->4.32 Sec   4.20 Sec   0.08 Sec  
02-->4.71 Sec   8.10 Sec   0.08 Sec  
03-->4.52 Sec   7.41 Sec   0.09 Sec  
04-->4.66 Sec   8.22 Sec   0.10 Sec  
05-->4.61 Sec   8.18 Sec   0.12 Sec  
06-->4.61 Sec   8.20 Sec   0.10 Sec  
07-->4.72 Sec   7.87 Sec   0.13 Sec  
08-->4.62 Sec   8.22 Sec   0.09 Sec  
09-->5.05 Sec   8.28 Sec   0.10 Sec  
10-->4.71 Sec   8.25 Sec   0.11 Sec  
20-->4.67 Sec   8.24 Sec   0.10 Sec  
30-->4.59 Sec   8.26 Sec   0.12 Sec  
40-->4.69 Sec   8.25 Sec   0.11 Sec  
50-->4.65 Sec   8.25 Sec   0.11 Sec  
```

# Detectar columnas sin información

Con la ayuda de AWK, generamos un nuevo fichero en el que se substituye las columnas vacias por  "NA".

```bash
awk -F';' -v OFS=';' '{for (i=1; i<=NF; i++) if ($i == "") $i = "NA"; print}' Electric_Vehicle_Population_Data.csv > cars_with_NA.csv
```

OFS es el Output Field Separator.

NF se refiere al numero de columnas.

$i se refiere a la una columna.

Podemos filtrar con grep para encontrar qué líneas tenemos con campos "NA" y dejar la columna "DOL_Vehicle_ID", que es la columna 14, que es la única que tiene valores únicos en la tabla, que es la única que identifica a cada vehículo en un fichero claves a borrar.

```bash
grep "\;NA\;" cars01.csv | cut -d\; -f14 > claves_a_borrar.txt
```

Con ayuda de awk creamos el script de borrado de los registros con campos 


```bash
grep "\;NA\;" cars01.csv | cut -d\; -f14 | awk '{printf "sed -i #/%s/d# cars_with_NA.csv \n", $1}'| tr "#" "'" > borra_reg_NA.sh
```

Introducimos la línea shebang a nuestro script

```bash
sed -i '1i #!/usr/bin/bash' borra_reg_NA.sh 
```

Hemos generado este script

```bash
#!/usr/bin/bash
sed -i '/250969379/d' cars_with_NA.csv 
sed -i '/274102944/d' cars_with_NA.csv 
sed -i '/270889363/d' cars_with_NA.csv 
sed -i '/274203905/d' cars_with_NA.csv 
sed -i '/274122320/d' cars_with_NA.csv 
sed -i '/272915765/d' cars_with_NA.csv 
sed -i '/272220189/d' cars_with_NA.csv 
sed -i '/275628825/d' cars_with_NA.csv 
sed -i '/274080355/d' cars_with_NA.csv 
sed -i '/187492175/d' cars_with_NA.csv 
sed -i '/274271035/d' cars_with_NA.csv 
sed -i '/230917508/d' cars_with_NA.csv 
sed -i '/275358807/d' cars_with_NA.csv 
sed -i '/272497872/d' cars_with_NA.csv 
sed -i '/283686021/d' cars_with_NA.csv 
sed -i '/274293022/d' cars_with_NA.csv 
```
Lo ejecutamos para borrar los 16 registros que tienen campos "NA"