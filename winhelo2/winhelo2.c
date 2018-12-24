#include "apilib.h"
/*
int api_openwin(char *buf, int xsiz, int ysiz, int col_inv, char *title);
void api_putstrwin(int win, int x, int y, int col, int len, char *str);
void api_boxfilwin(int win, int x0, int y0, int x1, int y1, int col);
void api_end(void);
*/

void HariMain(void)
{
	int win;
	char buf[150 * 50];
	win = api_openwin(buf, 150, 50, -1, "hello");
	api_boxfilwin(win,  8, 36, 141, 43, 3 /* â© */);
	api_putstrwin(win, 28, 28, 0 /* çï */, 12, "hello, world");
	for ( ; ; ) {
		if ( api_getkey( 1 ) == 0x0a ) {
			break;
		}
	}
	api_end();
}
