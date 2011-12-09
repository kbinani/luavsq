all: luavsq.lua

luavsq.lua: ../*.lua SourceFilePacker.class
	java SourceFilePacker

SourceFilePacker.class: SourceFilePacker.java
	javac SourceFilePacker.java -encoding UTF8

doc: ../*.lua
	cd ../ && luadoc --doclet luadoc.doclet.java --taglet luadoc.taglet.java -d ./doc --no-private --nomodules *.lua

docall: ../*.lua
	cd ../ && luadoc --doclet luadoc.doclet.java --taglet luadoc.taglet.java -d ./doc --nomodules *.lua

clean:
	rm luavsq.lua
	rm SourceFilePacker.class
