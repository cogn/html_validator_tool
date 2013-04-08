class ValidatorController < ApplicationController
  layout "index",:except=>:show
  def index
  end

  def validate
    require 'validate'
    puts "ttttttttttttttttttttttttttttttttttttttttttttttt"
    multi_url = params[:uri].split(",")
     p "IAM HERE---------------------"
    p multi_url.length
    multi_url && multi_url.each_with_index do |url,i|
      $i=i
      validate_data url
      $i=$i+1
    end
   
    redirect_to :action => "show"
  #~ require 'validate'
  #~ validate 'http://binarytides.com'
  #~ validate 'http://cognizant.com'
  #~ validate 'http://google.com'
  end

  def show
    #~ @files_count=$i
  end

  def download
    send_file "#{Rails.root}/public/validation_template/tidy_#{params[:id]}.html"
  end

end
