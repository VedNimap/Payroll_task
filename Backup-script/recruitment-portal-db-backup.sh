#!/bin/bash

set -e
set -o pipefail


#AWS credentials
export AWS_ACCESS_KEY_ID=$ACCESSKEYID
export AWS_SECRET_ACCESS_KEY=$SECRETACCESSKEY
AWS_DEFAULT_REGION="ap-south-1"

#database environment variables
PG_HOST="*****"
PG_PORT="5432"
PG_USER="****"
PG_PASSWORD="*****"
PG_DATABASE="therecruiter"
BACKUP_DIR="/home/nimap/deployments/recruitment-portal/script/backup"
CONTAINER_NAME="therecruiter-postgres-qa"

#s3 bucket variables
BucketName="recruitment-portal-qa"
BACKUP_FILENAME="db_backup_$(date +%Y-%m-%d_%H:%M:%S).sql"
# bkupFolder="db-s3-backup_$(date +%Y-%m-%d)"
#db_bkupFolder="db/db-s3-backup_$(date +%Y-%m-%d_%H-%M-%S)"
db_bkupFolder="db"
media_bkupFolder="media/media-s3-backup_$(date +%Y-%m-%d_%H-%M-%S)"

#backup duration
DAYS="7"

#delete files older than 7 days
find "$BACKUP_DIR/db" -type f -mtime +"$DAYS" -delete

#backup commands
docker exec -t $CONTAINER_NAME pg_dumpall -c -U $PG_USER > $BACKUP_DIR/db/$BACKUP_FILENAME
docker cp $CONTAINER_NAME:/media/ $BACKUP_DIR/media/

echo "db coppied"
/usr/local/bin/aws s3 sync $BACKUP_DIR/db/ s3://$BucketName/$db_bkupFolder/
/usr/local/bin/aws s3 sync /var/lib/docker/volumes/recruitmentportalqa_therecruiter-media/_data s3://$BucketName/$media_bkupFolder/

#echo "successful!"