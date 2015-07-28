class Photo < ActiveRecord::Base
    include PgSearch
    
    has_many :comments, dependent: :destroy
    
    has_attached_file :image,
        :styles => { :medium => "300x300>" },
        :storage => :dropbox,
        :dropbox_credentials => Rails.root.join("config/dropbox.yml")
    
    validates :image, presence: true
    validates :title, presence: true
    validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
    
    edtf :attributes => [:date]
    
    multisearchable :against => :title
end
