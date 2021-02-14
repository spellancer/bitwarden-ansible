#!/bin/bash

while getopts u:p:h:s: flag
do
    case "${flag}" in
        u) username=${OPTARG};;
        p) password=${OPTARG};;
        h) host=${OPTARG};;  # database FQDN
        s) source=${OPTARG};;  # SQL scripts source path: path to bitwarden-server/util/Migrator/DbScripts (https://github.com/bitwarden/server/tree/master/util/Migrator/DbScripts)
    esac
done


for i in $(ls -d "${source}"/*); do echo "SCRIPT: ${i}\n" ; sqlcmd -S "${host}" -i "${i}" -d vault -U "${username}" -P "${password}"; done
