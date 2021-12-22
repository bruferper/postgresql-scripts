#!/bin/bash

# Script en bash para exportar los datos de las tablas de una base de datos en formato csv #
# Cambiar los parametros de configuracion a los correspondientes de donde se desee correr #

# Configuracion de parametros #
HOST=127.0.0.1
PORT=5432
USER=usuario
DB=prueba
OUTPUT_DIR=/tmp/exports
DELIMITER=";"

echo "### Parametros ###"
echo "Servidor: $HOST"
echo "Puerto: $PORT"
echo "Usuario: $USER"
echo "Base de datos: $BD"
echo "Directorio de salida: $OUTPUT_DIR"
echo "Delimitador: $DELIMITER"

# Se limpia el directorio de salida #
rm -fr $OUTPUT_DIR/*

# Se extrae la lista de tablas de la BD #
TABLAS=$(psql -h $HOST -p $PORT -U $USER -d $DB -qtAc "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';")
if [ $? -ne 0 ] ; then
        echo "Error al conectarse al servidor de base de datos. Verificar datos de conexion."
        exit 1
fi

echo "### Comienzo del proceso ###"

# Se recorre cada tabla de la lista #
for TABLA in $TABLAS
do

        # Se crea el archivo de salida #
        OUTPUT_FILE=$TABLA.csv

        echo "$(date +"%d-%m-%Y %H:%M:%S") - Export de la tabla: $TABLA -> $OUTPUT_FILE"

        psql -h $HOST -p $PORT -U $USER -d $DB -t -A -F $DELIMITER -c "SELECT * FROM $TABLA" > $OUTPUT_DIR/$OUTPUT_FILE
        if [ $? -ne 0 ] ; then
                echo "Error al realizar el export de la tabla."
        fi

done

echo "### Fin del proceso ###"
