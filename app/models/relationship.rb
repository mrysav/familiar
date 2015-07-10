class Relationship < ActiveRecord::Base
    include PgSearch
    
    multisearchable :against => :kind
    
    belongs_to :person
    
    # Get the opposite relationship type
    def self.opposite(relationshipType, gender1, gender2)
        case relationshipType.to_sym
            when :father, :mother, :parent
                :child
            when :child
                gender2 == :female ? :mother : :father
        end
    end
    
    def self.between(person1, person2)
        relation = person1.relationships.where(:other_person_id == person2.id)
        return relation.type
    end
end
