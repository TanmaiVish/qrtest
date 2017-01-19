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

quirc/libquirc.so.1.0:
	cd quirc && \
		make libquirc.so
	mv quirc/libquirc.so.1.0 quirc/libquirc.so

qrtest: qrtest.c quirc/libquirc.so.1.0
	gcc -Wall -o qrtest qrtest.c process-zbar.c \
		-L `pwd` -Wl,-rpath=`pwd` -ldata \
		-L './quirc' -Wl,-rpath=./quirc -lquirc \
		-lzbar
