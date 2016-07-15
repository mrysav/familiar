class Note < ApplicationRecord
    include PgSearch
    
    validates :title, presence: true
    validates :content, presence: true  
    
    edtf :attributes => [:date]    
    
    multisearchable :against => [:title, :tag_list]            
    
    has_many :comments, as: :commentable, dependent: :destroy    
        
    def tags        
        # gee, I hope that splitting and stripping an entire array        
        # every time I need the tags isn't a costly operation        
        self.tag_list.split(",").collect(&:strip)    
    end         
        
    def self.tagged(tag)        
        Note.all.select{|p| p.tags.include? tag }    
    end
    
    def cool_date
        return self.date.strftime("%B %-d, %Y")
    end
end
