#!/bin/bash -e

if [ -e "./.env" ]
then
    echo "Please edit '.env' to modify configuration."
else
    echo "Facebook App ID: "
    read facebook_key
    echo "Facebook App Secret: "
    read facebook_secret
    echo "AWS Access Key ID: "
    read aws_key
    echo "AWS Secret Access Key: "
    read aws_secret
    echo "S3 Bucket Name: "
    read s3_name
    echo "running 'rake secret'..."
    secret=`rake secret`
    
    echo "FACEBOOK_ID=$facebook_key" >> .env
    echo "FACEBOOK_SECRET=$facebook_secret" >> .env
    echo "AWS_ACCESS_KEY_ID=$aws_key" >> .env
    echo "AWS_SECRET_ACCESS_KEY=$aws_secret" >> .env
    echo "S3_BUCKET_NAME=$s3_name" >> .env
    echo "SECRET_KEY_BASE=$secret" >> .env
    
    echo "Configuration complete. Please edit .env in the future."
fi
