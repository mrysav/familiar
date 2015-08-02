class Person < ActiveRecord::Base
    include PgSearch
    
    validates :name, presence: true
    
    # father_id and mother_id are the default names, they're already in the db
    has_parents column_names: { sex: 'gender', birth_date: 'date_of_birth', death_date: 'date_of_death' }, current_spouse: true
    
    edtf :attributes => [:date_of_birth, :date_of_death]
    multisearchable :against => :name
    
    # this has the potential to get really complicated
    def relationship_to(other)
        if self.mother_id == other.id || self.father_id == other.id
            self.is_female? ? :daughter : :son
        elsif other.mother_id == self.id
            :mother
        elsif other.father_id == self.id
            :father
        elsif self.siblings.include? other
            self.is_female? ? :sister : :brother
        elsif self.current_spouse_id == other.id
            self.is_female? ? :wife : :husband
        elsif self.spouses.include? other
            other.is_female? ? :'former wife' : :'former husband'
        end
    end
    
    # TODO: maybe account for which generation eventually as well
    # also, obviously a person can live to be older than 90,
    # but the US census releases records after 70 years 
    # so I figure I'm good here
    def probably_dead?
        self.date_of_death.present? ||
        (self.date_of_birth.present? &&
         Date.today.year - self.date_of_birth.year > 90)
    end
    
    def probably_alive?
        !self.probably_dead?
    end
    
    # only show alive people to logged in editors
    def can_see(current_user)
        self.probably_dead? || (current_user != nil && current_user.editor?)
    end
end
