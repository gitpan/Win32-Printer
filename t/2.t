#------------------------------------------------------------------------------#
# Win32::Printer (FreeImage) test script                                       #
# Copyright (C) 2003 Edgars Binans <admin@wasx.net>                            #
#------------------------------------------------------------------------------#

use Test::Simple tests => 3;

use strict;
use warnings;

use Win32::Printer;

#------------------------------------------------------------------------------#

my $dc = new Win32::Printer( file => "t\\tmp\\test.prn" );

my $bmp00 = $dc->Image('t/t.png');
ok ( $bmp00 != 0, 'Image() bmp' );
ok ( $dc->Image($bmp00, 5, 5, 2, 1) == $bmp00, 'Image() indirect' );
ok ( $dc->Close($bmp00) == 1, 'Close() Image indirect' );

#------------------------------------------------------------------------------#
