#!/usr/bin/bash

# Es una tontería. Hago una copia solamente para tener un mombre de archivo mas
# corto en el comando cat.
# Es mejor al principio del ejercicio haber cambiado el largo nombre
cp Electric_Vehicle_Population_Data.csv a.csv
cat a.csv a.csv a.csv a.csv a.csv a.csv a.csv a.csv a.csv a.csv  > one_million.csv
rm a.csv
