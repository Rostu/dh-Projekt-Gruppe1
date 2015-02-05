
#function to check if the needed ruby gem is installed
#if not the function installs and requires it
def load_gem(name, version=nil)
  # needed if your ruby version is less than 1.9
  require 'rubygems'

  begin
    gem name, version
  rescue LoadError
    version = "--version '#{version}'" unless version.nil?
    system("gem install #{name} #{version}")
    Gem.clear_paths
    retry
  end

  require name
end

#nokogiri is an HTML, XML, SAX, and Reader parser 
load_gem 'nokogiri'


#test for arguments
if ARGV.size == 0 || ARGV[0] == "-h" || ARGV.size > 2 || ARGV.size == 1 
	puts "-h	-->	displays this help"
	puts "-f	-->	to split file"
end


if ARGV.size == 2 && ARGV[0] == "-f"
	file = ARGV[1] 
	counter = 1

	doc = Nokogiri::XML(File.open(file))
	doc.encoding = 'UTF-8'
	doc.xpath("//document//chapter").each do |chapter|
		if counter < 10
			File.open("chapter0" + counter.to_s + ".txt", "w+") do |file|
				file.write(chapter.content)
			end
		end
		if counter >= 10
			File.open("chapter" + counter.to_s + ".txt", "w+") do |file|
				file.write(chapter.content)
			end
		end		
		counter = counter + 1
	end
end

