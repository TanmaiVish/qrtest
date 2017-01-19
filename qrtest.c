#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "quirc/lib/quirc.h"

#include "data.h"

int process_quirc(const unsigned char *img_array)
{
	struct quirc *qr;
	uint8_t *image;
	int w, h, num_codes, i;
	
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

	num_codes = quirc_count(qr);
	printf("quirc: number of QR codes: %d\n", num_codes);

	for (i = 0; i < num_codes; i++) {
		struct quirc_code code;
		struct quirc_data data;
		quirc_decode_error_t err;

		quirc_extract(qr, i, &code);

		/* Decoding stage */
		err = quirc_decode(&code, &data);
		if (err)
			printf("DECODE FAILED: %s\n", quirc_strerror(err));
		else
			printf("Data: %s\n", data.payload);
	}

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

