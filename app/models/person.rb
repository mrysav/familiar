class Person < ActiveRecord::Base
    include PgSearch
    
    edtf :attributes => [:date_of_birth, :date_of_death]
    multisearchable :against => :name
end
