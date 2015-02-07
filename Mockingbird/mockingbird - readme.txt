mockingbird.rb its ein Ruby script, welches aus der PDF Datei die buchtitel_zwischen.xml Datei erstellt.
Die buchtitel_zwischen.xml Datei entspricht im Aufbau schon der Endausgabe. 
Allerdings ist der inhalt der Kapitel noch nicht geparst


Vorraussetzungen: 
Momentan kann nur die Lauffähigkeit unter Linux garantiert werden!
Bei Testläufen mit Windows 7 hat sich gezeigt, dass die benötigte gem-library 'yomu' trotz Windows kompatibilität
unter bestimmten Umständen Probleme macht.
Daran wird noch gearbeitet, aber vorläufig kann aus diesem Grund keine Windows kompatibilität garantiert werden.

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
	wird durch das script selbst installiert falls noch nicht vorhanden

	Weitere Informationen:
	http://www.nokogiri.org/tutorials/installing_nokogiri.html

	-- yomu --
	wird durch das script selbst installiert falls noch nicht vorhanden

	Weitere Informationen:
	https://github.com/Erol/yomu


-------- Verwendung ---------

1. In der console in den Ordner des scripts navigieren
2. Script ausführen mit:

	ruby mockingbird.rb

Das Script benötigt die Argumente "-f" gefolgt von dem Dateinamen der Ausgangs-Datei (To_Kill_ a_ Mockingbird.pdf).
Sollte sich die Datei nicht im selben Ordner befinden, muss dem Dateinamen der Pfad voran gestellt werden.
Diese wird geöffnet, bereinigt und in das Ausgabeformat gebracht.
Das script speichert dann das Ergebnis in der Datei "mockingbird_zwischen.xml" im selben Ordner.




