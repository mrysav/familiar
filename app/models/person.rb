class Person < ApplicationRecord
    include PgSearch
    
    validate :name_present

    multisearchable :against => [:first_name, :last_name]
    
    def father
        Person.find(self.father_id) if self.father_id
    end

    def father=(value)
        self.father_id = value.id if value.instance_of? Person
    end

    def mother
        Person.find(self.mother_id) if self.mother_id
    end

    def mother=(value)
        self.mother_id = value.id if value.instance_of? Person
    end

    def current_spouse
        Person.find(self.current_spouse_id) if self.current_spouse_id
    end

    def current_spouse=(value)
        self.current_spouse_id = value.id if value.instance_of? Person
    end

    def siblings
        if(self.mother_id && self.father_id)
            Person.where('(mother_id = ? or father_id = ?) and id != ?', self.mother_id, self.father_id, self.id)
        elsif(self.mother_id && !self.father_id)
            Person.where('mother_id = ? and id != ?', self.mother_id, self.id)
        elsif(!self.mother_id && self.father_id)
            Person.where('father_id = ? and id != ?', self.father_id, self.id)
        else
            []
        end
    end

    def children
        Person.where('mother_id = ? or father_id = ?', self.id, self.id)
    end

    def spouses
        Person.where(current_spouse_id: self.id)
    end
    
    def is_female?
        self.gender == 'F'
    end

    def is_male?
        self.gender == 'M'
    end

    def birth_date
        EDTF.parse(self.date_of_birth)
    end

    def death_date
        EDTF.parse(self.date_of_death)
    end

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
    
    def full_name
        [self.first_name, self.last_name].join(' ')
    end
    
    # TODO: maybe account for which generation eventually as well
    # also, obviously a person can live to be older than 90,
    # but the US census releases records after 70 years 
    # so I figure I'm good here
    def probably_dead?
        self.date_of_death.present? ||
        (self.date_of_birth.present? &&
         Date.today.year - self.birth_date.year > 90)
    end
    
    def probably_alive?
        !self.probably_dead?
    end
    
    # only show alive people to logged in editors
    def can_be_seen_by(current_user)
        self.probably_dead? || (current_user != nil && current_user.editor?)
    end
    
    def tag_name
        'person:' + self.id.to_s
    end
    
    # TODO: deprecate
    def to_gedx_json
        {
            :private => !self.probably_dead?,
            :gender => {
                :type => self.is_female? ? "http://gedcomx.org/Female" : "http://gedcomx.org/Male"
            },
            :names => [{
                :nameForms => [{
                    :fullText => self.name
                }]
            }]
        }
    end
    
    private
    def name_present
      if self.first_name.blank? && self.last_name.blank?
        errors[:base] << "Must provide a first or last name."
      end
    end
end
