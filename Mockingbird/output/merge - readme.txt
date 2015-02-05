merge.rb its ein Ruby script, zum zusammenfügen der geparsten chapter (chapterxx.xml) in die fertige XML Datei.

Vorraussetzungen:

1.	Ruby in der Verion 1.9.2 oder 1.9.3

	Auf Windows:
	http://rubyinstaller.org/
	Linux:
	https://rvm.io/rvm/install
	
2.	Ruby Gems sind notwendig um die zusätzlich verwendedetn Bibliotheken zu laden (gems)
	
	Falls nicht in der Ruby Verion vorhanden:
	
	Linux:
	https://rubygems.org/pages/download

	Windows:
	Ruby gems sind im Paket des Ruby installers vorhanden und werden mit installiert.
	https://rubygems.org/pages/download

3.	Die zusätzlich verwendeten Bibliotheken(gems)
	
	-- Nokogiri --
	wird durch das script selbst installiert falls noch nicht voranden

	Weitere Informationen:
	http://www.nokogiri.org/tutorials/installing_nokogiri.html

-------- Verwendung ---------

1. In der console in den Ordner des scripts navigieren
2. Script ausführen mit:

	ruby merge.rb -f "Dateiname" -d "Pfadangabe"

Das Script benötigt die Argumente "-f" gefolgt von dem Dateinamen der XML-Datei in welche die chapters eingefuegt werden sollen
In unserem Fall die "buchtitel_zwischen.xml" Dateien

Außerdem benötigt das Script die Argumente -d "Pfadangabe" 
Die Pfadangabe bezieht sich hier auf den Ordner indem die geparsten xml-Dateien liegen
In unserem Fall "../dh-Projekt-Gruppe1/Buchtitel/output/chapters/annotated/"

Das Script erstellt dann aus den einzelnen Kapiteln und der zwischen.xml im selben Ordner die fertige XML-Datei 








