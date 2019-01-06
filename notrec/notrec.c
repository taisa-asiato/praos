#include "apilib.h"
/*
int api_openwin(char *buf, int xsiz, int ysiz, int col_inv, char *title);
void api_boxfilwin(int win, int x0, int y0, int x1, int y1, int col);
void api_initmalloc(void);
char *api_malloc(int size);
void api_point(int win, int x, int y, int col);
void api_end(void);
*/

void HariMain(void)
{
	int win;
	char buf[150*70];
	win = api_openwin( buf, 150, 70, 255, "notrec" );
	api_boxfilwin( win, 0, 50, 34, 69, 255 );
	api_boxfilwin( win, 115, 50, 149, 69, 255 );
	api_boxfilwin( win, 50, 30, 99, 49, 255 );
	for ( ; ; ) {
		if ( api_getkey( 1 ) == 0x0a ) {
			break; /* ENTER‚ª‰Ÿ‚³‚ê‚½‚çbreak */
		}
	}
	api_end();
}
