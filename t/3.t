#------------------------------------------------------------------------------#
# Win32::Printer (GhostScript) test script                                     #
# Copyright (C) 2003 Edgars Binans <admin@wasx.net>                            #
#------------------------------------------------------------------------------#

use strict;
use warnings;
use Test::More;

use Win32::Printer;

if (Win32::Printer::_Get3PLibs() & 0x00000002) {
  plan tests => 5;
} else {
  plan skip_all => "Ghostscript is not built in!";
}

#------------------------------------------------------------------------------#

my $dc = new Win32::Printer( file => "t/tmp/test.pdf", pdf => 0 );

ok ( defined($dc->Abort()), 'Abort()' );
ok ( $dc->Start("Test 1") == 1, 'Start()' );
ok ( $dc->Next("Test 2") == 1, 'Next()' );
ok ( defined($dc->End()), 'End()' );
ok ( defined($dc->Close()), 'Close()' );

#------------------------------------------------------------------------------#

unlink <t/tmp/*.*>;
