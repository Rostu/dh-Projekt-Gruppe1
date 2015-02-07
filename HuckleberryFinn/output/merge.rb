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
if  ARGV[0] == "-h" || ARGV.size < 4 || ARGV.size > 4
	puts "-h	-->	displays this help"
	puts "-d	-->	directory of the xml files that should be merged into ..._zwischen.xml"
	puts "-f	-->	specify the file in wich you like to merge"
end

if ARGV.size == 4 && (ARGV[0] == "-d" or ARGV[0] == "-f") && (ARGV[2] == "-d" or ARGV[2] == "-f")

	if ARGV[0] == "-d"		
		folder = ARGV[1]
		file = argv[3]
	end
	if ARGV[0] == "-f"	
		file = ARGV[1]
		folder = ARGV[3]
	end	

	#search the given directory for xml files 
        directory = folder +'*.xml'	
	count = Dir.glob(directory).count
	
	if count > 0 
		puts "Starte Bearbeitung..."
	end

	if count == 0
		puts "Keine xml-Dateien gefunden"
	end

	#load the found xml files into array and sort them by filename 
	$files =  Dir.glob(directory).sort_by{|f| f.scan(/\d+/)[1].to_i }
	puts "Unter dem Pfad wurden " + count.to_s + " xml-Dateien gefunden [#{Time.now.round(3) - beginningTime.round(3)} sec]"

	#creating some variables for further use.	
	dump = []
	count = 0
	count2= 1
	#open each xml chapter file and save the sentences node of the files to a array (dump)
	$files.each do |xml_file|
		doc = Nokogiri::XML(File.open(xml_file))
		doc.encoding = 'UTF-8'
        	doc.search('//document//sentences').each do |sentences|
			dump<<sentences
			#puts xml_file + " " + count2.to_s + " eingelesen [#{Time.now.round(3) - beginningTime.round(3)} sec]"
			count2 += 1
		end
	end

	#get the xml file in which the chapters should be inserted
	#the file has to be located in the parent folder of the given chapters folder
	#also it has to be the only xml file there 

	doc2 = Nokogiri::XML(File.open(file))
	doc2.encoding = 'UTF-8'
	
	#combine the chapters in the output xml using the found "parent" xml
	doc2.search('//document//chapter').each do |chapter|
        	if count < dump.length
			chapter.content = ""
			dump[count].parent = chapter
			count += 1
                	puts "chapter "+count.to_s+" eingefügt [#{Time.now.round(3) - beginningTime.round(3)} sec]"
                	
		end
        end
	
	#save finished xml 
	outputname = file + ""
	outputname.gsub!("_zwischen","")
	File.open(outputname, 'w') { |f| f.print(doc2.to_xml) }  
	puts "all done [#{Time.now.round(3) - beginningTime.round(3)} sec]"      
end