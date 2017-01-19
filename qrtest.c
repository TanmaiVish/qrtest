#include "quirc/lib/quirc.h"

/* test data */
#include "testimage.h"
#include "barcode.h"

int process_quirc(const unsigned char *img_array)
{
	struct quirc *qr;
	
	qr = quirc_new();
	if (!qr) {
	    perror("Failed to allocate memory");
	    abort();
	}

	if (quirc_resize(qr, 640, 480) < 0) {
	    perror("Failed to allocate video memory");
	    abort();
	}
	

	quirc_destroy(qr);
}

int main(void)
{
	const unsigned char *barcode_p = &barcode;
	const unsigned char *test_image_p = &test_image;
	unsigned long barcode_l;
	unsigned long test_image_l;

	barcode_l = sizeof(*barcode_p);
	printf("barcode length: %lu\n", barcode_l);
	test_image_l = sizeof(*test_image_p);
	printf("test_image length: %lu\n", test_image_l);

	process_quirc(barcode_p);
}

