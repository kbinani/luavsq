all: luavsq.lua

luavsq.lua: ../*.lua SourceFilePacker.class
	java SourceFilePacker
	luac -s -o luavsq.luac luavsq.lua

SourceFilePacker.class: SourceFilePacker.java
	javac SourceFilePacker.java -encoding UTF8

doc: ../*.lua
	cd ../ && luadoc --doclet luadoc.doclet.java --taglet luadoc.taglet.custom -d ./doc --no-private --nomodules *.lua

clean:
	rm luavsq.lua
	rm luavsq.luac
	rm SourceFilePacker.class
