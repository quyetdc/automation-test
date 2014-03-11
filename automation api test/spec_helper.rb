#  Created by quyetdc on 2014-03-10.
#  Copyright 2014 quyetdc. All rights reserved.
require 'json'

class SpecHelper 
	@path_to_file = File.absolute_path(File.dirname(__FILE__)) + '/'
	require File.absolute_path(@path_to_file + '/constant.rb')
	
	class << self
		def is_number?(value)
		    if value =~ /^\d+$/
		    	return true
		    end
		    return false
		end

		def read_files_from_folder(folder_name)
			files = Dir.entries("#{folder_name}").to_a
			ret = []
			files.map do |e|
				if e.length > 3 ## remove . and ..
				 	ret << e	
				end 
			end

			ret
		end

		def read_lines_from_file(file_name)
			file=@path_to_file + "/#{Constant::FOLDER_NAME}/#{file_name}"
			File.readlines(file).map do |line|
				line.chomp.strip
			end
		end

		## read assertions block
		def read_assertions(arr_lines)
			parameter_string = ''
			is_getting_assertion = false

			arr_assertions = Array.new()
			index = 0
			arr_lines.each do |line|	
				if line.include? ')'
					parameter_string = parameter_string + '}'
					is_getting_assertion = false	
					
					if arr_assertions[index]
						arr_assertions[index] << parameter_string
						index += 1 
					else
						arr_assertions[index] = [parameter_string] 
					end

					parameter_string = ''
				end

				if is_getting_assertion
					parameter_string = (parameter_string + " #{line.chomp.strip}").chomp.strip
				end
				
				if line.include? '('
					is_getting_assertion = true 
					parameter_string = parameter_string + '{'
				end					

			end

			arr_assertions
		end
	end
end