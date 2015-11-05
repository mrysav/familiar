class DeleteOwnerIdAndPhotoFromComments < ActiveRecord::Migration
  def up
      remove_column :comments, :owner_id
      remove_reference :comments, :photo, index: true, foreign_key: true
      remove_reference :comments, :note, index: true, foreign_key: true
  end
  def down
      add_column :comments, :owner_id, :integer
      add_reference :comments, :photo, index: true, foreign_key: true
      add_reference :comments, :note, index: true, foreign_key: true
  end
end
