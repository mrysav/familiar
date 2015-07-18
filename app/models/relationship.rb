class Relationship < ActiveRecord::Base
    include PgSearch
    
    multisearchable :against => :kind
    
    belongs_to :person
    
    def formatted
        rel_str = self.kind.to_sym
        case rel_str
            when :parent
                rel_str = self.person.gender == :female ? :mother : :father
            when :child
                rel_str = self.person.gender == :female ? :daughter : :son
        end
        rel_str.capitalize
    end
    
    def complement
        return Relationship.where(:other_person_id == self.person.id, :person_id == self.other_person_id)
    end
    
    # Get the opposite relationship type
    def self.opposite(relationshipType, gender1, gender2)
        case relationshipType.to_sym
            when :father, :mother, :parent
                :child
            when :child, :son, :daughter
                :parent
        end
    end
    
    def self.between(person1, person2)
        relation = person1.relationships.where(:other_person_id == person2.id)
        return relation.type
    end
end
