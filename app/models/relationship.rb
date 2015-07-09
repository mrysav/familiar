class Relationship < ActiveRecord::Base
    include PgSearch
    
    multisearchable :against => :type
    
    belongs_to :person
    
    # Get the opposite relationship type
    def self.opposite(relationshipType, gender1, gender2)
        case relationshipType
            when :father, :mother, :parent
                return :child
            when :child
                gender2 == :female ? :mother : :father
        end
    end
end
