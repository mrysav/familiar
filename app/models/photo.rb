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
    
    multisearchable :against => [:title, :tag_list]
    
    def tags
        # gee, I hope that splitting and stripping an entire array at every request isn't a costly operation
        self.tag_list.split(",").collect(&:strip)
    end
end
