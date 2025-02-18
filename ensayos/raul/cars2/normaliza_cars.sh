# Tratamiento de los campos faltantes
echo "Llenando los campos vacios con NA"
awk -F';' -v OFS=';' '{for (i=1; i<=NF; i++) if ($i == "") $i = "NA"; print}' Electric_Vehicle_Population_Data.csv > cars01.csv
# Creamos el script de borrado de los registros con campos NA. Usamos la columna 14 "DOL_Vehicle_ID" que es el identificador único
grep "\;NA\;" cars01.csv | cut -d\; -f14 | awk '{printf "sed -i #/%s/d# cars01.csv \n", $1}'| tr "#" "'" > cars_borra_reg_NA.sh
sed -i '1i #!/usr/bin/bash' cars_borra_reg_NA.sh
chmod +x cars_borra_reg_NA.sh
echo "Aislamos los registros con NA"
grep "\;NA\;" cars01.csv > cars_registros_NA.csv
echo "Borrando los registros con NA"
./cars_borra_reg_NA.sh

# --------------------------------------------------
# normaliza campo 9 tipo de vehículo
# --------------------------------------------------
echo "#!/usr/bin/bash" > cars_type.sh
#elabora la tabla de tipos de coches
tail -n+2 cars01.csv | cut -d\; -f9|sort|uniq|nl -s',' -w1 >cars_types.csv
#Para cada tipo de coche crea una línea de recodificación a aplicar en la tabla general
awk -F',' '{printf "sed -i -e #s/%s/%s/# cars01.csv \n", $2, $1}' cars_types.csv| tr '#' "'" >> cars_type.sh
#Insertamos las cabeceras de la tabla cars_types.csv.
sed -i '1i cars_types_PK,cars_types_name' cars_types.csv
chmod +x cars_type.sh
echo "Recodificando tipos de vehículos"
./cars_type.sh


cp cars01.csv cars02.csv
# --------------------------------------------------
# normaliza campo 10 elegibility
# --------------------------------------------------
echo "#!/usr/bin/bash" > cars_elegibility.sh
#elabora la tabla de tipos de elegibilidades
tail -n+2 cars02.csv | cut -d\; -f10|sort|uniq|nl -s',' -w1 >cars_elegibility.csv
#Para cada tipo de elegibilidad crea una línea de recodificación a aplicar en la tabla general
awk -F',' '{printf "sed -i -e #s/%s/%s/# cars02.csv \n", $2, $1}' cars_elegibility.csv| tr '#' "'" >> cars_elegibility.sh
#Insertamos las cabeceras de la tabla cars_elegibility.csv
sed -i '1i cars_elegb_PK,cars_elegb_name' cars_elegibility.csv
chmod +x cars_elegibility.sh
echo "Recodificando distritos elegibilidades"
./cars_elegibility.sh

cp cars02.csv cars03.csv
# --------------------------------------------------
# normaliza campo 13 legislative
# --------------------------------------------------
echo "#!/usr/bin/bash" > cars_legislative.sh
#elabora la tabla de distritos legislativos
tail -n+2 cars02.csv | cut -d\; -f13|sort|uniq|nl -s',' -w1 -b a  >cars_legislative.csv

#tail -n+2 cars02.csv | cut -d\; -f13|grep -n "^$" #detecta en que lineas hay los campos en blanco
#Para cada tipo de distrito legislativo crea una línea de recodificación a aplicar en la tabla general
awk -F',' '{printf "sed -i -e #s/%s/%s/# cars02.csv \n", $2, $1}' cars_legislative.csv| tr '#' "'" >> cars_legislative.sh
#Insertamos las cabeceras de la tabla cars_legislative.csv
sed -i '1i cars_legis_PK,cars_legis_name' cars_legislative.csv
chmod +x cars_legislative.sh
echo "Recodificando distritos legislativos"
./cars_legislative.sh

cp cars03.csv cars04.csv
# --------------------------------------------------
# normaliza campo 8 model
# --------------------------------------------------
echo "#!/usr/bin/bash" > cars_makers.sh
echo "#!/usr/bin/bash" > cars_models.sh
echo "#!/usr/bin/bash" > cars_models_gral.sh

#elabora la tabla de fabricantes
tail -n+2 cars04.csv | cut -d\; -f7|sort|uniq|nl -s',' -w1 >cars_makers.csv  
# elabora la tabla de modelos y fabicantes
tail -n+2 cars04.csv | cut -d\; -f8,7 --output-delimiter=","|sort|uniq|nl -s',' -w1 >cars_models.csv  
#Para cada fabricante crea una línea de recodificación en modelos
awk -F',' '{printf "sed -i -e #s/%s/%s/# cars_models.csv \n", $2, $1}' cars_makers.csv| tr '#' "'" >> cars_makers.sh  
chmod +x cars_makers.sh
echo "Recodificando fabricantes en modelos"
./cars_makers.sh

