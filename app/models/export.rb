class Export < ActiveRecord::Base
  validates_format_of :tag, with: /[A-Za-z0-9_\-]*/, on: %i[create save]

  has_one_attached :archive
end
