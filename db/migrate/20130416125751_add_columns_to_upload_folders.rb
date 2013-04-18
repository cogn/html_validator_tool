class AddColumnsToUploadFolders < ActiveRecord::Migration
  def change
    add_column :upload_folders, :parent_id, :integer
    add_column :upload_folders, :file_name, :string
    add_column :upload_folders, :tidy_path, :string
  end
end
