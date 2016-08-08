class RenameThumbUrlToThumbImage < ActiveRecord::Migration
  def change
    rename_column :courses, :thumb_url, :thumb_image
  end
end
