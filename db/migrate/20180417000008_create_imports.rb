class CreateImports < ActiveRecord::Migration[5.2]
  def change
    create_table :imports do |t|
      t.string :tag
      t.string :status
      t.string :format

      t.timestamps null: false
    end
  end
end
