class AddNewColumnToUploadFolders < ActiveRecord::Migration
  def change
    add_column :upload_folders, :status, :string
  end
end
