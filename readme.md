English-Georgian dictionary
===========================

This is a way to legally prepare an English to Georgian stardict dictionary.
It downloads [this](http://www.georgianweb.com/pdf/lexicon.pdf) pdf, converts it to text, converts text to UTF-8, applies fixes, and converts to tab format.

Requirements
============

* poppler - it contains pdftotext utility
* sed - to make some fixes, like remove empty lines
* voc (vishap oberon compiler) - optional, we provide statically compiled binaries for x86_64 so you don't need to compile those programs that convert Std8 Georgian encoding to UTF-8 and prepare tab file.

How to run
==========

type 
	make almost_all
if you are on x86_64 GNU/Linux machine

or

	make
if you want to compile those programs yourself.

How to use dictionary
=====================

Copy resulting eng-geo_lexicondict directory to /home/.stardict/dic directory.
If you use different dictionary, then put it to corresponding path.

For n900's maemo mstardict it's /home/user/MyDocs/mstardict

For Sidudict (Sailfish) it's in /home/nemo/.local/share/harbour-sidudict/

