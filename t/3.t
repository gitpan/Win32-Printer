#------------------------------------------------------------------------------#
# Win32::Printer (GhostScript) test script                                     #
# Copyright (C) 2003 Edgars Binans <admin@wasx.net>                            #
#------------------------------------------------------------------------------#

use Test::Simple tests => 5;

use strict;
use warnings;

use Win32::Printer;

#------------------------------------------------------------------------------#

my $dc = new Win32::Printer( file => "t\\tmp\\test.pdf", pdf => 1 );

ok ( $dc->Abort() == 1, 'Abort()' );
ok ( $dc->Start("Test 1") == 1, 'Start()' );
ok ( $dc->Next("Test 2") == 1, 'Next()' );
ok ( $dc->End() == 1, 'End()' );
ok ( $dc->Close() == 1, 'Close()' );

#------------------------------------------------------------------------------#

unlink <t\\tmp\\*.*>;
