SHELL := /bin/bash
VOC = /opt/voc/bin/voc
LOC = http://www.georgianweb.com/pdf
SRC = lexicon.pdf
DST0 = lexicon.txt
DST1 = lexicon-utf8.txt
DST2 = eng-geo_lexicondict.tab
AGENT = 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4'

all: get totext makeConverter toUnicode fix mkTab maketab makedict

almost_all: get totext toUnicode fix maketab makedict


# if we don't use -U option to spoof the site then it does not return the file but returns 403 forbidden error.
get:
	wget  -U $(AGENT)  -c $(LOC)/$(SRC)

totext:
	pdftotext -layout $(SRC) $(DST0)

toUnicode:
	# converting to unicode
	./Std8ToUTF8 $(DST0) > $(DST1)

makeConverter:
	$(VOC) -M Std8ToUTF8.Mod

fix:
	###sed -i '/^$/d' $(DST1) #remove empty lines
	#dollar sign has to be doubled otherwise make interprets it as variable
	sed -i '/^$$/d' $(DST1) #remove empty lines
	sed -i '/^ /d' $(DST1) #lines starting from ' '
	#remove first line
	sed -i '1d' $(DST1)
	printf "$$(printf '\\x%02X' 44)" | dd of="$(DST1)" bs=1 seek=583155 count=1 conv=notrunc &> /dev/null #replace 0A with "," in USA line

mkTab:
	$(VOC) -M makeTab.Mod

maketab:
	# making tab file
	./makeTab $(DST1) > $(DST2)

makedict:
	stardict_tabfile $(DST2)
	mkdir -p eng-geo_lexicondict
	mv eng-geo_lexicondict.dict eng-geo_lexicondict.idx eng-geo_lexicondict.ifo eng-geo_lexicondict 

clean:
	rm *.o
	rm *.c
	rm $(DST0)
	rm $(DST1)
	rm $(DST2)
