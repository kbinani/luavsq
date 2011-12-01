all: luavsq.lua

luavsq.lua: ../*.lua SourceFilePacker.class
	java SourceFilePacker

SourceFilePacker.class: SourceFilePacker.java
	javac SourceFilePacker.java -encoding UTF8

doc: ../*.lua
	cd ../ && luadoc -d ./doc --nomodules *.lua

clean:
	rm luavsq.lua
	rm SourceFilePacker.class
