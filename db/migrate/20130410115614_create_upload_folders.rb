class CreateUploadFolders < ActiveRecord::Migration
  def change
    create_table :upload_folders do |t|
      t.string :url

      t.timestamps
    end
  end
end
