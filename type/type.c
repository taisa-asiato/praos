#include "apilib.h"
/*
int api_openwin(char *buf, int xsiz, int ysiz, int col_inv, char *title);
void api_initmalloc(void);
char *api_malloc(int size);
void api_refreshwin(int win, int x0, int y0, int x1, int y1);
void api_linewin(int win, int x0, int y0, int x1, int y1, int col);
int api_getkey(int mode);
void api_end(void);
*/
void HariMain(void)
{
	int fh;
	char c, cmdline[30], *p;

	api_cmdline( cmdline, 30 );
	for ( p = cmdline ; *p > ' ' ; p++ ) { /* スペースが来るまで読み飛ばす */ }
	for ( ; *p == ' ' ; p++ ) { /* スペースを読み飛ばす */ }

	fh = api_fopen( p );
	if ( fh != 0  ) {
		for ( ; ; ) {
			if ( api_fread( &c, 1, fh ) == 0 ) {
				break;
			}
			api_putchar( c );
		}
	} else {
		api_putstr0( "File Not Found\n" );
	}
	api_end();
}
