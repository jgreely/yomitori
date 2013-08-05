yomitori
========

Tools to generate custom student editions of Japanese texts.
Default output is Kindle-sized PDF files. This is very much
a work in progress, and no matter how messy it looks, trust
me that it's far better than the version I've been reading
novels with for the past two years.

Requirements
------------

* Perl 5.10.1+ with DBI, DBD::SQLite, Text::MeCab, XML::Twig
* [TeXLive 2013](http://www.tug.org/texlive/)
* [MeCab](https://code.google.com/p/mecab/)
* [Unidic](http://en.sourceforge.jp/projects/unidic/)
* dviasm.py (distributed with TeXLive)
* [JMdict and JMnedict](http://www.edrdg.org/)

Tools
-----

* ytmakedict: convert JMdict and JMnedict into a simple SQLite database
* ytgloss: add readings and English definitions to a UTF8-encoded text file
* ytknown: strip out definitions and readings for words the user knows
* ytruby: convert the embedded readings into proper furigana by stripping
  out leading, trailing, and interior kana
* yt2latex: format a document for processing with upLaTeX
* dvicleanruby: use dviasm.py to strip furigana that appear more than
  once per page.
* ytvocab: extract a vocabulary list from a document, incorporating
  page-number information from the upLaTeX .aux file.
* ytdegloss: strip all embedded readings and glosses from a file;
  useful for comparing versions of a document.
* Yomitori.pm: utility functions

Basic Usage
-----------

	ytmakedict
    ytgloss -u userdict.txt foo.txt |
        ytknown -k known.txt -g gloss.txt > foo.yt
    ytruby foo.yt | yt2latex > foo.tex
    uplatex foo.tex
    dvicleanruby foo.dvi
    dvipdfmx foo.dvi
    ytvocab -t foo.aux -l foo.yt > foo-vocab.tex
	uplatex foo-vocab.tex
	dvipdfmx foo-vocab.dvi

TODO
----

* document the config file and known/gloss/userdict files, with samples
* add yt2html with jquery-based glossing (clean up old code)
* add ab2yt to convert Aozora Bunko markup (clean up old code)
* add yt2odt (clean up old code)
* add yt2word (clean up old code)
* add additional paper sizes to yt2latex
* clean up ytmakedict code and output
* explain the tricky bits
