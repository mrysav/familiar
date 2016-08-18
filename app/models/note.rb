class Note < ApplicationRecord
    include PgSearch
    multisearchable :against => [:title, :tag_list] 
    
    acts_as_taggable_on :tags
    
    validates :title, presence: true
    validates :content, presence: true  
    
    edtf :attributes => [:date]               
    
    has_many :comments, as: :commentable, dependent: :destroy
    
    def cool_date
        return self.date.strftime("%B %-d, %Y")
    end
end
