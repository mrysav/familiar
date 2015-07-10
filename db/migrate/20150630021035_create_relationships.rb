class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      
      t.belongs_to :person
      
      t.integer :other_person_id
      t.string :kind

      t.timestamps null: false
    end
  end
end
