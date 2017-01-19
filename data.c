/* test data */
#include "testimage.h"
#include "barcode.h"

#include "data.h"

#include <stdio.h>

const unsigned char *get_barcode()
{
	printf("barcode length: %lu\n", sizeof(barcode));
	return barcode;
}

const unsigned char *get_test_image()
{
	printf("test image length: %lu\n", sizeof(test_image));
	return test_image;
}
