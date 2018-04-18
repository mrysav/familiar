class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|

      # Properties required for OmniAuth
      t.string :provider
      t.string :uid

      # Custom properties
      t.string :name
      t.string :image
      t.boolean :editor

      t.timestamps null: false
    end
  end
end
