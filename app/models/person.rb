class Person < ActiveRecord::Base
    include PgSearch
    
    has_many :relationships
    
    edtf :attributes => [:date_of_birth, :date_of_death]
    multisearchable :against => :name
end
