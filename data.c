/* test data */
#include "testimage.h"
#include "barcode.h"

#include "data.h"

#include <stdio.h>

const unsigned char *get_barcode()
{
	return barcode;
}

unsigned long get_barcode_length()
{
	return sizeof(barcode);
}

const unsigned char *get_test_image()
{
	return test_image;
}

unsigned long get_test_image_length()
{
	return sizeof(test_image);
}