#Para cada modelo crea una línea de recodificación en la tabla general
awk -F',' '{printf "sed -i -e #s/%s/%s/g# cars04.csv \n", $3, $1}' cars_models.csv| tr '#' "'" >> cars_models.sh
#Para cada fabricante crea una línea de recodificación en la tabla general
awk -F',' '{printf "sed -i -e #s/\;%s\;/\;%s\;/# cars04.csv \n", $2, $1}' cars_makers.csv| tr '#' "'" >> cars_models_gral.sh
#Insertamos las cabeceras de la tabla cars_makers.csv  
sed -i '1i cars_maker_PK,cars_maker_name' cars_makers.csv  
#Insertamos las cabeceras de la tabla cars_models.csv    
sed -i '1i cars_model_PK,cars_maker_FK,cars_model_name' cars_models.csv
chmod +x cars_models_gral.sh
echo "Recodificando fabricantes "
./cars_models_gral.sh  
chmod +x cars_models.sh
echo "Recodificando modelos "
./cars_models.sh


# Eliminamos la columns de los fabricantes, que están codificados en la tabla de modelos.
cut -d\; -f1,2,3,4,5,6,8,9,10,11,12,13,14,15,16,17 cars04.csv > cars05.csv

# --------------------------------------------------
# normaliza campo 5 codigo postal , state, city, county
# --------------------------------------------------
#elabora la tabla de estados
echo "#!/usr/bin/bash" > cars_states.sh
tail -n+2 cars04.csv | cut -d\; -f4|sort|uniq|nl -s',' -w1 >cars_states.csv
# elabora la tabla de condados y estados
tail -n+2 cars04.csv | cut -d\; -f2,4 --output-delimiter=","|sort|uniq|nl -s',' -w1 >cars_counties.csv  
#Para cada estado crea una línea de recodificación en condados
awk -F',' '{printf "sed -i -e #s/%s/%s/# cars_counties.csv \n", $2, $1}' cars_states.csv| tr '#' "'" >> cars_states.sh  
# Insertamos las cabeceras de la tabla States.
sed -i '1i cars_state_PK,cars_state_name' cars_states.csv
# Insertamos las cabeceras de la tabla Counties.
sed -i '1i cars_count_PK,cars_count_name, cars_count_state_FK' cars_counties.csv
chmod +x cars_states.sh
echo "Recodificando estados en condados"
./cars_states.sh


# elabora la tabla de ciudades y condados
echo "#!/usr/bin/bash" > cars_counties.sh
tail -n+2 cars04.csv | cut -d\; -f3,2 --output-delimiter=","|sort -t',' -k2 -r |uniq|nl -s',' -w1 >cars_cities.csv  
#Para cada condado crea una línea de recodificación en ciudades
awk -F',' '{printf "sed -i -e #s/\,%s\,/\,%s\,/# cars_cities.csv \n", $2, $1}' cars_counties.csv| tr '#' "'" >> cars_counties.sh  

chmod +x cars_counties.sh
echo "Recodificando condades en ciudades"
./cars_counties.sh

# elabora la tabla de Códigos postales  y ciudades
echo "#!/usr/bin/bash" > cars_cities.sh 
# tail -n+2 cars04.csv | cut -d\; -f3,5 --output-delimiter=","|sort|uniq|nl -s',' -w1 > cars_postal_codes.csv  No numero las lineas. la PK será e codigoportal
tail -n+2 cars04.csv | cut -d\; -f5,3 --output-delimiter=","|sort|uniq > cars_postal_codes.csv  
#Para cada ciudad crea una línea de recodificación en postal_codes
awk -F',' '{printf "sed -i -e #s/%s/%s/# cars_postal_codes.csv \n", $3, $1}' cars_cities.csv | tr '#' "'" >> cars_cities.sh  
# Insertamos las cabeceras de la tabla cities.
sed -i '1i cars_cities_PK,cars_cities_county_FK,cars_cities_name' cars_cities.csv
# Insertamos las cabeceras de la tablacars_postal_codes.csv.
sed -i '1i cars_posta_cities_FK,cars_posta_PK' cars_postal_codes.csv
chmod +x cars_cities.sh  
echo "Recodificando Ciudades en codigos postales"
./cars_cities.sh

#Los codigos postales van desde "22405" a "99403" Ocupan 5 bytes como carácteres. El tipo de dato SQL SERVER 

# 2 bytes smallint	      -32,768 to        32,767 no cubre todo el rango de valores
# 4 bytes int	   -2,147,483,648 to 2,147,483,647 si cubre todo el rango de valores
# decido no recodificar los codigos postales y usarlos como clave única.
#Para cada codigo postal crea una línea de recodificación en la tabla general
#echo "#!/usr/bin/bash" > cars_postal_codes.sh 
#awk -F',' '{printf "sed -i -e #s/%s/%s/# cars04.csv \n", $3, $1}' cars_postal_codes.csv| tr '#' "'" >> cars_postal_codes.sh
#chmod +x cars_postal_codes.sh
#echo "Recodificando Codigos postales en la tabla general"
#./cars_postal_codes.sh
# Eliminamos la columns de los fabricantes, que están codificados en la tabla de modelos.
cut -d\; -f1,5,6,7,8,9,10,11,12,13,14,15,16,17 cars04.csv > cars_facts.csv
echo "borrando archivos intermedios"
rm cars01.csv cars02.csv cars03.csv cars04.csv 