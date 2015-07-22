class Person < ActiveRecord::Base
    include PgSearch
    
    # father_id and mother_id are the default names, they're already in the db
    has_parents column_names: { sex: 'gender', birth_date: 'date_of_birth', death_date: 'date_of_death' }
    
    edtf :attributes => [:date_of_birth, :date_of_death]
    multisearchable :against => :name
    
    # this has the potential to get really complicated
    def relationship_to(other)
        if self.mother_id == other.id || self.father_id == other.id
            self.is_female? ? :daughter : :son
        elsif other.mother_id == self.id
            :mother
        elsif other.father_id = self.id
            :father
        elsif self.siblings.contains(other)
            self.is_female? ? :sister : :brother
        end
    end
end
