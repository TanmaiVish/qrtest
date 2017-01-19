#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "quirc/lib/quirc.h"

#include "data.h"

int process_quirc(const unsigned char *img_array)
{
	struct quirc *qr;
	uint8_t *image;
	int w, h;
	
	qr = quirc_new();
	if (!qr) {
		printf("Error\n");
		exit(1);
	}

	if (quirc_resize(qr, 4048, 3036) < 0) {
		printf("Error\n");
		exit(1);
	}
	
	image = quirc_begin(qr, &w, &h);
	memcpy(image, img_array, w*h);
	quirc_end(qr);

	printf("quirc: number of QR codes: %d\n", quirc_count(qr));

	quirc_destroy(qr);
}

int main(void)
{
	const unsigned char *barcode_p = get_barcode();
	const unsigned char *test_image_p = get_test_image();
	unsigned long barcode_l = get_barcode_length();
	unsigned long test_image_l = get_test_image_length();

	printf("barcode length: %lu\n", barcode_l);
	printf("test image length: %lu\n", test_image_l);

	process_quirc(barcode_p);
	process_quirc(test_image_p);
}

