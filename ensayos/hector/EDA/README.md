+ cabecera head 5 <file>
+ cola tail 7 <file>
+ contar columnas

    substituimos los separadores por un retorno de linea. Contamos las lineas.
    ```bash
    head -1 flags.csv | sed -e s/:/\\n/g | wc -l
    ```

+ extraer datos de una columna


    ```bash
awk -F: '{print $10}' flags.csv | head -5
    ```
awk -F: '{print $10}' flags.csv | head -5