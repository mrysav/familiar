class CreateExports < ActiveRecord::Migration
  def change
    create_table :exports do |t|
      t.string :tag
      t.string :archive
      t.string :status
      t.string :format

      t.timestamps null: false
    end
  end
end
