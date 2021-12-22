#!/bin/bash

# Author: @bruferper #

# Bash script to export data of all tables to csv format #
# Change the configuration parameters as needed #
# NOTE: create in the /home directory the file .pgpass with 600 permissions (chmod 600 .pgpass) #
# Add to the previous file the connection string with the following format: host:port:database:user:password #
# Example: 127.0.0.1:5432:db1:user1:1234 #

# Configuration parameters #
HOST=127.0.0.1
PORT=5432
USER=user
DB=testdb
OUTPUT_DIR=/tmp/exports
DELIMITER=";"

echo "### Parameters ###"
echo "Server: $HOST"
echo "Port: $PORT"
echo "User: $USER"
echo "Database: $BD"
echo "Output directory: $OUTPUT_DIR"
echo "Delimiter: $DELIMITER"

# Clean the output directory #
rm -fr $OUTPUT_DIR/*

# Extract the list of tables #
TABLES=$(psql -h $HOST -p $PORT -U $USER -d $DB -qtAc "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';")
if [ $? -ne 0 ] ; then
        echo "Error connecting to the server. Verify connection parameters."
        exit 1
fi

echo "### Start of process ###"

# Iterate the list of tables #
for TABLE in $TABLES
do

        # Creates the output file #
        OUTPUT_FILE=$TABLE.csv

        echo "$(date +"%d-%m-%Y %H:%M:%S") - Export of table: $TABLE -> $OUTPUT_FILE"

        psql -h $HOST -p $PORT -U $USER -d $DB -t -A -F $DELIMITER -c "SELECT * FROM $TABLE" > $OUTPUT_DIR/$OUTPUT_FILE
        if [ $? -ne 0 ] ; then
                echo "Error performing the export."
        fi

done

echo "### End of process ###"
