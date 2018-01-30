# encoding: utf-8

class ArchiveUploader < CarrierWave::Uploader::Base

  # Choose what kind of storage to use for this uploader
  if ENV['STORAGE_TYPE'] == 's3'
    storage :fog
  elsif ENV['STORAGE_TYPE'] == 'webdav'
    storage :webdav
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

end
