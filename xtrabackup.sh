#!/bin/bash

set -eo pipefail

mysql_user=${MYSQL_USER:-root}
mysql_password=${MYSQL_PASSWORD}
mysql_host=${MYSQL_HOST:-127.0.0.1}
s3_bucket=${S3_BUCKET}
s3_access_key=${S3_ACCESS_KEY}
s3_secret_key=${S3_SECRET_KEY}

function write_log {
	echo "`date +'%Y%m%d %H%M%S'`: $1"
}

if [ -z "$mysql_password" ] || [ -z "$s3_bucket" ] || [ -z "$s3_access_key" ] || [ -z "$s3_secret_key" ]; then
	write_log "One or more parameter empty"
	exit 1
fi

timestamp=$(date +'%Y%m%d_%H%M%S')
filename="xtrabackup-${timestamp}.xbstream"
tmpfile="/$filename"
date=$(date +'%Y%m%d')
hostname=$(hostname)
object="s3://${s3_bucket}/${hostname}/${date}/${filename}"

write_log "Running xtrabackup"

xtrabackup --host=$mysql_host --user=$mysql_user --password=$mysql_password --backup --stream=xbstream --compress > $tmpfile

write_log "Uploading archive to S3"
AWS_ACCESS_KEY_ID=$s3_access_key AWS_SECRET_ACCESS_KEY=$s3_secret_key aws s3 cp $tmpfile $object --no-progress
rm -f $tmpfile
