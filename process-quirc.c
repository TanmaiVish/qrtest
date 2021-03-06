#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "quirc/lib/quirc.h"

int process_quirc(const unsigned char *img_array, int width, int height)
{
	struct quirc *qr;
	uint8_t *image;
	int w, h, num_codes, i;

	qr = quirc_new();
	if (!qr) {
		printf("Error\n");
		exit(1);
	}

	if (quirc_resize(qr, width, height) < 0) {
		printf("Error\n");
		exit(1);
	}

	image = quirc_begin(qr, &w, &h);
	memcpy(image, img_array, w*h);
	quirc_end(qr);

	num_codes = quirc_count(qr);
#if 0
	printf("quirc: number of QR codes: %d\n", num_codes);
#endif
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
			printf("quirc %s\n", data.payload);
	}

	quirc_destroy(qr);

	return num_codes;
}
