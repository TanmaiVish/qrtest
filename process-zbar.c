#include <stdlib.h>
#include <zbar.h>
#include <stdio.h>

zbar_image_scanner_t *scanner = NULL;

#define zbar_fourcc(a, b, c, d)                 \
        ((unsigned long)(a) |                   \
         ((unsigned long)(b) << 8) |            \
         ((unsigned long)(c) << 16) |           \
         ((unsigned long)(d) << 24))

int process_zbar(const unsigned char *img_array)
{
	//printf("DOING ZBAR\n");
	printf("zbar: ");

	/* create a reader */
	scanner = zbar_image_scanner_create();

	/* configure the reader */
	zbar_image_scanner_set_config(scanner, 0, ZBAR_CFG_ENABLE, 1);

	/* obtain image data */
	int width = 4048, height = 3036;

	/* wrap image data */
	zbar_image_t *image = zbar_image_create();
	zbar_image_set_format(image, zbar_fourcc('Y','8','0','0'));
	zbar_image_set_size(image, width, height);
	zbar_image_set_data(image, img_array, width * height, zbar_image_free_data);

	/* scan the image for barcodes */
	int n = zbar_scan_image(scanner, image);

	/* extract results */
	const zbar_symbol_t *symbol = zbar_image_first_symbol(image);
	for(; symbol; symbol = zbar_symbol_next(symbol)) {
		/* do something useful with results */
		zbar_symbol_type_t typ = zbar_symbol_get_type(symbol);
		const char *data = zbar_symbol_get_data(symbol);
		printf("decoded %s symbol \"%s\"\n",
			zbar_get_symbol_name(typ), data);
	}

	/* clean up */
	//zbar_image_destroy(image);
	//zbar_image_scanner_destroy(scanner);

	return n;
}
