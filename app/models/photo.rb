class Photo < ActiveRecord::Base
    include PgSearch
    
    has_many :comments, as: :commentable, dependent: :destroy
    
    has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
    
    validates :image, presence: true
    validates :title, presence: true
    validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
    
    edtf :attributes => [:date]
    
    multisearchable :against => [:title, :tag_list]
    
    def tags
        # gee, I hope that splitting and stripping an entire array
        # every time I need the tags isn't a costly operation
        self.tag_list.split(",").collect(&:strip)
    end 
    
    def self.tagged(tag)
        Photo.all.select{|p| p.tags.include? tag }
    end
end
