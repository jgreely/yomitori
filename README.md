yomitori
========

Tools to generate custom student editions of Japanese texts.
Default output is Kindle-sized PDF files, but HTML, Word, and
LibreOffice are also supported. This is very much a work in
progress, and no matter how messy it looks, trust me that it's
far better than the version I've been reading novels with for
the past two years.

Requirements
------------

* Perl 5.10.1+ with DBI, DBD::SQLite, Text::MeCab, XML::Twig, Archive::Zip
* [JMdict and JMnedict](http://www.edrdg.org/)
* [MeCab](https://code.google.com/p/mecab/)
* [Unidic](http://en.sourceforge.jp/projects/unidic/)
* [TeXLive 2013](http://www.tug.org/texlive/)
* [dviasm.py](http://www.ctan.org/tex-archive/dviware/dviasm)
  (distributed with TeXLive)
* [jQuery](http://jquery.com/), [jQueryUI](http://jqueryui.com/),
  and a [UI theme](http://jqueryui.com/themeroller/), if you don't
  want to just use Google-hosted versions.

Tools
-----

* ytmakedict: convert JMdict and JMnedict into a simple SQLite database
* ytgloss: add readings and English definitions to a UTF8-encoded text file
* ytknown: strip out definitions and readings for words the user knows
* ytruby: convert the embedded readings into proper furigana by stripping
  out leading, trailing, and interior kana
* yt2latex: format a document for processing with upLaTeX
* yt2odt: convert to LibreOffice/OpenOffice, with basic ruby support
* yt2word: convert to Word HTML, with vertical text and basic ruby support
* yt2html: convert to HTML with ruby tags and jQueryUI-based tooltips
* dvicleanruby: use dviasm.py to strip furigana that appear more than
  once per page.
* ytvocab: extract a vocabulary list from a document, optionally
  incorporating page-number information from the upLaTeX .aux file.
  Normal text output can be pasted into Word/LibreOffice and
  converted to a table.
* ytdegloss: strip all embedded readings and glosses from a file;
  useful for comparing versions of a document.
* Yomitori.pm: utility functions

Basic Usage
-----------

	kanji-config-updmap auto
	ytmakedict
    ytgloss -f fixparse.txt -g fixgloss.txt foo.txt |
        ytknown -k known.txt -g gloss.txt > foo.yt
    ytruby foo.yt | yt2latex > foo.tex
    uplatex foo.tex
    dvicleanruby foo.dvi
    dvipdfmx foo.dvi

    ytvocab -t foo.aux -l foo.yt > foo-vocab.tex
	uplatex foo-vocab.tex
	dvipdfmx foo-vocab.dvi

    ytruby foo.yt | yt2odt -o foo.odt
    ytruby foo.yt | yt2word > foo.doc
	yt2html foo.yt > foo.html

TODO
----

* document the config file and known/gloss/userdict files, with samples
* yt2html: use decent CSS styling
* yt2html: allow use of local/different jQuery/jQueryUI/theme (default 
  is Google CDN and Pepper Grinder theme)
* add ab2yt to convert Aozora Bunko markup (clean up old code)
* add additional paper sizes to yt2latex
* clean up ytmakedict code and output
* explain the tricky bits
* make ytgloss/ytknown preserve glossing for known word with variant kanji.
  Ex: Unidic reports 提げる as 下げる; JMdict glosses them differently,
  but since I lookup by dictform first, I merge them together; ditto for
  殺る as やる, 訊く as 聞く, etc. 高飛び gets the wrong gloss because
  of this, because Unidic normalizes to 高跳び.
* fix common false-positive in ytgloss: when looking up expressions by
  dictreading only, if they include a particle, make sure that the
  dictform of a successful lookup includes that particle as hiragana.
  That should not only handle cases like "kara neko" matching 唐猫,
  but also get rid of some code that prevents matching some expressions
  that include particles.
* ytgloss bug: should catch もしかすると as expression
* Unidic glitch: can't match いつの間にか because Unidic returns あいだ
  as the reading for 間; this is probably like getting た for 他 in
  too many contexts, sigh.
* Unidic glitch: 今日一日, returns ついたち instead of いちにち
* small tool to more easily override Unidic glitches; writing Perl
  one-liners to extract and modify the existing records gets old fast.
