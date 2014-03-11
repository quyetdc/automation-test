#  Created by quyetdc on 2014-03-10.
#  Copyright 2014 quyetdc. All rights reserved.

require 'mysql2'
path_to_file = File.absolute_path(File.dirname(__FILE__)) + '/'
require File.absolute_path(path_to_file + '/spec_helper.rb')

describe "Script Automation Batch" do
	db = Mysql2::Client.new(:host => "#{Constant::HOST}", :username => "#{Constant::USER_NAME}", 
  							:password=> "#{Constant::PASSWORD}", :database => "#{Constant::DATABASE}")
  	files = SpecHelper.read_files_from_folder(Constant::FOLDER_NAME)

  	files.each do |file|
  		arr_lines = SpecHelper.read_lines_from_file(file)

  		describe "#{file.to_s}" do
  			before do
  				before_queries = SpecHelper.read_before_queries(arr_lines)
  				unless before_queries.empty?
  					before_queries.each do |query|
						db.query("#{query}")
  					end
  				end  			
  			end

  			describe 'assertion' do					  			
	  			assert_queries = SpecHelper.read_assert_queries(arr_lines)  			
		  		index = 1
			  	assert_queries.each do |pair_query|
					res_1 = db.query("#{pair_query[0]}").to_a(as: :hash)	  		
					res_2 = db.query("#{pair_query[1]}").to_a(as: :hash)	  		

		  		  	it "pair #{index}" do
		  		  		expect(res_1).to eql(res_2)
		  		  	end

					index += 1
			  	end	

  			end
  			
  			after do
  				after_queries = SpecHelper.read_after_queries(arr_lines)
  				unless after_queries.empty?
  					after_queries.each do |query|
						db.query("#{query}")
  					end
  				end
  			end

  		end
	end  	  	
end
