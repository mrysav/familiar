class AddOwnerIdToComments < ActiveRecord::Migration
    def up
        add_column :comments, :owner_id, :integer
        
    end
    def down
        remove_column :comments, :owner_id
    end
end
