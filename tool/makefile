all: luavsq.lua

luavsq.lua: ../*.lua ../test/*.lua SourceFilePacker.class
	java SourceFilePacker

SourceFilePacker.class: SourceFilePacker.java
	javac SourceFilePacker.java
