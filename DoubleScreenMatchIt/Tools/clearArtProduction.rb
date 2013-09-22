#! /usr/bin/env ruby

require "find"

Find.find('ArtProduction')
	.select { |path| !File.directory?(path) and !path.include?('.svn')  }
	.each { |path| File.delete path }

puts "clear files success"