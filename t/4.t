#------------------------------------------------------------------------------#
# Win32::Printer (EBar) test script                                            #
# Copyright (C) 2003 Edgars Binans <admin@wasx.net>                            #
#------------------------------------------------------------------------------#

use strict;
use warnings;
use Test::More;

use Win32::Printer;

if (Win32::Printer::_Get3PLibs() & 0x00000004) {
  plan tests => 1;
} else {
  plan skip_all => "Ebar is not built in!";
}

#------------------------------------------------------------------------------#

my $dc = new Win32::Printer( file => "t/tmp/test.prn" );

ok ( $dc->EBar('This is EBar barcode library test!') == 1, 'EBar()' );

$dc->Close();

#------------------------------------------------------------------------------#

unlink <t/tmp/*.*>;
