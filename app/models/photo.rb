class Photo < ApplicationRecord
    include PgSearch
    multisearchable :against => [:title, :description, :tag_list]
    
    acts_as_taggable_on :tags
    acts_as_taggable_on :people_tags
    
    validates :image, presence: true
    validates :title, presence: true
    
    edtf :attributes => [:date]
    
    has_many :comments, as: :commentable, dependent: :destroy
    
    mount_uploader :image, PhotoUploader
    
    def self.tagged(person)
        if person.is_a? Person
            return Photo.tagged_with(person.tag_name, on: :people_tags)
        end
        []
    end
end
