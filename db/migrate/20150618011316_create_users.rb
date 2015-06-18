class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

    # omniauth-able properties
      t.string :provider
      t.string :uid
      t.string :name
      t.string :email
      t.string :image

      t.timestamps null: false
    end
  end
end
