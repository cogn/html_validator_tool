class ChangeDateFormatInMyTable < ActiveRecord::Migration
  def up
	     change_column :upload_folders, :errors_w3c, :string
  end

  def down
	  	     change_column :upload_folders, :errors_w3c, :integer
  end
end
