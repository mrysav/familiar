class AddTagListToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :tag_list, :string
  end
end
