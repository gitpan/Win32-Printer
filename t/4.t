#------------------------------------------------------------------------------#
# Win32::Printer (EBar) test script                                            #
# Copyright (C) 2003 Edgars Binans <admin@wasx.net>                            #
#------------------------------------------------------------------------------#

use strict;
use warnings;
use Test::More;

use Win32::Printer;

if (Win32::Printer::_Get3PLibs() & 0x00000004) {
  plan tests => 3;
} else {
  plan skip_all => "Ebar is not built in!";
}

#------------------------------------------------------------------------------#

my $dc = new Win32::Printer( file => "t/tmp/test.prn" );

my $bar = $dc->EBar('This is EBar barcode library test!');
ok ( $bar != 0, 'EBar()' );
ok ( $dc->Image($bar, 1, 1), 'Image()' );
ok ( $dc->Close($bar) == 1, 'Close($bar)' );
$dc->Close();

#------------------------------------------------------------------------------#

unlink <t/tmp/*.*>;
