all: GetOpenFileName.dll

GetOpenFileName.dll: GetOpenFileName.c
	gcc GetOpenFileName.c -shared -o GetOpenFileName.dll -llua51 -lcomdlg32

clean:
	rm GetOpenFileName.dll
