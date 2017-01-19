#include <stdlib.h>
#include <stdio.h>

#include "quirc/lib/quirc.h"

#include "data.h"

/*
int process_quirc(const unsigned char *img_array)
{
	struct quirc *qr;
	
	qr = quirc_new();
	if (!qr) {
		printf("Error\n");
		exit(1);
	}

	if (quirc_resize(qr, 640, 480) < 0) {
		printf("Error\n");
		exit(1);
	}
	

	quirc_destroy(qr);
}
*/

int main(void)
{
	const unsigned char *barcode_p = get_barcode();
	const unsigned char *test_image_p = get_test_image();
	unsigned long barcode_l = get_barcode_length();
	unsigned long test_image_l = get_test_image_length();

	printf("barcode length: %lu\n", barcode_l);
	printf("test_image length: %lu\n", test_image_l);

	//process_quirc(barcode_p);
}

