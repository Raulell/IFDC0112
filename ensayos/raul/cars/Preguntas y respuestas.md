;

# Ejercicio de análisis exploratorio de datos

Haz una copia de la carpeta "cars" a tu area de ensayo.

Vamos a realizar un análisis exploratorio de los datos contenido en el fichero Electric_Vehicle_Population_Data.csv.

El metadata del fichero es:

|Columna | Descripcion|
|----------|-----------|
|VIN (1-10)| Partial vehicle identification number consisting of the first 10 digits.|
|County| The county where the vehicle is registered.|
|City| The city where the vehicle is registered.|
|State| The state where the vehicle is registered.|
|Postal Code| The postal code of the vehicle registration location|
|Model Year| The year the vehicle was manufactured.|
|Make| The manufacturer or brand of the vehicle.|
|Model| The specific model of the vehicle.|
|Electric Vehicle Type| Indicates whether the vehicle is a Battery Electric Vehicle (BEV) or a Plug-in Hybrid Electric Vehicle (PHEV).|
|Clean Alternative Fuel Vehicle (CAFV) Eligibility| Indicates if the vehicle is eligible for Clean Alternative Fuel Vehicle benefits.|
|Electric Range| The range of the vehicle on a full electric charge.|
|Base MSRP| The manufacturer's suggested retail price for the vehicle.|
|Legislative District| The legislative district associated with the vehicle registration location.|
|DOL Vehicle ID| Unique identifier assigned by the Washington State Department of Licensing.|
|Vehicle Location| The precise location of the vehicle.|
|Electric Utility| The electric utility company associated with the vehicle.|
|2020 Census Tract| The census tract where the vehicle is registered.|

## ¿Cuántos registros hay en el fichero?
99784
```bash
Escribe tail -n +2 Electric_Vehicle_Population_Data.csv | wc -l
```

## ¿De cuántos estados hay vehículos registrados?
De 5: CA, IL, TX, VA, WA
```bash
Escribe cut -d";" -f4 Electric_Vehicle_Population_Data.csv | sort -u | grep -v "State"
```
## ¿En que posición se encuentra la columna con el año de fabricación?

6:Model Year

```bash
Escribe head -1 Electric_Vehicle_Population_Data.csv | sed -e "s/;/\n/g" | grep -n "Model Year"
```
## ¿En que año se fabricó el vehículo matriculado en Texas (TX)?
2019
```bash
Escribe awk -F";" 'NR==227 {print $6}' Electric_Vehicle_Population_Data.csv:
```
## ¿Cuál es el modelo de vehículo matriculado en Californía (CA)?

@Raulell ➜ .../IFDC0112/ensayos/raul/cars (main) $ cut -d";" -f4,6 Electric_Vehicle_Population_Data.csv | grep -n "CA"
65167:CA;2021
@Raulell ➜ .../IFDC0112/ensayos/raul/cars (main) $ awk -F";" 'NR==65167 {print $6}' Electric_Vehicle_Population_Data.csv
2021

```bash
Escribe cut -d";" -f4,6 Electric_Vehicle_Population_Data.csv | grep -n "CA"

awk -F";" 'NR==65167 {print $6}' Electric_Vehicle_Population_Data.csv
```
## ¿De cuántas ciudades del estado de Washigthon hay datos en el fichero?

```bash
Escribe  cut -d";" -f4,3 Electric_Vehicle_Population_Data.csv | grep "WA" | sort -u | wc -l
```
## De los vehículos registrados en la ciudad de Shelton, el que tiene el mayor rango electrico, ¿cuántas millas puede recorrer?
El modelo S con una sola carga puede recorrer un total de 405 millas
```bash
Escribe awk -F";" '$3 == "Shelton" && $11 == 330 {print $8}' Electric_Vehicle_Population_Data.csv

```
## ¿Cuál es el DOL vehicle ID de ese vehículo que alcanza esa distancia máxima?
108257964
```bash
Escribe awk -F";" '$3 == "Shelton" && $11 == 330 {print $14}' Electric_Vehicle_Population_Data.csv
```
## ¿Cuáles son los fabricantes que tienen más de 4000 vehiculos registrados?
Hay 6 fabricantes, BMW, CHEVROLET, FORD, KIA, NISSAN, TESLA

```bash
Escribe  awk -F";" '{print $7}' Electric_Vehicle_Population_Data.csv | sort | uniq -c | awk '$1 > 4000' | nl
```

## ¿Qué modelo de Nissan es lider en ventas?

```bash
Escribe awk -F";" 'tolower($7) == "nissan" {print $8}' Electric_Vehicle_Population_Data.csv | sort | uniq -c
```

## Ordena de mayor a menor autonomía promedio a los fabricantes

```bash
Escribe cut -d";" -f7,11 Electric_Vehicle_Population_Data.csv | awk -F";" '{sum[$1] += $2; count[$1]++} END {for (m in sum) printf "%s %.2f\n", m, sum[m] / count[m]}' | sort -nr -k2
```