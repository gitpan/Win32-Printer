#------------------------------------------------------------------------------#
#  Win32::Printer Maker                                                        #
#  Edgars Binans <admin@was.net>                                               #
#------------------------------------------------------------------------------#

use 5.008;
use ExtUtils::MakeMaker;

WriteMakefile(
  'NAME'		=> 'Win32::Printer',
  'VERSION_FROM'	=> 'Printer.pm',
  'ABSTRACT_FROM'	=> 'Printer.pm',
  'AUTHOR'		=> 'Edgars Binans <admin@wasx.net>',
);
