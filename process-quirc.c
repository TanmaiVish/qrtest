#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "quirc/lib/quirc.h"

int process_quirc(const unsigned char *img_array)
{
	struct quirc *qr;
	uint8_t *image;
	int w, h, num_codes, i;

	//stop();

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

	//stop();

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

	//stop();

	quirc_destroy(qr);

	return num_codes;
}
