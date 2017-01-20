class Note < ApplicationRecord
    include RegexConstants
    
    include PgSearch
    multisearchable :against => [:title, :tag_list] 
    
    acts_as_taggable_on :tags
    acts_as_taggable_on :people_tags
    
    before_save :update_people_tags
    
    validates :title, presence: true
    validates :content, presence: true              
    
    has_many :comments, as: :commentable, dependent: :destroy
    
    def date
        EDTF.parse(self.date)
    end

    def cool_date
        return self.date.strftime("%B %-d, %Y")
    end
    
    def self.tagged(person)
        if person.is_a? Person
            return Note.tagged_with(person.tag_name, :on => :people_tags)
        end
        []
    end
    
    private
    def update_people_tags
        people_tagged = []
        self.content.scan(REGEX_MD_LINK_TO_RESOURCE).each do |m| 
            person = REGEX_PERSON_TAG.match(m[1])
            if person
                pid = person[1]
                if Person.exists?(pid)
                    people_tagged.push("person:"+pid)
                end
            end
        end
        self.people_tag_list = people_tagged
    end
end
