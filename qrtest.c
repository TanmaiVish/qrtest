#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/time.h>

#include "process-zbar.h"
#include "process-quirc.h"

#include "data.h"

struct timeval time_start;
struct timeval time_stop;

void start(void)
{
	printf("--------------\n");
	gettimeofday(&time_start, NULL);
}

void stop(char num)
{
	unsigned long us;

	gettimeofday(&time_stop, NULL);

	us = ((time_stop.tv_usec > time_start.tv_usec) ?
		time_stop.tv_usec - time_start.tv_usec :
		time_start.tv_usec - time_stop.tv_usec);

	printf("[ %02d ] %lu s %lu us\n", num,
		time_stop.tv_sec - time_start.tv_sec, us);
}


#define LOOPS 50
unsigned long *times_quirk;
unsigned long *times_zbar;


int main(void)
{
	const unsigned char *barcode_p = get_barcode();
	const unsigned char *test_image_p = get_test_image();
	unsigned long barcode_l = get_barcode_length();
	unsigned long test_image_l = get_test_image_length();
	int i;

	printf("barcode length: %lu\n", barcode_l);
	printf("test image length: %lu\n", test_image_l);

	for (i=0; i<LOOPS; i++) {

		start();
		process_quirc(barcode_p);
		stop(0);

		start();
		process_zbar(barcode_p);
		stop(1);

	}

}

