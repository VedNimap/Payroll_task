#!/bin/bash

#create cronjob for this file with command crontab -e


container_names=("therecruiter-web-qa" "therecruiter-postgres-qa" "therecruiter-redis-qa" "therecruiter-nginx-qa" "therecruiter-celery-qa")
BACKUP_DIR="/home/nimap/deployments/recruitment-portal/script/logs/container-logs"

for CONTAINER_NAME in "${container_names[@]}"

do
        CONTAINER_ID=$(docker container ls --no-trunc | grep $CONTAINER_NAME | awk '{print $1}')

        mkdir -p $BACKUP_DIR/${CONTAINER_NAME}/${CONTAINER_ID}/
        SOURCE_FOLDER="/var/lib/docker/containers/${CONTAINER_ID}/${CONTAINER_ID}-json.log*"
        DESTINATION_FOLDER="$BACKUP_DIR/${CONTAINER_NAME}/${CONTAINER_ID}/"

        cp $SOURCE_FOLDER $DESTINATION_FOLDER

        echo "coppied $CONTAINER_NAME log files successfully!"

done