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


#two ruby gems that save a lot of work 
#nokogiri is an HTML, XML, SAX, and Reader parser 
load_gem 'nokogiri'
#yomu is a ruby gem that includes librarys to read and convert pdf files
load_gem 'yomu'
puts "additional libraries installed and required [#{Time.now.round(3) - beginningTime.round(3)} sec]"

#test for arguments
if ARGV.size == 0 || ARGV[0] == "-h" || ARGV.size > 2 || ARGV.size == 1 
	puts "-h	-->	displays this help"
	puts "-f	-->	operates on the given file"
end

#open the pdf and converting the input to a string
if ARGV.size == 2 && ARGV[0] == "-f"
	$file = ARGV[1]
	
	yomu = Yomu.new $file
	text = yomu.text
	puts "File opened and converted [#{Time.now.round(3) - beginningTime.round(3)} sec]"
	#saves plain_text output from the pdf converter to txt file 
	#was used to check the output while working on the file
	#File.open($file[0..-5]+"_plain.txt", 'w') do |file|
        #file.puts(text)
        #end

	#clearing obvious text junk 
	text.gsub!("Source URL: http://etext.virginia.edu/etcbin/toccer-\n","")
	text.gsub!("new2?id=StoCabi.sgm&images=images/modeng&data=/texts/english/modeng/parsed&tag=public&part=all  \n","")
	text.gsub!("Saylor URL: http://www.saylor.org/courses/engl405/ \n","")
	text.gsub!(" Saylor.org \n","")
	text.gsub!("This work is in the public domain.  ","")
	text.gsub!(/Page (\d|\d\d|\d\d\d) of \d\d\d/, "")
	text.gsub!(/\n\n/,"\n")
	text.gsub!(/\n \n \n/,"")
	text.gsub!(/CHAPTER [A-Z]{1,7}(\s\n|\s\s\n)/,"")
	text.gsub!(/\n-\d{1,3}-\s/,"")
	#text.gsub!("   ","\n")
	#text.gsub!("   ","</paragraph>\n<paragraph>\n")
	text.gsub!("Uncle Tom’s Cabin","")
	text.gsub!("Harriet Beecher Stowe (1852) \n \nIn Which the Reader Is Introduced to a Man of Humanity", "<document title='Uncle Tom’s Cabin' author='Harriet Beecher Stowe' date='1852'>\n<chapter id='1' title='In Which the Reader Is Introduced to a Man of Humanity'>\n")
	text = "<?xml version='1.0' encoding='UTF-8'?>" + text + "</chapter></document>"
	
	#including first xml tag (<chapter>)
	#still just as string
	previous_line = ""
	chapter_id = 2
	text.each_line do |line|
		if previous_line.include?("Chapter ")			
			title= ""
			title += line.to_s
			title.gsub!("'","")
			title = title.gsub!(" \n","")
			newline = "</chapter>" + "\n"+"<chapter id='" + chapter_id.to_s + "' title='"+title+"'>\n"  
			text.gsub!(previous_line, newline)
 			text.gsub!(line, "")
			chapter_id = chapter_id +1  		
		end
		previous_line = line
		
	end

	#including xml tag (<paragraph>)
	#still just as string
	previous_line = ""
	para_id = 1
        text.each_line do |line|
		#including <paragraph> tags
		#those will be deleted later since the parser just needs a paragraph per line output, but to achieve that, the <paragraph> tags are needed.
		#also if needed the <paragraph> tags are available this way
		if (line.include?("   ") && previous_line.include?("<chapter") )
			newline = "<paragraph id='" + para_id.to_s + "'>" + line
			text.gsub!(line,newline)
			para_id = para_id + 1 
		end
		if (line.include?("   ") && !previous_line.include?("<chapter") )
			newline = "</paragraph>\n<paragraph id='" + para_id.to_s + "'>" + line
                        text.gsub!(line,newline)
			para_id += 1 		
		end
		
	previous_line = line
	end
	text.gsub!(" \n</chapter>","\n</paragraph>\n</chapter>")

	#clearing some last textjunk
	text.gsub!("  \n"," ")
	text.gsub!(" \n"," ")
	text.gsub!("-\n","-")
	text.gsub!("   ","")

	#the following three lines delete the paragraph tags from the xml markup
	#after deleting the tags each line in <chapters> holds one paragraph 
	text.gsub!(/\Wparagraph id=\W\d{1,}\W\W/,"")
	text.gsub!(/\W\Wparagraph\W\W/,"\n")
	text.gsub!("\n\n","\n") 
	puts "Text cleared, xml markup done [#{Time.now.round(3) - beginningTime.round(3)} sec]"

	#save altered_text to xml file 
	File.open($file[0..-5]+"_zwischen.xml", 'w') do |file|
		#file.puts(doc.to_xml)
		file.puts(text)
	end
	puts "Xml file: "+$file[0..-5]+"_zwischen.xml saved \nall done! [#{Time.now.round(3) - beginningTime.round(3)} sec]"
	
	#additionaly save a txt file for each chapter 
	#doc = Nokogiri::XML(text)
	#chapternumber = 1
	#doc.search('//document//chapter').each do |chapter|
        #        File.open("chapter"+chapternumber.to_s+".txt" , 'w') do |file|
        #               file.puts(chapter.content)
        #        end
        #        chapternumber = chapternumber + 1
        #end
        
end
	


