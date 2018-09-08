int api_openwin( char * buf, int xsize, int ysize, int col_inv, char * title );
void api_putstr0( char * s );
void api_end( void );

char buf[ 150 * 50 ];

void HariMain( void )
{
	int win;
	api_putstr0( "Window Open Applicaion\n" );
	win = api_openwin( buf, 150, 50, -1, "hello" );
	api_end();
}
