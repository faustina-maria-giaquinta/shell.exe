#! /bin/bash

number_connections=$(last | grep -c $USER) && current_date=$(date +%d-%m-%Y-%H:%M) && filename="number-connection-"$current_date &&\
echo $number_connections >> $filename

backup_folder="Backup" && mkdir -p $backup_folder
tar -czf "$backup_folder/$filename.tar.gz" $filename && rm $filename
