#include "apilib.h"

struct DLL_STRPICENV { /* 64KB */
	int work[64*1024/4];
};

struct RGB {
	unsigned char b, g, r, t;
};

/* bmp.nasm */
int info_BMP( struct DLL_STRPICENV * env, int * info, int size, char * fp );
int decode0_BMP( struct DLL_STRPICENV * env, int size, char * fp, int b_type, char * buf, int skip );

/* jpeg.c */
int info_JPEG( struct DLL_STRPICENV * env, int * info, int size, char * fp );
int decode0_JPEG( struct DLL_STRPICENV * env, int size, char *fp, int b_type, char * buf, int skip );

unsigned char rgb2pal( int r, int g, int b, int x, int y );
void error( char * s );

void HariMain()
{
	struct DLL_STRPICENV env;
	char filebuf[512*1024], winbuf[1024*805];
	char s[32], *p;
	int win, i, j, fsize, xsize, info[8];
	struct RGB picbuf[1024*768], *q;


	/* $B%3%^%s%I%i%$%s2r@O(B */
	api_cmdline( s, 30 );
	for ( p = s ; *p > ' ' ; p++ ) { } // $B%9%Z!<%9$,Mh$k$^$GFI$_$H%P%9(B
	for ( ; *p == ' ' ; p++ ) {} //$B!!%9%Z!<%9$rFI$_Ht$P$9(B

	/* $B%U%!%$%kFI$_9~$_(B */
	i = api_fopen( p ); if ( i == 0 ) { error( "file not found\n" ); }
	fsize = api_fsize( i, 0 );
	if ( fsize > 512*1024 ) {
		error( "file too large\n" );
	}
	api_fread( filebuf, fsize, i );
	api_fclose( i );

	/* $B%U%!%$%k%?%$%W%A%'%C%/(B */
	if ( info_BMP( &env, info, fsize, filebuf ) == 0 ) {
		/* BMP$B$G$O$J$+$C$?(B */
		if ( info_JPEG( &env, info, fsize, filebuf ) == 0 ) {
			/* JPEG$B$G$b$J$+$C$?(B */
			api_putstr0( "file type unknow\n" );
			api_end();
		}
	}

	/* $B$I$A$i$+$N(Binfo$B4X?t$,@.8y$9$k$H(B, $B0J2<$N>pJs$,(Binfo$B$KF~$k(B */
	// info[0] : $B%U%!%$%k%?%$%W(B
	// info[1] : $B%+%i!<>pJs(B
	// info[2] : xsize
	// info[3] : ysize
	
	if ( info[2] > 1024 || info[3] > 768 ) {
		error( "picture too large\n" );
	}

	/* $B%&%#%s%I%&$N=`Hw(B */
	xsize = info[2] + 16;
	if ( xsize < 136 ) {
		xsize = 136;
	}
	win = api_openwin( winbuf, xsize, info[3]+37, -1, "gview" );

	/* $B%U%!%$%kFbMF$r2hA|%G!<%?$KJQ49(B */
	if ( info[0] == 1 ) {
		i = decode0_BMP( &env, fsize, filebuf, 4, ( char *)picbuf, 0 );
	} else {
		i = decode0_JPEG( &env, fsize, filebuf, 4, ( char *)picbuf, 0 );
	}

	/* b_type = 4 $B$O(Bsturct RGB */
	/* skip$B$O(B0 $B$K$7$F$*$/(B */
	if ( i != 0 ) {
		error( "decode error\n" );
	} 

	/* $BI=<((B */
	for ( i = 0 ; i < info[3] ; i++ ) {
		p = winbuf + ( i + 29 ) * xsize + ( xsize - info[2] ) / 2;
		q = picbuf + i * info[2];
		for ( j = 0 ; j < info[2] ; j++ ) {
			p[j] = rgb2pal( q[j].r, q[j].g, q[j].b, j, i );
		}
	}
	api_refreshwin( win, ( xsize - info[2] )/2, 29, ( xsize - info[2] )/2 + info[2], 29 + info[3] );

	/* $B=*N;BT$A(B */
	for ( ; ; ) {
		i = api_getkey( 1 );
		if ( i == 'Q' || i == 'q' ) {
			api_end();
		}
	}
}

unsigned char rgb2pal( int r, int g, int b, int x, int y ) 
{
	static int table[4] = { 3, 1, 0, 2 };
	int i;

	x &= 1; /* $B6v?t$+4q?t$+(B */
	y &= 1;
	i = table[x+y*2];
	r = ( r * 21 ) / 256;
	g = ( g * 21 ) / 256;
	b = ( b * 21 ) / 256;

	r = ( r + i ) / 4;
	g = ( g + i ) / 4;
	b = ( b + i ) / 4;
	return 16 + r + g * 6 + b * 36;
}

void error( char * s ) 
{
	api_putstr0( s );
	api_end();
}
