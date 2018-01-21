#!/bin/bash

# exit if any failure
set -e

SCRIPT_NAME=${0}

TMP_DIR=tmp

MYSQL_USER='user_set'; 
MYSQL_PASS='gnIIbx*kZOzspwiYwnne$h#!byO%f7sG'; 
MYSQL_DB='icitizen_users';

GCLOUD_BUCKET_URI=gs://db_daily_dumps

MONGODB_FILE=latest-prod-mongo.gz; 
MYSQL_FILE=latest-prod-mysql.dmp;

DOWNLOAD="YES"
EXCLUDE_MYSQL="NO"
EXCLUDE_MONGODB="NO"

function usage {
    echo "usage: $SCRIPT_NAME [--no-download] [--exclude-mysql] [--exclude-mongodb]"
    echo "  --no-download      do not download latest prod dump if already available"
    echo "  --exclude-mysql    exclude MySQL data from import"
    echo "  --exclude-mongodb  exclude MongoDB data from import"
    echo "  --help             display help"
    exit 1
}

for i in "$@"
do
case $i in
    --no-download)
    DOWNLOAD="NO"; 
    ;;
    --exclude-mysql)
    EXCLUDE_MYSQL="YES";
    ;;
    --exclude-mongodb)
    EXCLUDE_MONGODB="YES";
    ;;
    --help)
    usage
    ;;
    *)
    # unknown option
    ;;
esac
done

mkdir -p ${TMP_DIR}

if [[ ${EXCLUDE_MYSQL} == "NO" ]]; then

    if [[ ${DOWNLOAD} == "YES" ]]; then
        echo "Downloading MySQL files..."
        gsutil -m cp ${GCLOUD_BUCKET_URI}/${MYSQL_FILE} ${TMP_DIR}
    else
        if [ ! -f ${TMP_DIR}/${MYSQL_FILE} ]; then
            echo "Existing MySQL prod dump not found: ${TMP_DIR}/${MYSQL_FILE}"
            exit 1
        fi
    fi

    echo "Importing MySQL Database..."
    mysql --user='root' --password='' --host=127.0.0.1 ${MYSQL_DB} < ${TMP_DIR}/${MYSQL_FILE}
    echo "Successfully imported MySQL Database"
fi

if [[ ${EXCLUDE_MONGODB} == "NO" ]]; then

    if [[ ${DOWNLOAD} == "YES" ]]; then
        echo "Downloading MongoDB files..."
        gsutil -m cp ${GCLOUD_BUCKET_URI}/${MONGODB_FILE} ${TMP_DIR}
    else
        if [ ! -f ${TMP_DIR}/${MONGODB_FILE} ]; then
            echo "Existing MongoDB prod dump not found: ${TMP_DIR}/${MONGODB_FILE}"
            exit 1
        fi
    fi

    echo "Importing Mongo Databases..."
    mongorestore --host localhost:27017 \
        --drop \
        --gzip \
        --oplogReplay \
        --archive=${TMP_DIR}/${MONGODB_FILE}
    echo "Successfully imported Mongo Databases..."
fi
