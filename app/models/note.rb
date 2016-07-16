class Note < ApplicationRecord
    include PgSearch
    
    validates :title, presence: true
    validates :content, presence: true  
    
    edtf :attributes => [:date]    
    
    multisearchable :against => [:title, :tags]            
    
    has_many :comments, as: :commentable, dependent: :destroy
        
    def self.tagged(tag)
        Note.all.select{|p| p.tagged tag }    
    end
    
    def tagged(tag)
        if tags.include? tag
            true
        else
            !!(/\[(.*)\] ?\[#{tag}\]/.match(self.content))
        end 
    end
    
    def cool_date
        return self.date.strftime("%B %-d, %Y")
    end
    
    def tag_list
        self.tags.join(', ')
    end
end
