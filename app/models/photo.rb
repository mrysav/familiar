class Photo < ApplicationRecord
    include PgSearch
    
    has_many :comments, as: :commentable, dependent: :destroy
    
    # has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100>x100<" }
    mount_uploader :image, PhotoUploader
    
    validates :image, presence: true
    validates :title, presence: true
    # validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
    
    edtf :attributes => [:date]
    
    multisearchable :against => [:title, :description, :tags]
    
    def self.tagged(tag)
        Photo.all.select{|p| p.tagged tag }
    end
    
    def tagged(tag)
        self.tags.include? tag
    end
    
    def tag_list
        self.tags.join(', ')
    end
end
