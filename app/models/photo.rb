class Photo < ApplicationRecord
    include PgSearch
    multisearchable :against => [:title, :description, :tag_list]
    
    acts_as_taggable_on :tags
    
    validates :image, presence: true
    validates :title, presence: true
    
    edtf :attributes => [:date]
    
    has_many :comments, as: :commentable, dependent: :destroy
    
    mount_uploader :image, PhotoUploader
end
