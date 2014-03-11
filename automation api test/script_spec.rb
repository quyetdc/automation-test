#  Created by quyetdc on 2014-03-10.
#  Copyright 2014 quyetdc. All rights reserved.

require 'mysql2'
require 'json'
require "net/http"
require "uri"

path_to_file = File.absolute_path(File.dirname(__FILE__))
require File.absolute_path(path_to_file + '/spec_helper.rb')

describe "ApiAutomationTest" do

  	files = SpecHelper.read_files_from_folder(Constant::FOLDER_NAME)
  	files.each do |file|
  		arr_lines = SpecHelper.read_lines_from_file(file)

  		describe "#{file.to_s}" do
			_arr_assertions = SpecHelper.read_assertions(arr_lines)
			index = 1
			_arr_assertions.each do |_assertion|
				it "pair -- #{index}" do
	  				json_params = {:data => JSON.parse(_assertion[0])['data'].to_json}

	  				baseurl = "#{Constant::API_URL}"
 					response = Net::HTTP.post_form(URI(baseurl), json_params)  				
	  				
	  				index += 1
	  				expect(JSON.parse(response.body)).to eql(JSON.parse(_assertion[1])) 
	  			end	
			end  			
  		end
  	end	
end