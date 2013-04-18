class ChangeColumnUpdateFolders < ActiveRecord::Migration
  def up
	rename_column :upload_folders, :errors, :errors_w3c
	rename_column :upload_folders, :warnings, :warnings_w3c
  end

  def down
  end
end
