# find_duplicates.rb is in lib which seperates the duplicates.
require 'find_duplicates'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def uploadcsv
  	
  end

  def readcsv
  	# check if the csv file is selected or not
  	if(params[:uploaded_file].nil?)
  		# redirect with error if no file is selected
  	redirect_to root_path, :flash => { :error => "Please select a file to upload." }
  	else	
  	# get the file path
  	file = params[:uploaded_file][:uploaded_file]
  	# create an object for FindDuplicates class
  	test = FindDuplicates.new
  	puts "test variables"
  	test.readCSV(file.path)
  	@duplicates = test.duplicateArray
  	@nonduplicates = test.nonDuplicateArray
  	end
  end

end
