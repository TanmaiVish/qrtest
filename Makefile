all: qrtest qr-decode

submodules:
	git submodule update --init --recursive

# convert images with imagemagik
testimage.h barcode.h:
	convert -define h:format=gray barcode.png barcode.h
	sed -i 's/static//' barcode.h
	sed -i 's/MagickImage/barcode/' barcode.h
	convert -define h:format=gray IMG_20170119_100308.jpg testimage.h
	sed -i 's/static//' testimage.h
	sed -i 's/MagickImage/test_image/' testimage.h

libdata.so: data.c data.h testimage.h barcode.h
	gcc -c -Wall -Werror -fpic data.c
	gcc -shared -o libdata.so data.o

quirc/libquirc.so: | submodules
	cd quirc && \
		make DQUIRC_MAX_REGIONS=65534 libquirc.so
	ln -s quirc/libquirc.so.1.0 quirc/libquirc.so

qrtest: qrtest.c quirc/libquirc.so process-zbar.c process-quirc.c libdata.so
	gcc -Wall -o qrtest qrtest.c process-zbar.c process-quirc.c \
		-L `pwd` -Wl,-rpath=`pwd` -ldata \
		-L './quirc' -Wl,-rpath=./quirc -lquirc \
		-lzbar

qr-decode: qr-decode.c process-zbar.c quirc/libquirc.so process-quirc.c
	gcc -Wall -o qr-decode qr-decode.c process-zbar.c process-quirc.c \
		-L './quirc' -Wl,-rpath=./quirc -lquirc \
		-lzbar \
		-lpng

accuracy-report.md: qr-decode
	./generate-test-images.lua 2> /dev/null | \
		./get_report.awk \
		> accuracy-report.md

clean:
	rm -fv qrtest \
	quirc/libquirc.so \
	libdata.so testimage.h barcode.h

run: qrtest
	./qrtest | ./get_avg.awk | tee out
