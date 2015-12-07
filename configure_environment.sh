#!/bin/bash -e

if [ -e "./.env" ]; then source '.env'; fi

if [ -z ${FACEBOOK_ID+x} ]; then
    read -p "Facebook Application ID: " FACEBOOK_ID
fi

if [ -z ${FACEBOOK_SECRET+x} ]; then
    read -p "Facebook Application Secret: " FACEBOOK_SECRET
fi

if [ -z ${AWS_ACCESS_KEY_ID+x} ]; then
    read -p "AWS Access Key ID (only used in 'production' environment): " AWS_ACCESS_KEY_ID
fi

if [ -z ${AWS_SECRET_ACCESS_KEY+x} ]; then
    read -p "AWS Secret Access Key (only used in 'production' environment): " AWS_SECRET_ACCESS_KEY
fi

if [ -z ${S3_BUCKET_NAME+x} ]; then
    read -p "AWS S3 Bucket Name (only used in 'production' environment): " S3_BUCKET_NAME
fi

if [ -z ${SECRET_KEY_BASE+x} ]; then
    echo "Generating secret with 'rake secret'..."
    SECRET_KEY_BASE=`rake secret`
fi

if [ -e "./.env" ]; then rm .env; fi

echo "FACEBOOK_ID=$FACEBOOK_ID" >> .env
echo "FACEBOOK_SECRET=$FACEBOOK_SECRET" >> .env
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> .env
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> .env
echo "S3_BUCKET_NAME=$S3_BUCKET_NAME" >> .env
echo "SECRET_KEY_BASE=$SECRET_KEY_BASE" >> .env

echo "Configuration complete. Please edit .env if you need to change these values."
