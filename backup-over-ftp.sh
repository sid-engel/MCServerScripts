#!/bin/bash
# Basic DIR Backup over FTP

export today=$(date +%F)

#Downloads and zips the world directory
wget -r -l 0 -nH --password=PASSWORDHERE ftp://FTPUSER@FTPSERVER/REMOTEWORLDDIR -P LOCALSAVELOCATION/$today && zip -r LOCALSAVELOCATION/$today.zip LOCALSAVELOCATION/$today/ && rm -r LOCALSAVELOCATION/$today && chown user:user LOCALSAVELOCATION/$today.zip
#Remove any backups older than 30 days.
find LOCALSAVELOCATION -type f -mtime +30 -name '*.zip' -execdir rm -- '{}' \;
