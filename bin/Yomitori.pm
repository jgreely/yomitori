package Yomitori;

require 5.10.1;
use strict;
use warnings;
use FindBin qw($RealBin);

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(
	readconfig
	%YT
	$YTREGEXP
	InKana
	InFWAN
	allkana
	kata2hira
	hira2kata
	parsemeta
	makemeta
);
use vars qw($VERSION);
our $VERSION = '1.00';

use Data::Dumper;
$Data::Dumper::Indent = 0;
$Data::Dumper::Useqq = 1;
$Data::Dumper::Terse = 1;
{ no warnings 'redefine';
    sub Data::Dumper::qquote {
        my $s = shift;
        return "'$s'";
    }
}

my $DEBUG = 0;
our %YT;
our $YTREGEXP = '(\{[^{}]*\})';

my %metakeys = qw(
	G gloss
	D dictform
	R dictreading
	I id
);

sub readconfig {
	my $HOME = $ENV{HOME};
	if (! -f "$HOME/.ytrc") {
		my $PREFIX = "/usr/local";
		%YT = (
			unidic => "$PREFIX/lib/mecab/dic/unidic",
			dict_index => "$PREFIX/libexec/mecab/mecab-dict-index",
			dviasm => "$PREFIX/texlive/2013/texmf-dist/scripts/dviasm/dviasm.py",
			basedir => ".",
			libdir => "lib",
			bindir => "bin",
			tmpdir => "/tmp",
			knownwords => "known.txt,known-user.txt",
			glosswords => "gloss.txt,gloss-user.txt",
			userdict => "userdict.txt",
		);
	}else{
		open(In,"$HOME/.ytrc") or die "$0: $HOME/.ytrc: $!\n";
		while (<In>) {
			next if /^\s*$|^\s*#/;
			chomp;
			my ($key,$value) = /^(\S+)\s*=\s*(.*)$/;
			$YT{$key} = $value;
		}
		close(In);
	}
	foreach (qw(libdir bindir tmpdir)) {
		$YT{$_} = $YT{basedir} . "/" . $YT{$_}
			unless substr($YT{$_},0,1) eq "/";
	}
	# make sure everything exists...
	foreach (qw(unidic dict_index dviasm libdir bindir tmpdir)) {
		die "$0: $YT{$_}: $!\n" unless -r $YT{$_};
	}
}

sub allkana {
	return $_[0] =~ /^\p{InKana}+$/;
}

#character class for regexp
sub InKana {
	return <<END;
3040\t309F
30A0\t30FF
END
}

#character class for full-width alphanum
sub InFWAN {
	return <<END;
FF10\tFF19
FF21\tFF3A
FF41\tFF5A
END
}

#TODO: convert katakana "ー" to correct hiragana vowel
sub kata2hira {
	my $result;
	foreach my $char (split(//,$_[0])) {
		if ($char =~ /^\p{InKataKana}+$/ and ord($char) != 0x30fc) {
			$result .= chr(ord($char)-96);
		}else{
			$result .= $char;
		}
	}
	return $result;
}

sub hira2kata {
	my $result;
	foreach my $char (split(//,$_[0])) {
		if ($char =~ /^\p{InHiraGana}$/) {
			$result .= chr(ord($char)+96);
		}else{
			$result .= $char;
		}
	}
	return $result;
}

sub parsemeta {
	my ($meta) = @_;
	$meta =~ tr/{}//d;
	my $result = {
		id => "",
		word => "",
		reading => "",
		dictform => "",
		dictreading => "",
		gloss => "",
	};
	my $reading;
	my ($tmp,$rest) = split(/ /,$meta,2);
	($result->{word},$result->{reading}) = split(/\|/,$tmp,2);
	$result->{reading} = "" unless defined $result->{reading};
	while (defined($rest) and $rest ne "") {
		$rest =~ s/^ //;
		$rest =~ s/^([DGIR])=(\S+)//;
		my ($key,$val) = ($1,$2);
		if ($key eq "G" and $rest ne "") {
			# only G can contain whitespace or "="
			$val .= $rest;
			$rest = "";
		}
		$result->{$metakeys{$key}} = $val;
	}
	$result->{reading} = $result->{word} unless $result->{reading};
	return $result;
}

#new inline metadata format:
#	{base|reading I=... K=... R=... G=...}
# G is the only field that can contain whitespace or "=", so it must always
# be last if it appears.
#
sub makemeta {
	my ($word) = @_;
	my $result = "{";
	$result .= $word->{word} if $word->{word};
	$result .= "|" . $word->{reading} if $word->{reading}
		and kata2hira($word->{word}) ne kata2hira($word->{reading});
	$result .= " D=" . $word->{dictform} if $word->{dictform};
	$result .= " R=" . $word->{dictreading} if $word->{dictreading};
	if ($word->{id}) {
		if ($word->{id} =~ /^id/) {
			$result .= " I=" . $word->{id};
		}else{
			$result .= " I=" . sprintf("id%06d",$word->{id});
		}
	}
	$result .= " G=" . $word->{gloss} if $word->{gloss};
	return $result . "}";
}

1;
__END__
