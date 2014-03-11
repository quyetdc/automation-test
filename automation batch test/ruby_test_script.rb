#  Created by quyetdc on 2014-03-10.
#  Copyright 2014 quyetdc. All rights reserved.

require "test/unit"
require 'mysql2'
path_to_file = File.absolute_path(File.dirname(__FILE__)) + '/'
require File.absolute_path(path_to_file + '/constant.rb')


class AutomationTestBatch < Test::Unit::TestCase

	def read_files_from_folder(folder_name)
		files = Dir.entries("#{folder_name}")
		files.each do |e| 
			if File.exists? e ## remove . and ..
			 	files.delete e	
			end 
		end

		files
	end

	def read_from_file(file_name)
		file="#{file_name}"
		query = ''
		is_getting_query = false
		arr_queries = Array.new()
		index = 0
		arr_lines = File.readlines(file)
		arr_lines.each do |line|
			if line.include? '}'
				is_getting_query = false
				if arr_queries[index]
					arr_queries[index] << query
					index += 1
				else
					arr_queries << [query] 
				end				
				
				query = ''
			end

			if is_getting_query
			    query = query + " #{line.chomp.strip}"
			end
		    is_getting_query = true if line.include? '{'
		end

		arr_queries
	end

 
  	def test_script
	  	db = Mysql2::Client.new(:host => "#{Constant::HOST}", :username => "#{Constant::USER_NAME}", 
	  							:password=> "#{Constant::PASSWORD}", :database => "#{Constant::DATABASE}")
	  	files = read_files_from_folder(Constant::FOLDER_NAME)
	  	puts 'files -- ' + files.to_s
	  	files.each do |file|
	  		arr_queries = read_from_file(File.absolute_path(File.dirname(__FILE__)) + "/#{Constant::FOLDER_NAME}/#{file}")
		  	index = 1
		  	arr_queries.each do |pair_query|
		  		puts 'index -- ' + index.to_s
				res_1 = db.query("#{pair_query[0]}").to_a(as: :hash)	  		
				res_2 = db.query("#{pair_query[1]}").to_a(as: :hash)	  		
				assert_equal(res_1, res_2, "fail on pair -- #{index}")
				index += 1
		  	end	
		end  	
  	end
 
end