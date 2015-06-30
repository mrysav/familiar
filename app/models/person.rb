class Person < ActiveRecord::Base
    edtf :attributes => [:date_of_birth, :date_of_death]
end
