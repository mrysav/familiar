class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      
      t.integer :first
      t.integer :second
      t.string :type

      t.timestamps null: false
    end
  end
end
