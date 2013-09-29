@echo off

if exist "c:\Program Files\MeCab" (
	set mecab="c:\Program Files\MeCab"
) else if exist "c:\Program Files (x86)\MeCab" (
	set mecab="c:\Program Files (x86)\MeCab"
) else (
	echo Can't find MeCab; is it installed?
)
copy %mecab%\sdk\mecab.h \strawberry\c\include
copy %mecab%\bin\libmecab.dll \strawberry\perl\bin

cd \strawberry\perl\bin
pexports libmecab.dll > libmecab.def
dlltool -D libmecab.dll -l libmecab.a -d libmecab.def
move libmecab.a ..\..\c\lib
del libmecab.def

copy %mecab%\bin\mecab-dict-index.exe \strawberry\perl\bin

mkdir \yomitori\tmp
