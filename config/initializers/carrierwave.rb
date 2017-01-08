# Required environment variables for S3
aws_access_key = ENV['AWS_ACCESS_KEY_ID']
aws_secret = ENV['AWS_SECRET_ACCESS_KEY']
s3_bucket_name = ENV['S3_BUCKET_NAME']

# Not required
s3_region = ENV['S3_REGION'] || 'us-east-1'
s3_host = ENV['S3_HOST']
s3_endpoint = ENV['S3_ENDPOINT']

s3_enabled = !(aws_access_key.blank? || aws_secret.blank? || s3_bucket_name.blank?)

if s3_enabled
    CarrierWave.configure do |config|
        config.fog_credentials = {
            provider:              'AWS',
            aws_access_key_id:     aws_access_key,
            aws_secret_access_key: aws_secret,
            region:                s3_region,
            host:                  s3_host,
            endpoint:              s3_endpoint
        }
        config.fog_directory  = s3_bucket_name
    end
end