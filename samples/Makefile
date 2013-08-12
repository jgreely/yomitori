B=../bin

%:
	$B/ytgloss -u $@-userdict.txt $@.txt |\
	$B/ytknown -k $@-known.txt -g $@-gloss.txt > $@.yt
	$B/ytruby $@.yt | $B/yt2latex > $@.tex
	uplatex $@.tex > /dev/null
	$B/dvicleanruby $@.dvi
	dvipdfmx -q $@.dvi
	$B/ytvocab -t $@.aux -l $@.yt > $@-vocab.tex
	uplatex $@-vocab.tex > /dev/null
	dvipdfmx -q $@-vocab.dvi
	$B/ytruby $@.yt | $B/yt2odt -o $@.odt
	$B/ytruby $@.yt | $B/yt2word > $@.doc
	$B/yt2html $@.yt > $@.html

clean:
	@rm -f *.yt *.tex *.aux *.log *.dvi *.dvi* *.dump *~

realclean: clean
	@rm -f *.pdf *.odt *.doc *.html


