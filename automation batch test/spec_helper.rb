#  Created by quyetdc on 2014-03-10.
#  Copyright 2014 quyetdc. All rights reserved.

class SpecHelper
	@path_to_file = File.absolute_path(File.dirname(__FILE__)) + '/'
	require File.absolute_path(@path_to_file + '/constant.rb')
	class << self
		
		def read_files_from_folder(folder_name)
			files = Dir.entries("#{folder_name}")
			files.each do |e| 
				if File.exists? e ## remove . and ..
				 	files.delete e	
				end 
			end

			files
		end

		def read_lines_from_file(file_name)
			file=@path_to_file + "/#{Constant::FOLDER_NAME}/#{file_name}"
			File.readlines(file)
		end

		## read queries in before block
		def read_before_queries(arr_lines)
			query = ''
			is_getting_query = false
			is_in_before_block = false

			before_queries = Array.new()
			index = 0
			arr_lines.each do |line|	
				if line.include? 'end'
					is_in_before_block = false	
					break
				end

				if line.include? '}'
					is_getting_query = false	
					before_queries << query
					query = ''
				end

				if is_in_before_block && is_getting_query
					query = (query + " #{line.chomp.strip}").chomp.strip
				end

				if line.include? 'before'
					is_in_before_block = true	
				end
				
				if line.include? '{'
					is_getting_query = true 
				end
			end

			before_queries
		end

		## read queries in assert block
		def read_assert_queries(arr_lines)
			query = ''
			is_getting_query = false
			is_in_assert_block = false

			assert_queries = Array.new()
			index = 0
			arr_lines.each do |line|	
				if is_in_assert_block
					if line.include? 'after'
						is_in_assert_block = false
						break
					end

					if line.include? '}'
						is_getting_query = false	
						
						if assert_queries[index]
							assert_queries[index] << query
							index += 1 
						else
							assert_queries[index] = [query] 
						end

						query = ''
					end

					if is_in_assert_block && is_getting_query
						query = (query + " #{line.chomp.strip}").chomp.strip
					end

					if line.include? 'end'
						is_in_assert_block = true	
					end
					
					if line.include? '{'
						is_getting_query = true 
					end					
				end

				if line.include? 'end'
					is_in_assert_block = true	
				end
			end

			assert_queries
		end

		## read queries in after block
		def read_after_queries(arr_lines)
			query = ''
			is_getting_query = false
			is_in_after_block = false

			after_queries = Array.new()
			index = 0
			arr_lines.each do |line|	
				if is_in_after_block
					if line.include? 'end'
						is_in_after_block = false	
						break
					end

					if line.include? '}'
						is_getting_query = false	
						after_queries << query
						query = ''
					end

					if is_in_after_block && is_getting_query
						query = (query + " #{line.chomp.strip}").chomp.strip
					end

					if line.include? '{'
						is_getting_query = true 
					end				
				end

				if line.include? 'after'
					is_in_after_block = true	
				end							
			end

			after_queries
		end

	end	
end
