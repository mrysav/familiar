class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
    
      t.string :name
      t.string :date_of_birth
      t.string :date_of_death

      t.timestamps null: false
    end
  end
end
