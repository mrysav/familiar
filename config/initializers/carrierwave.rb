storage_type = ENV['STORAGE_TYPE']

if(storage_type == 's3')
    # Required environment variables for S3
    aws_access_key = ENV['AWS_ACCESS_KEY_ID']
    aws_secret = ENV['AWS_SECRET_ACCESS_KEY']
    s3_bucket_name = ENV['S3_BUCKET_NAME']

    # Not required
    s3_region = ENV['S3_REGION']
    s3_host = ENV['S3_HOST']
    s3_endpoint = ENV['S3_ENDPOINT']

    CarrierWave.configure do |config|
        config.fog_provider = 'fog/aws'
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

if(storage_type == 'webdav')
    # Required environment variables for WebDAV
    webdav_url = ENV['WEBDAV_URL']
    webdav_username = ENV['WEBDAV_USERNAME']
    webdav_password = ENV['WEBDAV_PASSWORD']

    CarrierWave.configure do |config|
        config.storage = :webdav
        config.webdav_server = webdav_url
        config.webdav_username = webdav_username
        config.webdav_password = webdav_password
    end
end