#------------------------------------------------------------------------------#
# Win32::Printer & Win32::Printer::Enum test script                            #
# V 0.6.3 (2003-08-28) Win32 GDI                                               #
# Copyright (C) 2003 Edgars Binans <admin@wasx.net>                            #
#------------------------------------------------------------------------------#

use Test::Simple tests => 53;

use strict;
use warnings;

use Win32::Printer;
use Win32::Printer::Enum;
use Win32::Printer::Enum qw( Drivers Ports Monitors Processors Types Jobs );

#------------------------------------------------------------------------------#

my $dc = new Win32::Printer( dialog => NOSELECTION, orientation => LANDSCAPE );
ok ( defined($dc), 'new() works' );

ok ( defined($dc->{flags}), '$dc->{flags}' );
ok ( defined($dc->{minp}), '$dc->{minp}' );
ok ( defined($dc->{maxp}), '$dc->{maxp}' );
ok ( defined($dc->{copies}), '$dc->{copies}' );
ok ( defined($dc->{collate}), '$dc->{collate}' );

ok ( $dc->Unit('in') == 1, 'Unit()' );

ok ( $dc->Abort() == 1, 'Abort()' );
ok ( $dc->Start("Test 1") == 1, 'Start()' );

ok ( $dc->Brush(0, 128, 0) == 1, 'Brush()' );
ok ( $dc->Fill(ALTERNATE) == 1,  'Fill()' );
ok ( $dc->Pen(5, 0, 0, 255) == 1, 'Pen()' );

my $meta1 = $dc->Image('t/t.wmf', 0, 0, 5, 5);
ok ( $meta1 != 0, 'Image() wmf direct' );
my $meta2 = $dc->Image('t/t.emf');
ok ( $meta2 != 0, 'Image() emf' );
my $bmp00 = $dc->Image('t/t.png');
ok ( $bmp00 != 0, 'Image() bmp' );

my $fontref = $dc->Font('Arial Bold Italic Underline Strike', 20, 5);
ok ( $fontref != 0, 'Font() set');
ok ( $dc->Font($fontref) == $fontref, 'Font() select');
ok ( $dc->Color(128, 128, 128) == 1, 'Color()' );

ok ( $dc->Space(-1, 0, 0, -1, $dc->{xsize}, $dc->{ysize}) == 1, 'Space()' );

ok ( $dc->Arc(7.5, 3.5, 3, 2, 0, 90) == 1, 'Arc()' );
ok ( $dc->ArcTo(7.5, 3.5, 3, 2, 0, 90) == 1, 'ArcTo()' );
ok ( $dc->Chord(5, 5, 3, 2, 0, 90) == 1, 'Chord()' );
ok ( $dc->Write("Test text", 1, 1, 3, 50) != 0, 'Write() draw' );
ok ( $dc->Ellipse(1, 6, 3, 2) == 1, 'Ellipse()' );
ok ( $dc->Line(3, 5, 10, 7) == 1, 'Line()' );
ok ( $dc->LineTo(7, 7) == 1, 'LineTo()' );
ok ( $dc->Move(1, 1) == 1, 'Move()' );
ok ( $dc->Pie(8, 3, 3, 2, 0, 90) == 1, 'Pie()' );
ok ( $dc->Bezier(0, 0, 8, 6, 3, 6, 9, 5) == 1, 'Bezier()' );
ok ( $dc->BezierTo(8, 6, 6, 6, 9, 5) == 1, 'BezierTo()' );
ok ( $dc->Poly(1, 1, 2, 2, 2, 1, 4, 8) == 1, 'Poly()' );
ok ( $dc->Rect(6, .5, 3, 2, .5) == 1, 'Rect()' );
ok ( $dc->Image($bmp00, 5, 5, 2, 1) == $bmp00, 'Image() indirect' );
ok ( $dc->Write("This is test again!", 3, 3.5, RIGHT) == 1, 'Write() string' );
ok ( $dc->Write("... and again!", 2, 2, JUSTIFY, 5) == 1, 'Write() justify' );

ok ( $dc->Page() == 1, 'Page()' );

ok ( $dc->PBegin() == 1, 'PBegin()' );
$dc->Ellipse(1, 6, 6, 2);
ok ( $dc->PEnd() == 1, 'PEnd()' );
ok ( $dc->PClip(CR_AND) == 1, 'PClip()' );

$dc->PBegin();
$dc->Ellipse(1, 6, 3, 2);
$dc->Ellipse(2, 6, 3, 2);
$dc->PEnd();
ok ( $dc->PDraw() == 1, 'PDraw()' );

$dc->PBegin();
ok ( $dc->PAbort() == 1, 'PAbort()' );

ok ( $dc->Next("Test 2") == 1, 'Next()' );
ok ( $dc->End() == 1, 'End()' );

ok ( $dc->Close($fontref) == 1, 'Close() Font' );
ok ( $dc->Close($bmp00) == 1, 'Close() Image' );
ok ( $dc->Close() == 1, 'Close()' );

#------------------------------------------------------------------------------#

ok ( defined(Printers(ENUM_LOCAL)), 'Printers(ENUM_LOCAL)');
ok ( defined(Drivers()), 'Drivers()');
ok ( defined(Ports()), 'Ports()');
ok ( defined(Monitors()), 'Monitors()');
ok ( defined(Processors()), 'Processors()');
ok ( defined(Types()), 'Types()');
my @printer = Printers(ENUM_LOCAL);
ok ( defined(Jobs($printer[0]{PrinterName}, 0, 1)), 'Jobs()');

#------------------------------------------------------------------------------#
