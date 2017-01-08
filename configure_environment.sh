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

echo "Amazon S3 is used for photo storage."
echo "If you don't want to use S3 for storage, leave the following blank.'"

read -p "AWS Access Key ID [$AWS_ACCESS_KEY_ID]: " N_AWS_ACCESS_KEY_ID
AWS_ACCESS_KEY_ID="${N_AWS_ACCESS_KEY_ID:=$AWS_ACCESS_KEY_ID}"

read -p "AWS Secret Access Key [$AWS_SECRET_ACCESS_KEY]: " N_AWS_SECRET_ACCESS_KEY
AWS_SECRET_ACCESS_KEY="${N_AWS_SECRET_ACCESS_KEY:=$AWS_SECRET_ACCESS_KEY}"

read -p "S3 Bucket Name [$S3_BUCKET_NAME]: " N_S3_BUCKET_NAME
S3_BUCKET_NAME="${N_S3_BUCKET_NAME:=$S3_BUCKET_NAME}"

echo "Regenerating secret with 'rake secret'..."
SECRET_KEY_BASE=`rake secret`

if [ -e "./.env" ]; then rm .env; fi

echo "FACEBOOK_ID=$FACEBOOK_ID" >> .env
echo "FACEBOOK_SECRET=$FACEBOOK_SECRET" >> .env
echo "GOOGLE_ID=$GOOGLE_ID" >> .env
echo "GOOGLE_SECRET=$GOOGLE_SECRET" >> .env
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> .env
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> .env
echo "S3_BUCKET_NAME=$S3_BUCKET_NAME" >> .env
echo "SECRET_KEY_BASE=$SECRET_KEY_BASE" >> .env

echo "Configuration complete. Rerun this script to change values."