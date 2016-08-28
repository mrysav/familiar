class AddBirthAndDeathPlaceToPeople < ActiveRecord::Migration
  def change
    add_column :people, :birthplace, :string
    add_column :people, :burialplace, :string
  end
end
