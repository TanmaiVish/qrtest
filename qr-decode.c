#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/time.h>

#include "process-zbar.h"
#include "process-quirc.h"

struct timeval time_start;
struct timeval time_stop;

void start(void)
{
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

int get_png_data()
{

}

int main(int argc, char *argv[])
{
	start();
	process_quirc();
	stop(0);

	start();
	process_zbar();
	stop(1);
}
