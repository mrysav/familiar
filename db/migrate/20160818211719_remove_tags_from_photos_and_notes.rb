class RemoveTagsFromPhotosAndNotes < ActiveRecord::Migration
  def change
      remove_column :photos, :tags
      remove_column :notes, :tags
  end
end
