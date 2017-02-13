# Required environment variables for S3
aws_access_key = ENV['AWS_ACCESS_KEY_ID']
aws_secret = ENV['AWS_SECRET_ACCESS_KEY']
s3_bucket_name = ENV['S3_BUCKET_NAME']

# Not required
s3_region = ENV['S3_REGION']
s3_host = ENV['S3_HOST']
s3_endpoint = ENV['S3_ENDPOINT']

s3_enabled = Rails.env.production? && !(aws_access_key.blank? || aws_secret.blank? || s3_bucket_name.blank?)

if s3_enabled
    CarrierWave.configure do |config|
        config.fog_credentials = {
            provider:              'AWS',
            aws_access_key_id:     aws_access_key,
            aws_secret_access_key: aws_secret,
        }

        config.fog_credentials[:region]    = s3_region if !s3_region.blank?
        config.fog_credentials[:host]      = s3_host if !s3_host.blank?
        config.fog_credentials[:endpoint]  = s3_endpoint if !s3_endpoint.blank?

        config.fog_directory  = s3_bucket_name
    end
end