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
beginningTime = Time.now

#nokogiri is an HTML, XML, SAX, and Reader parser 
load_gem 'nokogiri'
puts "additional libraries installed and required [#{Time.now.round(3) - beginningTime.round(3)} sec]"

#test for arguments
if ARGV.size == 0 || ARGV[0] == "-h" || ARGV.size > 2 || ARGV.size == 1 
	puts "-h	-->	displays this help"
	puts "-f	-->	to split file"
end


if ARGV.size == 2 && ARGV[0] == "-f"
	$file = ARGV[1] 	

	#open the text file ald save as string
	text = ""
	File.open($file, "r") do |f|
	  f.each_line do |line|
	 	text << line
	  end
	end

	#ensure utf-8 encoding
	begin
  		text.encode("UTF-8")
	rescue Encoding::UndefinedConversionError
  	# ...
	end
	puts "File opened and converted [#{Time.now.round(3) - beginningTime.round(3)} sec]"
	
	#first clear textjunk and add xml tags 
	text = "<document title='HUCKLEBERRY FINN' author='Mark Twain'>\n<chapter>\n<paragraph>\n" + text + "\n</paragraph>\n</chapter>\n</document>"
	altered_text = text.gsub!(/\s{4,}CHAPTER \w{1,}.\s{1,}/,"\n</paragraph>\n</chapter>\n<chapter>\n<paragraph>\n")
	altered_text.gsub!("\r\n\r\n","\n</paragraph>\n<paragraph>\n")

	#adding the id attribiute to the chapters tag
	#konverting the string to a xml doc and check if well formed 
	counter = 1
	doc = Nokogiri::XML(altered_text)
	doc.encoding = 'UTF-8'
	doc.search('//document//chapter').each do |chapter|
	        chapter["id"] = counter
		counter = counter + 1
	end
	#clearing the newlines of each paragraph and deleting the paragraph tags if needed
	doc.search('//document//chapter//paragraph').each do |para|
	        zwischen = para.content
		zwischen.gsub!("\n", " ")
		para.content = zwischen
		#next two lines delete the paragraph tags
		zwischen2 = para.content
		para.replace(zwischen2)
	end
	puts "Text cleared, xml markup done [#{Time.now.round(3) - beginningTime.round(3)} sec]"

	# save as xml file	
	File.open('HuckleberryFinn_zwischen.xml','w') {|f| doc.write_xml_to f}	
	puts "Xml file: HuckleberryFinn_zwischen.xml saved \nall done! [#{Time.now.round(3) - beginningTime.round(3)} sec]"
	
	# save as txt file 
	#File.open("HuckFinn.txt", 'w') do |file|
	#   file.puts(text)
	#end

	#save each chapter as txt file
	#chapternumber = 1
	#doc.search('//document//chapter').each do |chapter|
	#        File.open("chapter"+chapternumber.to_s+".txt" , 'w') do |file|
	#               file.puts(chapter.content)
	#        end
	#        chapternumber = chapternumber + 1
	#end
end