#------------------------------------------------------------------------------#
#  Win32::Printer Maker                                                        #
#  Edgars Binans <admin@was.net>                                               #
#------------------------------------------------------------------------------#

use strict;
use warnings;
use 5.008;
use ExtUtils::MakeMaker;
use Config;

my ($inc, $lib, $lin, $ccf) = ("", "", "", "");

print "Inlude FreeImage image support? [y]: ";
my $in = "y";
$in = <>;
if ($in !~ /n/) {
  $inc = '-I.\3PLibs\FreeImage ';
  $lib = '-l.\3PLibs\FreeImage\FreeImage.lib ';
  $lin = '-delayload:FreeImage.dll ';
  $ccf = '-DFREE ';
}

print "Inlude Ghostscript PDF support? [y]: ";
$in = "y";
$in = <>;
if ($in !~ /n/) {
  $inc .= '-I.\3PLibs\Ghostscript ';
  $lib .= '-l.\3PLibs\Ghostscript\gsdll32.lib ';
  $lin .= '-delayload:gsdll32.dll ';
  $ccf .= '-DGHOST ';
}

print "Inlude EBar barcode support? [y]: ";
$in = "y";
$in = <>;
if ($in !~ /n/) {
  $inc .= '-I.\3PLibs\EBar';
  $lib .= '-l.\3PLibs\EBar\EBar.lib';
  $lin .= '-delayload:EBar.dll';
  $ccf .= '-DEBAR';
}

WriteMakefile( 
  'NAME'		=> 'Win32::Printer',
  'VERSION_FROM'	=> 'Printer.pm',
  'ABSTRACT_FROM'	=> 'Printer.pm',
  'AUTHOR'		=> 'Edgars Binans <admin@wasx.net>',
  'INC'			=>  $inc,
  'LIBS'		=>  "-lDelayimp.lib $lib",
  'LDDLFLAGS'		=>  "$Config{lddlflags} $lin",
  'CCCDLFLAGS'		=>  $ccf
);
