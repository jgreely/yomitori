Installing on Windows
=====================

(tested on Windows 7 64-bit)

For simplicity, windows-setup.bat and the built-in config in
bin\Yomitori.pm assume that this distribution has been unpacked
into c:\yomitori; anything without a space in the name should
work, but you'll have to make some adjustments.

Strawberry Perl
---------------
* must use 32-bit MSI to link to libmecab
* should install into the standard c:\strawberry
* already includes DBI, DBD::Sqlite, Archive::Zip

MeCab
-----
* standard windows installer
* select UTF-8 during install

XML::Twig
---------
* run "cpanm XML::Twig"

Text::Mecab
-----------
* run "windows-setup.bat", which copies the library and includes
  needed for Strawberry Perl to compile the module. It also copies
  mecab-dict-index.exe to a known location.
* run "cpanm --interactive Text::Mecab" and give it these arguments:
	version: 0.996
	compiler flags: -DWIN32
	linker flags: -lmecab
	include path: 
	encoding: utf-8

Unidic
------
* use unidic-mecab-2.1.2_bin.zip
* extract as \yomitori\unidic
* The Windows installer doesn't display correctly on 
  non-Japanese Windows, and installs a smaller dictionary,
  so skip it

TexLive2013
-----------
* unzip, right-click install-tl-advanced.bat to run as admin
* I assume the standard installation directory of c:\texlive
* can do a fairly small install; just make sure that you select
  the Chinese/Japanese/Korean package to get upTex and fonts.

GitHub
------
* optional, but easiest way to install Git and a decent shell, if
  you want to keep your copy of the code up-to-date.
* by default, distribution would end up in ...\Documents\GitHub\yomitori,
  which won't work with my config.

Notepad++
---------
(if you don't have an editor that handles kanji, UTF8, and LF line endings)

* install without plugins if you're not using it for coding, and then
  change a lot of defaults to make it more useful for kanji.

	Plugins->DSpellCheck->Spell Check Document Automatically (disable)
	view->Word wrap (enable)
	Edit->EOL Conversion->UNIX/OSX Format
	Encoding->Encode in UTF-8 without BOM
	Settings->Preferences->New Document->Format->Unix/OSX
	Settings->Preferences->New Document->Encoding->UTF-8 without BOM
	Settings->Style Configurator->Font Style->Font Name->Meiryo
	Settings->Style Configurator->Font Style->Font size->14
	Settings->Style Configurator->Enable global font
	Settings->Style Configurator->Enable global font size
