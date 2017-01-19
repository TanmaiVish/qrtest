# convert images with imagemagik
images:
	convert -define h:format=gray barcode.png barcode.h
	sed -i 's/static//' barcode.h
	sed -i 's/MagickImage/barcode/' barcode.h
	convert -define h:format=gray IMG_20170119_100308.jpg testimage.h
	sed -i 's/static//' testimage.h
	sed -i 's/MagickImage/test_image/' testimage.h

libdata.so: data.c data.h
	gcc -c -Wall -Werror -fpic data.c
	gcc -shared -o libdata.so data.o

qrtest: qrtest.c
	gcc -Wall -o qrtest qrtest.c -L `pwd` -Wl,-rpath=`pwd` -ldata
