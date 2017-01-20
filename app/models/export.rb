class Export < ActiveRecord::Base
    validates_format_of :tag, with: /[A-Za-z0-9_\-]*/, on: [:create, :save]

    mount_uploader :archive, ArchiveUploader
end
