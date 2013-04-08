# HTML and CSS Validators
require 'nokogiri'
def validate_helper(url, type)
	#~ $i=0

	url = "http://validator.w3.org/check?uri=#{URI.escape(url)}&st=1" if type.downcase == 'html'
	#~ url = "http://jigsaw.w3.org/css-validator/validator?uri=#{URI.escape(url)}" if type.downcase == 'css'
	response = Net::HTTP.get_response(URI.parse(url))
	body_content=response.body

	#Complete validation data
	#~ system "mkdir public/complete_validate/validate_#{$i}.html"
	path = "#{Rails.root}/public/validation_template/"
	file_name = "validate_#{$i}.html"
	aFile = File.new(path + file_name, "w")
	body_content = body_content.encode('utf-8', :invalid => :replace, :undef => :replace, :replace => '_')
	aFile.write(body_content)
	aFile.close
  page = Nokogiri::HTML(open(path + file_name))  
	#Tidy data
	#~ system "mkdir public/complete_validate/validate_#{$i}.html"
	
	file_name = "tidy_#{$i}.html"
	bFile = File.new(path + file_name, "w")
	
	bFile.write(page.css('div#tidy')[0])
	bFile.close
	headers=response.to_hash
	status = headers['x-w3c-validator-status'][0].downcase

	#Header Manipulations
	if ['invalid', 'valid'].include? status
	error_count, warning_count = *{'x-w3c-validator-errors' => [0], 'x-w3c-validator-warnings' => [0]}.merge(headers).values_at('x-w3c-validator-errors', 'x-w3c-validator-warnings').map(&:first)
	puts "#{type.upcase} : #{url} : #{error_count} error(s), #{warning_count} warning(s)"
	end
end

def validate_data(url)
	require 'net/http'

	if url.nil? || url.strip.length < 1
	return
	end

	validate_helper url, 'html'
	#~ validate_helper url, 'css'
end

