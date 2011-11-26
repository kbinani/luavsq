all: GetSaveFileName.dll

GetSaveFileName.dll: GetSaveFileName.c
	gcc GetSaveFileName.c -shared -o GetSaveFileName.dll -llua51 -lcomdlg32

clean:
	rm GetSaveFileName.dll
