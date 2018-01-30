#!/bin/bash -e

if [ -e ".env" ]; then source '.env'; fi

echo "If you do not want to use Facebook authentication, please leave the following blank."

read -p "Facebook Application ID [$FACEBOOK_ID]: " N_FACEBOOK_ID
FACEBOOK_ID="${N_FACEBOOK_ID:=$FACEBOOK_ID}"

read -p "Facebook Application Secret [$FACEBOOK_SECRET]: " N_FACEBOOK_SECRET
FACEBOOK_SECRET="${N_FACEBOOK_SECRET:=$FACEBOOK_SECRET}"

echo "If you do not want to use Google authentication, please leave the following blank."

read -p "Google Application ID [$GOOGLE_ID]: " N_GOOGLE_ID
GOOGLE_ID="${N_GOOGLE_ID:=$GOOGLE_ID}"

read -p "Google Application Secret [$GOOGLE_SECRET]: " N_GOOGLE_SECRET
GOOGLE_SECRET="${N_GOOGLE_SECRET:=$GOOGLE_SECRET}"

echo "If you don't want to store files on the local file system, leave the following blank."
read -p "Preferred storage (s3/webdav/file) [$N_STORAGE_TYPE]: " N_STORAGE_TYPE
STORAGE_TYPE="${N_STORAGE_TYPE:=$STORAGE_TYPE}"

if [ "$STORAGE_TYPE" = "s3" ]; then
    read -p "AWS Access Key ID [$AWS_ACCESS_KEY_ID]: " N_AWS_ACCESS_KEY_ID
    AWS_ACCESS_KEY_ID="${N_AWS_ACCESS_KEY_ID:=$AWS_ACCESS_KEY_ID}"

    read -p "AWS Secret Access Key [$AWS_SECRET_ACCESS_KEY]: " N_AWS_SECRET_ACCESS_KEY
    AWS_SECRET_ACCESS_KEY="${N_AWS_SECRET_ACCESS_KEY:=$AWS_SECRET_ACCESS_KEY}"

    read -p "S3 Bucket Name [$S3_BUCKET_NAME]: " N_S3_BUCKET_NAME
    S3_BUCKET_NAME="${N_S3_BUCKET_NAME:=$S3_BUCKET_NAME}"
fi

if [ "$STORAGE_TYPE" = "webdav" ]; then
    read -p "WebDAV URL [$WEBDAV_URL]: " N_WEBDAV_URL
    WEBDAV_URL="${N_WEBDAV_URL:=$WEBDAV_URL}"

    read -p "WebDAV Username [$WEBDAV_USERNAME]: " N_WEBDAV_USERNAME
    WEBDAV_USERNAME="${N_WEBDAV_USERNAME:=$WEBDAV_USERNAME}"

    read -p "WebDAV Password [$WEBDAV_PASSWORD]: " N_WEBDAV_PASSWORD
    WEBDAV_PASSWORD="${N_WEBDAV_PASSWORD:=$WEBDAV_PASSWORD}"
fi

if [ -z "$DATABASE_URL" ]; then
    read -p "Would you like to use the default Dockerized PostgreSQL? [y/n] " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        DATABASE_URL="postgres://postgres@db"
    else
        echo "You will have to edit DATABASE_URL manually in .env or modify config/database.yml to connect to your database.'"
    fi
else
    read -p "Database URL [$DATABASE_URL]: " N_DATABASE_URL
    DATABASE_URL="${N_DATABASE_URL:=$DATABASE_URL}"
fi

function gen_secret {
    echo "Regenerating secret with 'rake secret'..."
    SECRET_KEY_BASE=`rake secret`
} 

if [ -n "$SECRET_KEY_BASE" ]; then
    read -p "Would you like to regenerate SECRET_KEY_BASE? [y/n] " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        gen_secret
    fi
else
    gen_secret
fi

echo "The default Rails environment is development. You will need to change this in .env"

if [ -e "./.env" ]; then rm .env; fi

echo "FACEBOOK_ID=$FACEBOOK_ID" >> .env
echo "FACEBOOK_SECRET=$FACEBOOK_SECRET" >> .env
echo "GOOGLE_ID=$GOOGLE_ID" >> .env
echo "GOOGLE_SECRET=$GOOGLE_SECRET" >> .env
echo "STORAGE_TYPE=$STORAGE_TYPE" >> .env
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> .env
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> .env
echo "S3_BUCKET_NAME=$S3_BUCKET_NAME" >> .env
echo "WEBDAV_URL=$WEBDAV_URL" >> .env
echo "WEBDAV_USERNAME=$WEBDAV_USERNAME" >> .env
echo "WEBDAV_PASSWORD=$WEBDAV_PASSWORD" >> .env
echo "DATABASE_URL=$DATABASE_URL" >> .env
echo "SECRET_KEY_BASE=$SECRET_KEY_BASE" >> .env
echo "RAILS_ENV=development" >> .env

echo "Configuration complete. Rerun this script to change values."