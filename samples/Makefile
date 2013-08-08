B=../bin

%:
	$B/ytgloss -u $@-userdict.txt -u $@-userdict.csv $@.txt |\
	$B/ytknown -k $@-known.txt -g $@-gloss.txt > $@.yt
	$B/ytruby $@.yt | $B/yt2latex > $@.tex
	uplatex $@.tex > /dev/null
	$B/dvicleanruby $@.dvi
	dvipdfmx -q $@.dvi
	$B/ytvocab -t $@.aux -l $@.yt > $@-vocab.tex
	uplatex $@-vocab.tex > /dev/null
	dvipdfmx -q $@-vocab.dvi

clean:
	@rm -f *.yt *.tex *.aux *.log *.dvi *.dvi* *.dump *~

reallyclean: clean
	@rm *.pdf
