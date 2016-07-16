class AddTagsToNotesAndPhotos < ActiveRecord::Migration
  def change
    add_column :notes, :tags, :string, array: true, default: []
    add_column :photos, :tags, :string, array: true, default: []
    
    add_index :notes, :tags, using: 'gin'
    add_index :photos, :tags, using: 'gin'
    
    remove_column :notes, :tag_list
    remove_column :photos, :tag_list
  end
end
