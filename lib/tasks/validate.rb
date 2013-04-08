# HTML and CSS Validators
require 'nokogiri'
def validate_helper(url, type)
	url = "http://validator.w3.org/check?uri=#{URI.escape(url)}&st=1" if type.downcase == 'html'
	#~ url = "http://jigsaw.w3.org/css-validator/validator?uri=#{URI.escape(url)}" if type.downcase == 'css'
	response = Net::HTTP.get_response(URI.parse(url))
	body_content=response.body

	#Complete validation data
	aFile = File.new("validate_#{$i}.html", "w")
	aFile.write(body_content)
	aFile.close

	#Tidy data
	bFile = File.new("tidy_#{$i}.html", "w")
	page = Nokogiri::HTML(open("validate_#{$i}.html"))  
	bFile.write(page.css('div#tidy')[0])
	bFile.close
	headers=response.to_hash
	status = headers['x-w3c-validator-status'][0].downcase

	#Header Manipulations
	if ['invalid', 'valid'].include? status
	error_count, warning_count = *{'x-w3c-validator-errors' => [0], 'x-w3c-validator-warnings' => [0]}.merge(headers).values_at('x-w3c-validator-errors', 'x-w3c-validator-warnings').map(&:first)
	puts "#{type.upcase} : #{url} : #{error_count} error(s), #{warning_count} warning(s)"
	end
	$i=$i+1
end

def validate(url)
	require 'net/http'

	if url.nil? || url.strip.length < 1
	return
	end

	validate_helper url, 'html'
	#~ validate_helper url, 'css'
end
$i=0

