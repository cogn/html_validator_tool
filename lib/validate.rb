# HTML and CSS Validators
#require 'nokogiri'
#require 'net/http'
require 'net/http/post/multipart'	

#Sending W3c request for multiple urls
def validate_helper(url,i, type,content_type,file_name)
	url = content_type.present? && content_type.eql?("files") ? (Rails.root.to_s + url) : url
	url = "#{APP_CONFIG['w3c_url']}?uri=#{URI.escape(url)}&#{APP_CONFIG['parameter_tidy']}=1" if type.downcase == 'html'
	response = Net::HTTP.get_response(URI.parse(url))
	storage_data_url,storage_data_tidy,errors=response_check(i,response,file_name)
	return storage_data_url,storage_data_tidy,errors
end

#Using to create an validation file(Complete + Tidy) 
#Using Nokogiri parse the tidy data
def tidy_datas(i,response,file_original_name)
	errors_warnings=header_manipulations(response)
	body_content=response.body
	#Used to create the complete validation data file
	path = "#{Rails.root}/public/validation_template/"
	file_name = "#{file_original_name}_validate_#{Time.now.to_s}.html"
	aFile = File.new(path + file_name, "w")
	body_content = body_content.encode('utf-8', :invalid => :replace, :undef => :replace, :replace => '_')
	aFile.write(body_content)
	aFile.close
	page = Nokogiri::HTML(open(path + file_name))  
	#Used to create the Tidy data	file
	file_name_tidy = "#{file_original_name}_#{Time.now.to_s}_tidy.html"
	bFile = File.new(path + file_name_tidy, "w")
	bFile.write(page.css('div#tidy')[0])
	bFile.close
	return file_name,file_name_tidy,errors_warnings
end

#Manipulating the header to findout errors & warnings
def header_manipulations(response)
	headers=response.to_hash
	status = headers['x-w3c-validator-status'][0]
	if status.eql?("Invalid")
		errors_warnings=headers['x-w3c-validator-errors'][0].to_s+" Errors and "+ headers['x-w3c-validator-warnings'][0].to_s+" Warnings"
		
	else
		errors_warnings="No errors"
	end
	return  errors_warnings
end

def validate_data(urls,type)
	storage_data=[]
	urls.each_with_index do |url,i|
	file_name=url.split("www.")[1]
	file_url,file_name_tidy,errors=validate_helper(url, i,'html',type,file_name) if url.present?
	folder=store_data(file_name,file_url,file_name_tidy,errors)
	storage_data << folder
end
	return storage_data
end

#Sending W3c request for multiple files & data storage in DB
def post_file(files)
	url = URI(APP_CONFIG['w3c_url'])
	storage_data=[]
	files && files.each_with_index do |data,i|
	file_name=data.original_filename.split(".htm")[0]
	req = Net::HTTP::Post::Multipart.new(url.path,APP_CONFIG['uploaded_file']=>data.read,APP_CONFIG['parameter_tidy']=>1)
	response = Net::HTTP.start(url.host, url.port) do |http|
	http.request(req)
	end
	storage_data_url,storage_data_tidy,errors=response_check(i,response,file_name)
	folder=store_data(file_name,storage_data_url,storage_data_tidy,errors)
	storage_data<<folder
	end
	return storage_data
end

#Data storage in DB
def store_data(file_name,file_url,file_name_tidy,errors)
	folder=UploadFolder.new(:file_name=>file_name,:url=>file_url,:tidy_path=>file_name_tidy,:errors_w3c => errors)
	folder.save
	return folder 
end

#Check the response valid/not
def response_check(i,response,file_name)
	if response.code.eql?("200")
	storage_data_url,storage_data_tidy,errors=tidy_datas(i,response,file_name)
	else
	storage_data_url,storage_data_tidy,errors = "","","Please Try Again Later"
	end
	return storage_data_url,storage_data_tidy,errors
end
