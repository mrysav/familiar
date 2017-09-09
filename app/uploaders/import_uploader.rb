class ImportUploader < CarrierWave::Uploader::Base

  # Choose what kind of storage to use for this uploader:
  if self.fog_credentials[:provider] == 'AWS'
      storage :fog
  else
      storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/imports/"
  end

end
