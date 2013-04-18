class AddColumnToUploadFolders < ActiveRecord::Migration
  def change
    add_column :upload_folders, :errors, :integer
    add_column :upload_folders, :warnings, :integer
  end
end
