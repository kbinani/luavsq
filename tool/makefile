all: luavsq.lua

luavsq.lua: ../*.lua SourceFilePacker.class
	java SourceFilePacker

SourceFilePacker.class: SourceFilePacker.java
	javac SourceFilePacker.java -encoding UTF8

doc: ../*.lua
	cd ../ && luadoc --doclet luadoc.doclet.java --taglet luadoc.taglet.java -d ./doc --no-private --nomodules *.lua

docall: ../*.lua
	cd ../ && luadoc --doclet luadoc.doclet.java --taglet luadoc.taglet.java -d ./doc --nomodules *.lua

release:
	$(MAKE) luavsq.lua
	$(MAKE) doc
	rm -rf ../release/document
	rm -f ../release/luavsq.lua
	cp -R ../doc ../release/document
	cp luavsq.lua ../release/
	rm -f ../release/luavsq.zip
	cd ../release/ && zip -r luavsq.zip *

clean:
	rm luavsq.lua
	rm SourceFilePacker.class
