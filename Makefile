lib/dict.sqlite3: dictdata dictdata/JMdict dictdata/JMnedict.xml
	./bin/ytmakedict

dictdata:
	mkdir -p dictdata

dictdata/JMdict: dictdata
	curl http://ftp.monash.edu.au/pub/nihongo/JMdict.gz | gunzip > dictdata/JMdict

dictdata/JMnedict.xml: dictdata
	curl http://ftp.monash.edu.au/pub/nihongo/JMnedict.xml.gz | gunzip > dictdata/JMnedict.xml

