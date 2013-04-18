class ValidatorController < ApplicationController
  layout "application", :except=>[:get_urls,:show_tidy]
  require 'validate'
def index

end

def validate_urls
	multi_url = params[:uri].split(",")
	storage_data =  validate_datas(multi_url)
	redirect_to :action => "show",:urls_count => storage_data.map(&:id)
end

def validate_files
end

def get_urls
	storage_data = post_file(params["files"]["attachment"] ) if params["files"]["attachment"] 
	redirect_to :action => "show",:urls_count => storage_data.map(&:id)
end

def validate_datas(multi_url,type=nil)
	urls_count=multi_url.present? ? validate_data(multi_url,type) : 0
end

def show
	@files = UploadFolder.find_all_by_id(params[:urls_count])
end

def download
	file_record = UploadFolder.find(params[:id])
	send_file "#{Rails.root}/public/validation_template/#{file_record.tidy_path}"
end

end


