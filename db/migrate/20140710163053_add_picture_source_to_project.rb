class AddPictureSourceToProject < ActiveRecord::Migration
  def change
    add_column :projects, :picture_source, :text
  end
end
