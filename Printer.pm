#------------------------------------------------------------------------------#
# Win32::Printer                                                               #
# V 0.6.6.1 (2003-11-03)                                                       #
# Copyright (C) 2003 Edgars Binans <admin@wasx.net>                            #
# http://www.wasx.net                                                          #
#------------------------------------------------------------------------------#

package Win32::Printer;

use 5.008;
use strict;
use warnings;

use Carp;

require Exporter;

use vars qw( $VERSION @ISA @EXPORT @EXPORT_OK $AUTOLOAD %params @pdfend);

$VERSION = '0.6.6.1';

@ISA = qw( Exporter );

@EXPORT = qw(

	LETTER LETTERSMALL TABLOID LEDGER LEGAL STATEMENT EXECUTIVE A3 A4
	A4SMALL A5 B4 B5 FOLIO QUARTO IN_10X14 IN_11X17 NOTE ENV_9 ENV_10
	ENV_11 ENV_12 ENV_14 CSHEET DSHEET ESHEET ENV_DL ENV_C5 ENV_C3 ENV_C4
	ENV_C6 ENV_C65 ENV_B4 ENV_B5 ENV_B6 ENV_ITALY ENV_MONARCH ENV_PERSONAL
	FANFOLD_US FANFOLD_STD_GERMAN FANFOLD_LGL_GERMAN ISO_B4
	JAPANESE_POSTCARD IN_9X11 IN_10X11 IN_15X11 ENV_INVITE RESERVED_48
	RESERVED_49 LETTER_EXTRA LEGAL_EXTRA TABLOID_EXTRA A4_EXTRA
	LETTER_TRANSVERSE A4_TRANSVERSE LETTER_EXTRA_TRANSVERSE A_PLUS B_PLUS
	LETTER_PLUS A4_PLUS A5_TRANSVERSE B5_TRANSVERSE A3_EXTRA A5_EXTRA
	B5_EXTRA A2 A3_TRANSVERSE A3_EXTRA_TRANSVERSE

	PORTRAIT LANDSCAPE VERTICAL HORIZONTAL

	ALLPAGES SELECTION PAGENUMS NOSELECTION NOPAGENUMS COLLATE PRINTTOFILE
	PRINTSETUP NOWARNING USEDEVMODECOPIES USEDEVMODECOPIESANDCOLLATE
	DISABLEPRINTTOFILE HIDEPRINTTOFILE NONETWORKBUTTON

	NOUPDATECP TOP LEFT UPDATECP RIGHT VCENTER BOTTOM WORDBREAK BASELINE
	SINGLELINE EXPANDTABS NOCLIP EXTERNALLEADING CALCRECT NOPREFIX INTERNAL
	EDITCONTROL PATH_ELLIPSIS END_ELLIPSIS MODIFYSTRING RTLREADING
	WORD_ELLIPSIS CENTER JUSTIFY

	PS_SOLID PS_DASH PS_DOT PS_DASHDOT PS_DASHDOTDOT PS_NULL PS_INSIDEFRAME
	PS_JOIN_ROUND PS_ENDCAP_ROUND PS_ENDCAP_SQUARE PS_ENDCAP_FLAT
	PS_JOIN_BEVEL PS_JOIN_MITER

	HS_HORIZONTAL HS_VERTICAL HS_FDIAGONAL HS_BDIAGONAL HS_CROSS
	HS_DIAGCROSS

	ALTERNATE WINDING

	CR_AND CR_OR CR_XOR CR_DIFF CR_COPY

	ANSI DEFAULT SYMBOL SHIFTJIS HANGEUL GB2312 CHINESEBIG5 OEM JOHAB HEBREW
	ARABIC GREEK TURKISH VIETNAMESE THAI EASTEUROPE RUSSIAN MAC BALTIC

	BIN_ONLYONE BIN_LOWER BIN_MIDDLE BIN_MANUAL BIN_ENVELOPE BIN_ENVMANUAL
	BIN_AUTO BIN_TRACTOR BIN_SMALLFMT BIN_LARGEFMT BIN_LARGECAPACITY
	BIN_CASSETTE BIN_FORMSOURCE

	MONOCHROME COLOR

	DRIVERVERSION HORZSIZE VERTSIZE HORZRES VERTRES BITSPIXEL PLANES
	NUMBRUSHES NUMPENS NUMMARKERS NUMFONTS NUMCOLORS PDEVICESIZE CURVECAPS
	LINECAPS POLYGONALCAPS TEXTCAPS CLIPCAPS RASTERCAPS ASPECTX ASPECTY
	ASPECTXY LOGPIXELSX LOGPIXELSY SIZEPALETTE NUMRESERVED COLORRES
	PHYSICALWIDTH PHYSICALHEIGHT PHYSICALOFFSETX PHYSICALOFFSETY
	SCALINGFACTORX SCALINGFACTORY

      );

@EXPORT_OK = qw( );

require XSLoader;
XSLoader::load('Win32::Printer', $VERSION);

#------------------------------------------------------------------------------#

sub AUTOLOAD {

  my $constname = $AUTOLOAD;
  $constname =~ s/.*:://;

  croak "Unknown Win32::Printer macro $constname.\n";

}

#------------------------------------------------------------------------------#

# Print dialog
sub ALLPAGES			{ 0x000000; }
sub SELECTION			{ 0x000001; }
sub PAGENUMS			{ 0x000002; }
sub NOSELECTION			{ 0x000004; }
sub NOPAGENUMS			{ 0x000008; }
sub COLLATE			{ 0x000010; }
sub PRINTTOFILE			{ 0x000020; }
sub PRINTSETUP			{ 0x000040; }
sub NOWARNING			{ 0x000080; }
sub RETURNDC			{ 0x000100; }
sub RETURNIC			{ 0x000200; }
sub RETURNDEFAULT		{ 0x000400; }
sub SHOWHELP			{ 0x000800; }
sub ENABLEPRINTHOOK		{ 0x001000; }
sub ENABLESETUPHOOK		{ 0x002000; }
sub ENABLEPRINTTEMPLATE		{ 0x004000; }
sub ENABLESETUPTEMPLATE		{ 0x008000; }
sub ENABLEPRINTTEMPLATEHANDLE	{ 0x010000; }
sub ENABLESETUPTEMPLATEHANDLE	{ 0x020000; }
sub USEDEVMODECOPIES		{ 0x040000; }
sub USEDEVMODECOPIESANDCOLLATE	{ 0x040000; }
sub DISABLEPRINTTOFILE		{ 0x080000; }
sub HIDEPRINTTOFILE		{ 0x100000; }
sub NONETWORKBUTTON		{ 0x200000; }

# Paper source bin
sub BIN_ONLYONE			{ 1; }
sub BIN_LOWER			{ 2; }
sub BIN_MIDDLE			{ 3; }
sub BIN_MANUAL			{ 4; }
sub BIN_ENVELOPE		{ 5; }
sub BIN_ENVMANUAL		{ 6; }
sub BIN_AUTO			{ 7; }
sub BIN_TRACTOR			{ 8; }
sub BIN_SMALLFMT		{ 9; }
sub BIN_LARGEFMT		{ 10; }
sub BIN_LARGECAPACITY		{ 11; }
sub BIN_CASSETTE		{ 14; }
sub BIN_FORMSOURCE		{ 15; }

# Printer output color setting
sub MONOCHROME 			{ 1; }
sub COLOR			{ 2; }

# Device caps
sub DRIVERVERSION		{ 0; }
sub TECHNOLOGY			{ 2; }
sub HORZSIZE			{ 4; }
sub VERTSIZE			{ 6; }
sub HORZRES			{ 8; }
sub VERTRES			{ 10; }
sub BITSPIXEL			{ 12; }
sub PLANES			{ 14; }
sub NUMBRUSHES			{ 16; }
sub NUMPENS			{ 18; }
sub NUMMARKERS			{ 20; }
sub NUMFONTS			{ 22; }
sub NUMCOLORS			{ 24; }
sub PDEVICESIZE			{ 26; }
sub CURVECAPS			{ 28; }
sub LINECAPS			{ 30; }
sub POLYGONALCAPS		{ 32; }
sub TEXTCAPS			{ 34; }
sub CLIPCAPS			{ 36; }
sub RASTERCAPS			{ 38; }
sub ASPECTX			{ 40; }
sub ASPECTY			{ 42; }
sub ASPECTXY			{ 44; }
sub LOGPIXELSX			{ 88; }
sub LOGPIXELSY			{ 90; }
sub SIZEPALETTE			{ 104; }
sub NUMRESERVED			{ 106; }
sub COLORRES			{ 108; }
sub PHYSICALWIDTH		{ 110; }
sub PHYSICALHEIGHT		{ 111; }
sub PHYSICALOFFSETX		{ 112; }
sub PHYSICALOFFSETY		{ 113; }
sub SCALINGFACTORX		{ 114; }
sub SCALINGFACTORY		{ 115; }

# Text output flags

sub NOUPDATECP			{ 0x00000000; }	#
sub TOP				{ 0x00000000; }	#
sub LEFT			{ 0x00000000; }	#
sub UPDATECP			{ 0x00000001; }	#
sub RIGHT			{ 0x00000002; }	#
sub VCENTER			{ 0x00000004; }
sub BOTTOM			{ 0x00000008; }	#
sub WORDBREAK			{ 0x00000010; }
sub BASELINE			{ 0x00000018; }	#
sub SINGLELINE			{ 0x00000020; }
sub EXPANDTABS			{ 0x00000040; }
sub TABSTOP			{ 0x00000080; }
sub NOCLIP			{ 0x00000100; }
sub EXTERNALLEADING		{ 0x00000200; }
sub CALCRECT			{ 0x00000400; }
sub NOPREFIX			{ 0x00000800; }
sub INTERNAL			{ 0x00001000; }
sub EDITCONTROL			{ 0x00002000; }
sub PATH_ELLIPSIS		{ 0x00004000; }
sub END_ELLIPSIS		{ 0x00008000; }
sub MODIFYSTRING		{ 0x00010000; }
sub RTLREADING			{ 0x00020000; }	# Modify 1
sub WORD_ELLIPSIS		{ 0x00040000; }
sub CENTER			{ 0x00080000; }	# Modify 2

sub JUSTIFY			{ 0x80000000; }

# Pen styles
sub PS_DASH			{ 0x00000001; }
sub PS_DOT			{ 0x00000002; }
sub PS_DASHDOT			{ 0x00000003; }
sub PS_DASHDOTDOT		{ 0x00000004; }
sub PS_NULL			{ 0x00000005; }
sub PS_INSIDEFRAME		{ 0x00000006; }
sub PS_SOLID			{ 0x00010000; }
sub PS_JOIN_ROUND		{ 0x00010000; }
sub PS_ENDCAP_ROUND		{ 0x00010000; }
sub PS_ENDCAP_SQUARE		{ 0x00010100; }
sub PS_ENDCAP_FLAT		{ 0x00010200; }
sub PS_JOIN_BEVEL		{ 0x00011000; }
sub PS_JOIN_MITER		{ 0x00012000; }

# Brush styles
sub BS_SOLID			{ 0; }
sub BS_NULL			{ 1; }
sub BS_HOLLOW			{ 1; }
sub BS_HATCHED			{ 2; }
sub BS_PATTERN			{ 3; }
sub BS_DIBPATTERN		{ 5; }
sub BS_DIBPATTERNPT		{ 6; }
sub BS_PATTERN8X8		{ 7; }
sub BS_DIBPATTERN8X8		{ 8; }

# Brush hatches
sub HS_HORIZONTAL		{ 0; }
sub HS_VERTICAL			{ 1; }
sub HS_FDIAGONAL		{ 2; }
sub HS_BDIAGONAL		{ 3; }
sub HS_CROSS			{ 4; }
sub HS_DIAGCROSS		{ 5; }

# Path modes
sub CR_AND			{ 1; }
sub CR_OR			{ 2; }
sub CR_XOR			{ 3; }
sub CR_DIFF			{ 4; }
sub CR_COPY			{ 5; }

# Fill modes
sub ALTERNATE			{ 1; }
sub WINDING			{ 2; }

# Duplexing
sub SIMPLEX			{ 1; }
sub VERTICAL 			{ 2; }
sub HORIZONTAL			{ 3; }

# Paper sizes
sub LETTER			{ 1; }
sub LETTERSMALL			{ 2; }
sub TABLOID			{ 3; }
sub LEDGER			{ 4; }
sub LEGAL			{ 5; }
sub STATEMENT			{ 6; }
sub EXECUTIVE			{ 7; }
sub A3				{ 8; }
sub A4				{ 9; }
sub A4SMALL			{ 10; }
sub A5				{ 11; }
sub B4				{ 12; }
sub B5				{ 13; }
sub FOLIO			{ 14; }
sub QUARTO			{ 15; }
sub IN_10X14			{ 16; }
sub IN_11X17			{ 17; }
sub NOTE			{ 18; }
sub ENV_9			{ 19; }
sub ENV_10			{ 20; }
sub ENV_11			{ 21; }
sub ENV_12			{ 22; }
sub ENV_14			{ 23; }
sub CSHEET			{ 24; }
sub DSHEET			{ 25; }
sub ESHEET			{ 26; }
sub ENV_DL			{ 27; }
sub ENV_C5			{ 28; }
sub ENV_C3			{ 29; }
sub ENV_C4			{ 30; }
sub ENV_C6			{ 31; }
sub ENV_C65			{ 32; }
sub ENV_B4			{ 33; }
sub ENV_B5			{ 34; }
sub ENV_B6			{ 35; }
sub ENV_ITALY			{ 36; }
sub ENV_MONARCH			{ 37; }
sub ENV_PERSONAL		{ 38; }
sub FANFOLD_US			{ 39; }
sub FANFOLD_STD_GERMAN		{ 40; }
sub FANFOLD_LGL_GERMAN		{ 41; }
sub ISO_B4			{ 42; }
sub JAPANESE_POSTCARD		{ 43; }
sub IN_9X11			{ 44; }
sub IN_10X11			{ 45; }
sub IN_15X11			{ 46; }
sub ENV_INVITE			{ 47; }
sub RESERVED_48			{ 48; }
sub RESERVED_49			{ 49; }
sub LETTER_EXTRA		{ 50; }
sub LEGAL_EXTRA			{ 51; }
sub TABLOID_EXTRA		{ 52; }
sub A4_EXTRA			{ 53; }
sub LETTER_TRANSVERSE		{ 54; }
sub A4_TRANSVERSE		{ 55; }
sub LETTER_EXTRA_TRANSVERSE	{ 56; }
sub A_PLUS			{ 57; }
sub B_PLUS			{ 58; }
sub LETTER_PLUS			{ 59; }
sub A4_PLUS			{ 60; }
sub A5_TRANSVERSE		{ 61; }
sub B5_TRANSVERSE		{ 62; }
sub A3_EXTRA			{ 63; }
sub A5_EXTRA			{ 64; }
sub B5_EXTRA			{ 65; }
sub A2				{ 66; }
sub A3_TRANSVERSE		{ 67; }
sub A3_EXTRA_TRANSVERSE		{ 68; }

# Paper orientation
sub PORTRAIT			{ 1; }
sub LANDSCAPE			{ 2; }

# Font flags
sub OUT_DEFAULT_PRECIS		{ 0; }
sub OUT_STRING_PRECIS		{ 1; }
sub OUT_CHARACTER_PRECIS	{ 2; }
sub OUT_STROKE_PRECIS		{ 3; }
sub OUT_TT_PRECIS		{ 4; }
sub OUT_DEVICE_PRECIS		{ 5; }
sub OUT_RASTER_PRECIS		{ 6; }
sub OUT_TT_ONLY_PRECIS		{ 7; }
sub OUT_OUTLINE_PRECIS		{ 8; }

sub CLIP_DEFAULT_PRECIS		{ 0; }
sub CLIP_CHARACTER_PRECIS	{ 1; }
sub CLIP_STROKE_PRECIS		{ 2; }
sub CLIP_MASK			{ 0xF; }
sub CLIP_LH_ANGLES		{ (1<<4); }
sub CLIP_TT_ALWAYS		{ (2<<4); }
sub CLIP_EMBEDDED		{ (8<<4); }

sub DEFAULT_QUALITY		{ 0; }
sub DRAFT_QUALITY		{ 1; }
sub PROOF_QUALITY		{ 2; }
sub NONANTIALIASED_QUALITY	{ 3; }
sub ANTIALIASED_QUALITY		{ 4; }

sub DEFAULT_PITCH		{ 0; }
sub FIXED_PITCH			{ 1; }
sub VARIABLE_PITCH		{ 2; }

sub MONO_FONT			{ 8; }

# Character sets
sub ANSI			{ 0; }
sub DEFAULT			{ 1; }
sub SYMBOL			{ 2; }
sub SHIFTJIS			{ 128; }
sub HANGEUL			{ 129; }
sub GB2312			{ 134; }
sub CHINESEBIG5			{ 136; }
sub OEM				{ 255; }

sub JOHAB			{ 130; }
sub HEBREW			{ 177; }
sub ARABIC			{ 178; }
sub GREEK			{ 161; }
sub TURKISH			{ 162; }
sub VIETNAMESE			{ 163; }
sub THAI			{ 222; }
sub EASTEUROPE			{ 238; }
sub RUSSIAN			{ 204; }

sub MAC				{ 77; }
sub BALTIC			{ 186; }

# Font Families
sub FF_DONTCARE			{ (0<<4); }
sub FF_ROMAN			{ (1<<4); }
sub FF_SWISS			{ (2<<4); }
sub FF_MODERN			{ (3<<4); }
sub FF_SCRIPT			{ (4<<4); }
sub FF_DECORATIVE		{ (5<<4); }

# Font Weights
sub FW_DONTCARE			{ 0; }
sub FW_THIN			{ 100; }
sub FW_EXTRALIGHT		{ 200; }
sub FW_LIGHT			{ 300; }
sub FW_NORMAL			{ 400; }
sub FW_MEDIUM			{ 500; }
sub FW_SEMIBOLD			{ 600; }
sub FW_BOLD			{ 700; }
sub FW_EXTRABOLD		{ 800; }
sub FW_HEAVY			{ 900; }
sub FW_ULTRALIGHT		{ 200; }
sub FW_REGULAR			{ 400; }
sub FW_DEMIBOLD			{ 600; }
sub FW_ULTRABOLD		{ 800; }
sub FW_BLACK			{ 900; }

# FreeImage file formats:
sub FIF_UNKNOWN			{ -1; }
sub FIF_BMP			{ 0; }
sub FIF_ICO			{ 1; }
sub FIF_JPEG			{ 2; }
sub FIF_JNG			{ 3; }
sub FIF_KOALA			{ 4; }
sub FIF_LBM			{ 5; }
sub FIF_IFF			{ 5; }
sub FIF_MNG			{ 6; }
sub FIF_PBM			{ 7; }
sub FIF_PBMRAW			{ 8; }
sub FIF_PCD			{ 9; }
sub FIF_PCX			{ 10; }
sub FIF_PGM			{ 11; }
sub FIF_PGMRAW			{ 12; }
sub FIF_PNG			{ 13; }
sub FIF_PPM			{ 14; }
sub FIF_PPMRAW			{ 15; }
sub FIF_RAS			{ 16; }
sub FIF_TARGA			{ 17; }
sub FIF_TIFF			{ 18; }
sub FIF_WBMP			{ 19; }
sub FIF_PSD			{ 20; }
sub FIF_CUT			{ 21; }

#------------------------------------------------------------------------------#

sub new {

  my $class = shift;

  my $self = { };

  bless $self, $class;

  $self->_init(@_);

  return $self;

}

#------------------------------------------------------------------------------#

sub _init {

  my $self = shift;

  (%params) = @_;

  for (keys %params) {
    if ($_ !~ /dc|printer|dialog|file|pdf|copies|collate|minp|maxp|orientation|papersize|duplex|description|unit|source|color/) {
      carp qq^WARNING: Unknown attribute "$_"!\n^;
    }
  }

  my $dialog;
  if (defined($params{'dialog'})) {
    $dialog = 1;
  } else {
    $dialog = 0;
    $params{'dialog'} = 0;
  }

  if ((defined($params{'pdf'})) and (!defined($params{'file'}))) {
      delete $params{'pdf'};
      carp qq^WARNING: pdf attribute used without file attribute - IGNORED!\n^;
  }

  if (!defined $params{'printer'})	{ $params{'printer'}	 = ""; }
  if (!_num($params{'copies'}))		{ $params{'copies'}	 = 1;  }
  if (!_num($params{'collate'}))	{ $params{'collate'}	 = 1;  }
  if (!_num($params{'minp'}))		{ $params{'minp'}	 = 0;  }
  if (!_num($params{'maxp'}))		{ $params{'maxp'}	 = 0;  }
  if (!_num($params{'orientation'}))	{ $params{'orientation'} = 0;  }
  if (!_num($params{'papersize'}))	{ $params{'papersize'}	 = 0;  }
  if (!_num($params{'duplex'}))		{ $params{'duplex'}	 = 0;  }
  if (!_num($params{'source'}))		{ $params{'source'}	 = 7;  }
  if (!_num($params{'color'}))		{ $params{'color'}	 = 2;  }

  $self->{dc} = _CreatePrinter($params{'printer'}, $dialog, $params{'dialog'}, $params{'copies'}, $params{'collate'}, $params{'minp'}, $params{'maxp'}, $params{'orientation'}, $params{'papersize'}, $params{'duplex'}, $params{'source'}, $params{'color'});
  unless ($self->{dc}) {
    croak "ERROR: Cannot create printer object! ${\_GetLastError()}";
  }

  $self->Unit($params{'unit'});

  $self->{flags}   = $params{'dialog'};
  $self->{copies}  = $params{'copies'};
  $self->{collate} = $params{'collate'};
  $self->{minp}    = $params{'minp'};
  $self->{maxp}    = $params{'maxp'};

  if (!defined($params{'dc'}) || !$params{'dc'}) {
    $self->Start($params{description}, $params{'file'});
  }

  $self->Space(1, 0, 0, 1, 0, 0);
  $self->Pen(1, 0, 0, 0);
  $self->Color(0, 0, 0);
  $self->Brush(128, 128, 128);
  $self->Font($self->Font());

  return 1;

}

#------------------------------------------------------------------------------#

sub _num {

  my $val = shift;

  if (defined($val)) {
    if ($val =~ /^\-*\d+\.*\d*$/) {
      return 1;
    } else {
      croak qq^ERROR: Argument "$val" isn't numeric!\n^;
    }
  } else {
    return 0;
  }

}

#------------------------------------------------------------------------------#

sub _xun2p {

  my $self = shift;
  my $uval = shift;
  my $pval = $uval * $self->{xres} / $self->{unit};
  return $pval;

}

sub _yun2p {

  my $self = shift;
  my $uval = shift;
  my $pval = $uval * $self->{yres} / $self->{unit};
  return $pval;

}

sub _xp2un {

  my $self = shift;
  my $pval = shift;
  my $uval = ($self->{unit} * $pval) / $self->{xres};
  return $uval;

}

sub _yp2un {

  my $self = shift;
  my $pval = shift;
  my $uval = ($self->{unit} * $pval) / $self->{yres};
  return $uval;

}

sub _pts2p {

  my $self = shift;
  my $ptsval = shift;
  my $pval = ($ptsval * $self->{xres}) / 72;
  return $pval;

}

#------------------------------------------------------------------------------#

sub _pdf {

  if ((defined($params{'pdf'})) and (defined($pdfend[0]))) {

    my $oldout;
    if ($params{'pdf'} == 1) {
      open $oldout, ">&STDOUT";
      open (STDOUT, ">$pdfend[1].log");
      select STDOUT; $| = 1;
    }

    unless (Win32::Printer::_GhostPDF(@pdfend)) {
      croak "ERROR: Cannot create PDF document! ${\_GetLastError()}";
    }

    if ($params{'pdf'} == 1) {
      close STDOUT;
      open STDOUT, ">&", $oldout;
    }

    unlink "$pdfend[0]";
    unlink "$pdfend[1].log" if $params{'pdf'} == 0;

    @pdfend = ();

  }

}

#------------------------------------------------------------------------------#

sub Unit {

  my $self = shift;

  if ($#_ > 0) { carp "WARNING: Too many actual parameters!\n"; }

  my $unit = shift;

  if ($unit) {
    if ($unit =~ /^mm$/i) {
      $self->{unit} = 25.409836;
    } elsif ($unit =~ /^cm$/i) {
      $self->{unit} = 2.5409836;
    } elsif ($unit =~ /^in$/i) {
      $self->{unit} = 1;
    } elsif ($unit =~ /^pt$/i) {
      $self->{unit} = 72;
    } elsif ($unit =~ /^\d+\.\d*$/i) {
      $self->{unit} = $unit;
    } else {
      carp "WARNING: Invalid unit \"$unit\"! Units set to \"in\".\n";
      $self->{unit} = 1;
    }
  } else {
    $self->{unit} = 1;
  }

  $self->{xres} = $self->Caps(LOGPIXELSX);
  $self->{yres} = $self->Caps(LOGPIXELSY);

  $self->{xsize} = $self->_xp2un($self->Caps(PHYSICALWIDTH));
  $self->{ysize} = $self->_yp2un($self->Caps(PHYSICALHEIGHT));

  unless (($self->{xres} > 0) or ($self->{yres} > 0) or ($self->{xsize} > 0) or ($self->{ysize} > 0)) {
    croak "ERROR: Cannot get printer resolution! ${\_GetLastError()}";
  }

  return $self->{unit};

}

#------------------------------------------------------------------------------#

sub Next {

  my $self = shift;

  if ($#_ > 1) { carp "WARNING: Too many actual parameters!\n"; }

  my $desc = shift;
  my $file = shift;

  $self->End();
  $self->Start($desc, $file);

  $self->Space(1, 0, 0, 1, 0, 0);

  return 1;

}

#------------------------------------------------------------------------------#

sub Start {

  my $self = shift;

  if ($#_ > 1) { carp "WARNING: Too many actual parameters!\n"; }

  my $desc = shift;
  my $file = shift;

  if ((!defined($file)) and (!defined($params{'file'}))) {
    $file = "";
  } else {
    if ((!defined($file)) and (defined($params{'file'}))) {
      $file = $params{'file'};
    }
    while (-f $file) { 
      $file =~ s/(?:\((\d+)\))*(\..*)*$/my $i; $1 ? ($i = $1 + 1) : ($i = 1); $2 ? "\($i\)$2" : "\($i\)"/e;
      $params{'file'} = $file;
    }
  }

  if (($file ne "") and (defined($params{'pdf'}))) {
    $pdfend[1] = $file;
    my $tmp = Win32::Printer::_GetTempPath();
    $file =~ s/.*\\//;
    $file = $tmp.$file;
    $pdfend[0] = $file;
  }

  unless (_StartDoc($self->{dc}, $desc || $params{'description'} || 'Printer', $file) > 0) {
    croak "ERROR: Cannot start the document! ${\_GetLastError()}";
  }

  unless (_StartPage($self->{dc}) > 0) {
    croak "ERROR: Cannot start the page! ${\_GetLastError()}";
  }

  $self->Space(1, 0, 0, 1, 0, 0);

  return 1;

}

#------------------------------------------------------------------------------#

sub End {

  my $self = shift;

  if ($#_ > -1) { carp "WARNING: Too many actual parameters!\n"; }

  unless (_EndPage($self->{dc}) > 0) {
    croak "ERROR: Cannot end the page! ${\_GetLastError()}";
  }

  unless (_EndDoc($self->{dc})) {
    croak "ERROR: Cannot end the document! ${\_GetLastError()}";
  }

  _pdf();

  return 1;

}

#------------------------------------------------------------------------------#

sub Abort {

  my $self = shift;

  if ($#_ > -1) { carp "WARNING: Too many actual parameters!\n"; }

  unless (_AbortDoc($self->{dc})) {
    croak "ERROR: Cannot abort the document! ${\_GetLastError()}";
  }

  _pdf();

  return 1;

}

#------------------------------------------------------------------------------#

sub Page {

  my $self = shift;

  if ($#_ > -1) { carp "WARNING: Too many actual parameters!\n"; }

  unless (_EndPage($self->{dc}) > 0) {
    croak "ERROR: Cannot end the page! ${\_GetLastError()}";
  }

  unless (_StartPage($self->{dc}) > 0) {
    croak "ERROR: Cannot start the page! ${\_GetLastError()}";
  }

  $self->Space(1, 0, 0, 1, 0, 0);

  return 1;

}

#------------------------------------------------------------------------------#

sub Space {

  my $self = shift;

  if ($#_ > 5) { carp "WARNING: Too many actual parameters!\n"; }
  if ($#_ < 5) { croak "ERROR: Not enough actual parameters!\n"; }

  for (@_) { _num($_); }

  my ($m11, $m12, $m21, $m22, $dx, $dy) = @_;

  my $xoff = $self->Caps(PHYSICALOFFSETX);
  my $yoff = $self->Caps(PHYSICALOFFSETY);

  if (_SetWorldTransform($self->{dc}, $m11, $m12, $m21, $m22, $self->_xun2p($dx) - $xoff, $self->_yun2p($dy) - $yoff) == 0) {
    croak "ERROR: Cannot transform space! ${\_GetLastError()}";
  }

  return 1;

}

#------------------------------------------------------------------------------#

sub Font {

  my $self = shift;

  if ($#_ > 3) { carp "WARNING: Too many actual parameters!\n"; }

  if (($#_ == 0) and ($_[0] =~ /-*\d+/)) {

    unless (_SelectObject($self->{dc}, $_[0])) {
      croak "ERROR: Cannot select font! ${\_GetLastError()}";
    }

    return $_[0];

  } else {

    my ($face, $size, $angle, $charset) = @_;

    $face = 'Courier' if !defined $face;
    $size = 10 if !_num($size);
    $angle = 0 if !_num($angle);
    $charset = DEFAULT if !_num($charset);

    my $fontid = "$face\_$size\_$angle\_$charset";

    if (!$self->{obj}->{$fontid}) {

      $angle *= 10;
    
      my ($opt1, $opt2, $opt3, $opt4) = (FW_NORMAL, 0, 0, 0);
      if ($face =~ /bold/i ) {
        $opt1 = FW_BOLD;
        $face =~ s/\s*bold\s*//i;
      }
      if ( $face =~ /italic/i ){
        $opt2 = 1;
        $face =~ s/\s*italic\s*//i;
      }
      if ( $face =~ /underline/i ){
        $opt3 = 1;
        $face =~ s/\s*underline\s*//i;
      }
      if ( $face =~ /strike/i ){
        $opt4 = 1;
        $face =~ s/\s*strike\s*//i;
      }

      $face =~ s/^\s*//;
      $face =~ s/\s*$//;

      $self->{obj}->{$fontid} = _CreateFont(-$self->_pts2p($size), 0, $angle, $angle,
                                $opt1, $opt2, $opt3, $opt4, $charset,
                                OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
                                DEFAULT_QUALITY, DEFAULT_PITCH, $face);

      if ($self->{obj}->{$fontid}) {

        unless (_SelectObject($self->{dc}, $self->{obj}->{$fontid})) {
          croak "ERROR: Cannot select font! ${\_GetLastError()}";
        }

        return $self->{obj}->{$fontid};

      } else {
        croak "ERROR: Cannot create font! ${\_GetLastError()}";
      }

    }

  }

}

#------------------------------------------------------------------------------#

sub Write {

  my $self = shift;

  if ($#_ > 6) { carp "WARNING: Too many actual parameters!\n"; }
  if ($#_ < 2) { croak "ERROR: Not enough actual parameters!\n"; }

  if ((($#_ > 1) and ($#_ < 4)) or (($_[3] & 0x80000000) and ($#_ == 4))) {

    my ($string, $x, $y, $align) = @_;

    for ($x, $y, $align) {
      _num($_);
    }

    if (!defined($string)) { $string = ""; }

    if (!$align) { $align = LEFT; }

    if ($align & 0x00020000) { $align = $align - 0x00020000 + 0x00000100; }
    if ($align & 0x00080000) { $align = $align - 0x00080000 + 0x00000006; }

    if ($align & 0x80000000) {

      my $width = $self->_xun2p($_[4]);

      unless (_SetJustify($self->{dc}, $string, $width)) {
        croak "ERROR: Cannot set text justification! ${\_GetLastError()}";
      }

    }

    unless (_TextOut($self->{dc}, $self->_xun2p($x), $self->_yun2p($y), $string, $align)) {
      croak "ERROR: Cannot write text! ${\_GetLastError()}";
    }

    unless (_SetJustify($self->{dc}, "", -1)) {
      croak "ERROR: Cannot unset text justification! ${\_GetLastError()}";
    }

    return 1;

  } else {

    my ($string, $x, $y, $w, $h, $f, $tab) = @_;

    for ($x, $y, $w, $h, $f, $tab) {
      _num($_);
    }

    if (!defined($string)) { $string = ""; }

    my $height;
    my $len = 0;
    my $width = $self->_xun2p($x + $w);

    if (!$f) { $f = 0; }
    if (!$tab) { $tab = 8; }

    if ($f & 0x00080000) { $f = $f - 0x00080000 + 0x00000001; }

    $height = _DrawText($self->{dc}, $string,
			$self->_xun2p($x), $self->_yun2p($y),
			$width, $self->_yun2p($y + $h),
			$f, $len, $tab);

    unless ($height) {
        croak "ERROR: Cannot draw text! ${\_GetLastError()}";
    }

    return wantarray ? ($self->_yp2un($width), $self->_yp2un($height), $len, $string) : $self->_yp2un($height);

  }

}

#------------------------------------------------------------------------------#

sub Pen {

  my $self = shift;

  my $penid = "pen";

  if ($#_ == -1) {

    if (!$self->{obj}->{$penid}) {

      $self->{obj}->{$penid} = _CreatePen(PS_NULL, 0, 0, 0, 0);

      unless ($self->{obj}->{$penid}) {
        croak "ERROR: Cannot create pen! ${\_GetLastError()}";
      }

    }

  } else {

    if ($#_ > 4) { carp "WARNING: Too many actual parameters!\n"; }
    if ($#_ < 3) { croak "ERROR: Not enough actual parameters!\n"; }

    my ($w, $r, $g, $b, $s) = @_;

    for ($w, $r, $g, $b, $s) {
      _num($_);
    }

    if (!defined($s)) { $s = PS_SOLID; }

    if (0x00010000 & $s) {
      $w = $self->_pts2p($w);
    } else {
      $w = 1;
    }

    $penid = "$w\_$r\_$g\_$b\_$s";

    if (!$self->{obj}->{$penid}) {

      $self->{obj}->{$penid} = _CreatePen($s, $w, $r, $g, $b);

      unless ($self->{obj}->{$penid}) {
        croak "ERROR: Cannot create pen! ${\_GetLastError()}";
      }

    }

  }

  unless (_SelectObject($self->{dc}, $self->{obj}->{$penid})) {
    croak "ERROR: Cannot select pen! ${\_GetLastError()}";
  }

  return 1;

}

#------------------------------------------------------------------------------#

sub Color {

  my $self = shift;

  if ($#_ > 2) { carp "WARNING: Too many actual parameters!\n"; }
  if ($#_ < 2) { croak "ERROR: Not enough actual parameters!\n"; }

  for (@_) { _num($_); }

  my ($r, $g, $b) = @_;

  my $coloref = _SetTextColor($self->{dc}, $r, $g, $b);

  if (!defined($coloref) or ($coloref =~ /-/)) {
    croak "ERROR: Cannot select color! ${\_GetLastError()}";
  }

  return 1;

}

#------------------------------------------------------------------------------#

sub Brush {

  my $self = shift;

  for (@_) { _num($_); }

  my ($r, $g, $b, $hs) = @_;

  my ($bs, $brushid);

  $brushid = "brush";

  if (!defined($r)) {

    if (!$self->{obj}->{$brushid}) {

      $self->{obj}->{$brushid} = _CreateBrushIndirect(BS_NULL, 0, 255, 255, 255);

      unless ($self->{obj}->{$brushid}) {
        croak "ERROR: Cannot create brush! ${\_GetLastError()}";
      }

    }

  } else {

    if ($#_ > 3) { carp "WARNING: Too many actual parameters!\n"; }
    if ($#_ < 2) { croak "ERROR: Not enough actual parameters!\n"; }

    if (defined($hs)) {
      $bs = BS_HATCHED;
    } else {
      $bs = BS_SOLID;
      $hs = 0;
    }

    $brushid = "$r\_$g\_$b\_$hs";

    if (!$self->{obj}->{$brushid}) {

      $self->{obj}->{$brushid} = _CreateBrushIndirect($bs, $hs, $r, $g, $b);

      unless ($self->{obj}->{$brushid}) {
        croak "ERROR: Cannot create brush! ${\_GetLastError()}";
      }

    }

  }

  unless (_SelectObject($self->{dc}, $self->{obj}->{$brushid})) {
    croak "ERROR: Cannot select brush! ${\_GetLastError()}";
  }

  return 1;

}

#------------------------------------------------------------------------------#

sub Fill {

  my $self = shift;

  if ($#_ > 0) { carp "WARNING: Too many actual parameters!\n"; }
  if ($#_ < 0) { croak "ERROR: Not enough actual parameters!\n"; }

  my $fmode = shift;
  _num($fmode);

  unless (_SetPolyFillMode($self->{dc}, $fmode)) {
    croak "ERROR: Cannot select brush! ${\_GetLastError()}";
  }

  return 1;

}

#------------------------------------------------------------------------------#

sub Rect {

  my $self = shift;

  if ($#_ > 5) { carp "WARNING: Too many actual parameters!\n"; }
  if ($#_ < 3) { croak "ERROR: Not enough actual parameters!\n"; }

  for (@_) { _num($_); }

  my ($x, $y, $w, $h, $ew, $eh) = @_;

  if ($ew) {

    if (!$eh) { $eh = $ew; }

    unless (_RoundRect($self->{dc}, $self->_xun2p($x), $self->_yun2p($y),
			     $self->_xun2p($x + $w), $self->_yun2p($y + $h),
			     $self->_xun2p($ew), $self->_yun2p($eh))) {
      croak "ERROR: Cannot draw rectangular! ${\_GetLastError()}";
    }

  } else {

    unless (_Rectangle($self->{dc}, $self->_xun2p($x), $self->_yun2p($y),
			     $self->_xun2p($x + $w), $self->_yun2p($y + $h))) {
      croak "ERROR: Cannot draw rectangular! ${\_GetLastError()}";
    }

  }

  return 1;

}

#------------------------------------------------------------------------------#

sub Ellipse {

  my $self = shift;

  if ($#_ > 3) { carp "WARNING: Too many actual parameters!\n"; }
  if ($#_ < 3) { croak "ERROR: Not enough actual parameters!\n"; }

  for (@_) { _num($_); }

  my ($x, $y, $w, $h) = @_;

  unless (_Ellipse($self->{dc}, $self->_xun2p($x), $self->_yun2p($y),
			 $self->_xun2p($x + $w), $self->_yun2p($y + $h))) {
    croak "ERROR: Cannot draw ellipse! ${\_GetLastError()}";
  }

  return 1;

}

#------------------------------------------------------------------------------#

sub Chord {

  my $self = shift;

  if ($#_ > 5) { carp "WARNING: Too many actual parameters!\n"; }
  if ($#_ < 5) { croak "ERROR: Not enough actual parameters!\n"; }

  for (@_) { _num($_); }

  my ($x, $y, $w, $h, $a1, $a2) = @_;

  my $r1 = $w / 2;
  my $r2 = $h / 2;
  my $xc = $x + $r1;
  my $yc = $y + $r2;

  my $pi = 3.1415926535;

  my $rm1 = sqrt(abs(($r1 * $r1 * $r2 * $r2) / ($r1 * $r1 * sin($a1 * $pi / 180) + $r2 * $r2 * cos($a1 * $pi / 180))));
  my $rm2 = sqrt(abs(($r1 * $r1 * $r2 * $r2) / ($r1 * $r1 * sin($a2 * $pi / 180) + $r2 * $r2 * cos($a2 * $pi / 180))));

  my $xr1 = $xc + cos($a1 * $pi / 180) * $rm1;
  my $yr1 = $yc - sin($a1 * $pi / 180) * $rm1;
  my $xr2 = $xc + cos($a2 * $pi / 180) * $rm2;
  my $yr2 = $yc - sin($a2 * $pi / 180) * $rm2;

  unless (_Chord($self->{dc}, $self->_xun2p($x), $self->_yun2p($y),
		       $self->_xun2p($x + $w), $self->_yun2p($y + $h),
		       $self->_xun2p($xr1), $self->_yun2p($yr1),
		       $self->_xun2p($xr2), $self->_yun2p($yr2))) {
    croak "ERROR: Cannot draw chord! ${\_GetLastError()}";
  }

  return 1;

}

#------------------------------------------------------------------------------#

sub Pie {

  my $self = shift;

  if ($#_ > 5) { carp "WARNING: Too many actual parameters!\n"; }
  if ($#_ < 5) { croak "ERROR: Not enough actual parameters!\n"; }

  for (@_) { _num($_); }

  my ($x, $y, $w, $h, $a1, $a2) = @_;

  my $xc = $x + $w / 2;
  my $yc = $y + $h / 2;

  my $pi=3.1415926535;

  my $xr1 = $xc + int(100 * cos($a1 * $pi / 180));
  my $yr1 = $yc - int(100 * sin($a1 * $pi / 180));
  my $xr2 = $xc + int(100 * cos($a2 * $pi / 180));
  my $yr2 = $yc - int(100 * sin($a2 * $pi / 180));

  unless (_Pie($self->{dc}, $self->_xun2p($x), $self->_yun2p($y),
		     $self->_xun2p($x + $w), $self->_yun2p($y + $h),
		     $self->_xun2p($xr1), $self->_yun2p($yr1),
		     $self->_xun2p($xr2), $self->_yun2p($yr2))) {
    croak "ERROR: Cannot draw pie! ${\_GetLastError()}";
  }

  return 1;

}

#------------------------------------------------------------------------------#

sub Move {

  my $self = shift;

  if ($#_ > 1) { carp "WARNING: Too many actual parameters!\n"; }
  if ($#_ < 1) { croak "ERROR: Not enough actual parameters!\n"; }

  for (@_) { _num($_); }

  my ($x, $y) = @_;

  unless (_MoveTo($self->{dc}, $self->_xun2p($x), $self->_yun2p($y))) {
    croak "ERROR: Cannot Move! ${\_GetLastError()}";
  }

  return 1;

}

#------------------------------------------------------------------------------#

sub Arc {

  my $self = shift;

  if ($#_ > 5) { carp "WARNING: Too many actual parameters!\n"; }
  if ($#_ < 5) { croak "ERROR: Not enough actual parameters!\n"; }

  for (@_) { _num($_); }

  my ($x, $y, $w, $h, $a1, $a2) = @_;

  my $xc = $x + $w / 2;
  my $yc = $y + $h / 2;

  my $pi = 3.1415926535;

  my $xr1 = $xc + int(100 * cos($a1*$pi/180));
  my $yr1 = $yc - int(100 * sin($a1*$pi/180));
  my $xr2 = $xc + int(100 * cos($a2*$pi/180));
  my $yr2 = $yc - int(100 * sin($a2*$pi/180));

  unless (_Arc($self->{dc}, $self->_xun2p($x), $self->_yun2p($y),
		     $self->_xun2p($x + $w), $self->_yun2p($y + $h),
		     $self->_xun2p($xr1), $self->_yun2p($yr1),
		     $self->_xun2p($xr2), $self->_yun2p($yr2))) {
    croak "ERROR: Cannot draw arc! ${\_GetLastError()}";
  }

  return 1;

}

#------------------------------------------------------------------------------#

sub ArcTo {

  my $self = shift;

  if ($#_ > 5) { carp "WARNING: Too many actual parameters!\n"; }
  if ($#_ < 5) { croak "ERROR: Not enough actual parameters!\n"; }

  for (@_) { _num($_); }

  my ($x, $y, $w, $h, $a1, $a2) = @_;

  my $xc = $x + $w / 2;
  my $yc = $y + $h / 2;

  my $pi=3.1415926535;

  my $xr1 = $xc + int(100 * cos($a1*$pi/180));
  my $yr1 = $yc - int(100 * sin($a1*$pi/180));
  my $xr2 = $xc + int(100 * cos($a2*$pi/180));
  my $yr2 = $yc - int(100 * sin($a2*$pi/180));

  unless (_ArcTo($self->{dc}, $self->_xun2p($x), $self->_yun2p($y),
		     $self->_xun2p($x + $w), $self->_yun2p($y + $h),
		     $self->_xun2p($xr1), $self->_yun2p($yr1),
		     $self->_xun2p($xr2), $self->_yun2p($yr2))) {
    croak "ERROR: Cannot draw arc! ${\_GetLastError()}";
  }

  return 1;

}

#------------------------------------------------------------------------------#

sub Line {

  my $self = shift;

  if ($#_ < 3) { croak "ERROR: Not enough actual parameters!\n"; }

  for (@_) { _num($_); }

  my (@args) = @_;
  my $cnt = 1;

  @args = map { $cnt++%2 ? $self->_yun2p($_) : $self->_xun2p($_) } @args;

  unless (_Polyline($self->{dc}, @args)) {
    croak "ERROR: Cannot draw line! ${\_GetLastError()}";
  }

  return 1;

}

#------------------------------------------------------------------------------#

sub LineTo {

  my $self = shift;

  if ($#_ < 1) { croak "ERROR: Not enough actual parameters!\n"; }

  for (@_) { _num($_); }

  my (@args) = @_;
  my ($cnt) = 1;

  @args = map { $cnt++%2 ? $self->_yun2p($_) : $self->_xun2p($_) } @args;

  unless (_PolylineTo($self->{dc}, @args)) {
    croak "ERROR: Cannot draw line! ${\_GetLastError()}";
  }

  return 1;

}

#------------------------------------------------------------------------------#

sub Poly {

  my $self = shift;

  if ($#_ < 5) { croak "ERROR: Not enough actual parameters!\n"; }

  for (@_) { _num($_); }

  my (@args) = @_;
  my ($cnt) = 1;

  @args = map { $cnt++%2 ? $self->_yun2p($_) : $self->_xun2p($_) } @args;

  unless (_Polygon($self->{dc}, @args)) {
    croak "ERROR: Cannot draw polygon! ${\_GetLastError()}";
  }

  return 1;

}

#------------------------------------------------------------------------------#

sub Bezier {

  my $self = shift;

  if ($#_ < 7) { croak "ERROR: Not enough actual parameters!\n"; }

  for (@_) { _num($_); }

  my (@args) = @_;
  my ($cnt) = 1;

  @args = map { $cnt++%2 ? $self->_yun2p($_) : $self->_xun2p($_) } @args;

  unless (_PolyBezier($self->{dc}, @args)) {
    croak "ERROR: Cannot draw polybezier! ${\_GetLastError()}";
  }

  return 1;

}

#------------------------------------------------------------------------------#

sub BezierTo {

  my $self = shift;

  if ($#_ < 5) { croak "ERROR: Not enough actual parameters!\n"; }

  for (@_) { _num($_); }

  my (@args) = @_;
  my ($cnt) = 1;

  @args = map { $cnt++%2 ? $self->_yun2p($_) : $self->_xun2p($_) } @args;

  unless (_PolyBezierTo($self->{dc}, @args)) {
    croak "ERROR: Cannot draw polybezier! ${\_GetLastError()}";
  }

  return 1;

}

#------------------------------------------------------------------------------#

sub PBegin {

  my $self = shift;

  if ($#_ > -1) { carp "WARNING: Too many actual parameters!\n"; }

  unless (_BeginPath($self->{dc})) {
    croak "ERROR: Cannot begin path! ${\_GetLastError()}";
  }

  return 1;

}

#------------------------------------------------------------------------------#

sub PAbort {

  my $self = shift;

  if ($#_ > -1) { carp "WARNING: Too many actual parameters!\n"; }

  unless (_AbortPath($self->{dc})) {
    croak "ERROR: Cannot abort path! ${\_GetLastError()}";
  }

  return 1;

}


#------------------------------------------------------------------------------#

sub PEnd {

  my $self = shift;

  if ($#_ > -1) { carp "WARNING: Too many actual parameters!\n"; }

  unless (_EndPath($self->{dc})) {
    croak "ERROR: Cannot end path! ${\_GetLastError()}";
  }

  return 1;

}

#------------------------------------------------------------------------------#

sub PDraw {

  my $self = shift;

  if ($#_ > -1) { carp "WARNING: Too many actual parameters!\n"; }

  unless (_StrokeAndFillPath($self->{dc})) {
    croak "ERROR: Cannot draw path! ${\_GetLastError()}";
  }

  return 1;

}

#------------------------------------------------------------------------------#

sub PClip {

  my $self = shift;

  if ($#_ > 0) { carp "WARNING: Too many actual parameters!\n"; }
  if ($#_ < 0) { croak "ERROR: Not enough actual parameters!\n"; }

  my $mode = shift;
  _num($mode);

  unless (_SelectClipPath($self->{dc}, $mode)) {
    croak "ERROR: Cannot create clip path! ${\_GetLastError()}";
  }

  return 1;

}

#------------------------------------------------------------------------------#

sub Image {

  my $self = shift;

  if (($#_ != 0) and ($#_ != 2) and ($#_ != 4)) { croak "WARNING: Wrong number parameters!\n"; }

  my ($width, $height) = (0, 0);

  if (($#_ == 2) or ($#_ == 4)) {

    my ($fileorref, $x, $y, $w, $h) = @_;

    if ($fileorref !~ /^-*\d+$/) {
      $fileorref = $self->Image($fileorref);
    }

    _GetEnhSize($self->{dc}, $fileorref, $width, $height);
    $width = $self->_xp2un($width);
    $height = $self->_yp2un($height);

    if ((!defined($w)) or ($w == 0)) { $w = $width; }
    if ((!defined($h)) or ($h == 0)) { $h = $height; }

    unless (_PlayEnhMetaFile($self->{dc}, $fileorref, $self->_xun2p($x), $self->_yun2p($y), $self->_xun2p($x + $w), $self->_yun2p($y + $h))) {
      croak "ERROR: Cannot display metafile! ${\_GetLastError()}";
    }

    return wantarray ? ($fileorref, $width, $height) : $fileorref;

  } else {

    my $file = shift;

    if (defined($self->{imagef}->{$file})) {
      _GetEnhSize($self->{dc}, $self->{imagef}->{$file}, $width, $height);
      $width = $self->_xp2un($width);
      $height = $self->_yp2un($height);
      return wantarray ? ($self->{imagef}->{$file}, $width, $height) : $self->{imagef}->{$file};
    }

    my $fref;

    if ($file =~ /.emf$/) {
      $fref = _GetEnhMetaFile($file);
      unless ($fref) {
        croak "ERROR: Cannot load metafile! ${\_GetLastError()}";
      }
    } elsif ($file =~ /.wmf$/) {
      $fref = _GetWinMetaFile($self->{dc}, $file);
      unless ($fref) {
        croak "ERROR: Cannot load metafile! ${\_GetLastError()}";
      }
    } else {

      $fref = _LoadBitmap($self->{dc}, $file, FIF_UNKNOWN);

      unless ($fref) {
        if ($file =~ /\.BMP$/i) {
          $fref = _LoadBitmap($self->{dc}, $file, FIF_BMP);
        } elsif ($file =~ /\.CUT$/i) {
          $fref = _LoadBitmap($self->{dc}, $file, FIF_CUT);
        } elsif ($file =~ /\.ICO$/i) {
          $fref = _LoadBitmap($self->{dc}, $file, FIF_ICO);
        } elsif ($file =~ /\.JPG$|\.JPEG$/i) {
          $fref = _LoadBitmap($self->{dc}, $file, FIF_JPEG);
        } elsif ($file =~ /\.JNG$/i) {
          $fref = _LoadBitmap($self->{dc}, $file, FIF_JNG);
        } elsif ($file =~ /\.KOA$/i) {
          $fref = _LoadBitmap($self->{dc}, $file, FIF_KOALA);
        } elsif ($file =~ /\.LBM$|\.IFF$/i) {
          $fref = _LoadBitmap($self->{dc}, $file, FIF_LBM);
        } elsif ($file =~ /\.MNG$/i) {
          $fref = _LoadBitmap($self->{dc}, $file, FIF_MNG);
        } elsif ($file =~ /\.PBM$/i) {
          $fref = _LoadBitmap($self->{dc}, $file, FIF_PBM);
          unless ($fref) {
            $fref = _LoadBitmap($self->{dc}, $file, FIF_PBMRAW);
          }
        } elsif ($file =~ /\.PCD$/i) {
          $fref = _LoadBitmap($self->{dc}, $file, FIF_PCD);
        } elsif ($file =~ /\.PCX$/i) {
          $fref = _LoadBitmap($self->{dc}, $file, FIF_PCX);
        } elsif ($file =~ /\.PGM$/i) {
          $fref = _LoadBitmap($self->{dc}, $file, FIF_PGM);
          unless ($fref) {
            $fref = _LoadBitmap($self->{dc}, $file, FIF_PGMRAW);
          }
        } elsif ($file =~ /\.PNG$/i) {
          $fref = _LoadBitmap($self->{dc}, $file, FIF_PNG);
        } elsif ($file =~ /\.PPM$/i) {
          $fref = _LoadBitmap($self->{dc}, $file, FIF_PPM);
          unless ($fref) {
            $fref = _LoadBitmap($self->{dc}, $file, FIF_PPMRAW);
          }
        } elsif ($file =~ /\.RAS$/i) {
          $fref = _LoadBitmap($self->{dc}, $file, FIF_RAS);
        } elsif ($file =~ /\.TGA$/i) {
          $fref = _LoadBitmap($self->{dc}, $file, FIF_TARGA);
        } elsif ($file =~ /\.TIF$|\.TIFF$/i) {
          $fref = _LoadBitmap($self->{dc}, $file, FIF_TIFF);
        } elsif ($file =~ /\.WBMP$/i) {
          $fref = _LoadBitmap($self->{dc}, $file, FIF_WBMP);
        } elsif ($file =~ /\.PSD$/i) {
          $fref = _LoadBitmap($self->{dc}, $file, FIF_PSD);
        }
      }

      unless ($fref) {
        croak "ERROR: Cannot load bitmap! ${\_GetLastError()}";
      }

    }

    $self->{imager}->{$fref} = $file;
    $self->{imagef}->{$file} = $fref;

    _GetEnhSize($self->{dc}, $fref, $width, $height);
    $width = $self->_xp2un($width);
    $height = $self->_yp2un($height);
    return wantarray ? ($fref, $width, $height) : $fref;

  }

}

#------------------------------------------------------------------------------#

sub Caps {

  my $self = shift;

  if ($#_ < 0) { croak "ERROR: Not enough actual parameters!\n"; }
  if ($#_ > 0) { carp "WARNING: Too many actual parameters!\n"; }

  my $index = shift;
  _num($index);

  return _GetDeviceCaps($self->{dc}, $index);

}

#------------------------------------------------------------------------------#

sub Close {

  my $self = shift;

  if ($#_ > 0) { carp "WARNING: Too many actual parameters!\n"; }

  if ($#_ == 0) {
    if ($_[0] =~ /^-*\d+$/) {
      if (_DeleteEnhMetaFile($_[0])) {
        delete $self->{imagef}->{$self->{imager}->{$_[0]}};
        delete $self->{imager}->{$_[0]};
      }
    } else {
      if (my $file = _DeleteEnhMetaFile($self->{imagef}->{$_[0]})) {
        delete $self->{imagef}->{$_[0]};
        delete $self->{imager}->{$file};
      }
    }
  } else {

    for (keys %{$self->{obj}}) {
     _DeleteObject($self->{obj}->{$_});
    } 

    for (keys %{$self->{imager}}) {
      _DeleteEnhMetaFile($_);
      delete $self->{imagef}->{$self->{imager}->{$_}};
      delete $self->{imager}->{$_};
    }

    if ($self->{dc}) {
      _EndPage($self->{dc});
      if (_EndDoc($self->{dc}) > 0) {
        _pdf();
       }
      _DeleteDC($self->{dc});
    }
    $self->{dc} = 0;

  }

  return 1;

}

#------------------------------------------------------------------------------#

sub DESTROY {

  my $self = shift;

  if ($self->{dc}) {
    _AbortDoc($self->{dc});
    $self->Close();
  }

  return 1;

}

#------------------------------------------------------------------------------#

1;

__END__

=head1 NAME

Win32::Printer - Perl extension for Win32 printing

=head1 SYNOPSIS

 use Win32::Printer;

 my $dc = new Win32::Printer(
				papersize	=> A4,
				dialog		=> NOSELECTION,
				description	=> 'Hello, Mars!',
				unit		=> 'mm'
			    );

 my $font = $dc->Font('Arial Bold', 24);
 $dc->Font($font);
 $dc->Color(0, 0, 255);
 $dc->Write("Hello, Mars!", 10, 10);

 $dc->Brush(128, 0, 0);
 $dc->Pen(4, 0, 0, 128);
 $dc->Ellipse(10, 25, 50, 50);

 $dc->Close();

=head1 ABSTRACT

Win32 GDI graphical printing

=head1 INSTALLATION

=head2 Binary instalation

B<1.> Download binary distribution of the module from I<http://www.wasx.net>.

B<2.> Unzip distribution file and copy content to appropriate directories.

B<3.> Enjoy it ;)

=head2 Source installation

B<1.> Make sure you have a C/C++ compiler and you're running Win32.

B<2.> For VC++ 6.0 or VC++ .NET do the following (others not tested):

  > nmake
  > nmake test
  > nmake install

B<3.> For bitmap support, copy I<FreeImage.dll> somewhere in your system path.
You may get this library form I<http://sourceforge.net>. B<NOTE:> I<FreeImage>
library is needed for the second test!

B<4.> For PDF support, install I<Ghostscript>. You may get this PostScript
interpreter form I<http://sourceforge.net>. B<NOTE:> I<Ghostscript> is needed
for the third test!

B<5.> Enjoy it ;)

=head1 DESCRIPTION

B<All symbolic constants are exported by default!!!>

=head2 new

 new Win32::Printer ( [ parameter => value, ... ] );

The B<new> class method creates printer object, starts new document (a print
job), returns printer object and changes B<$dc-E<gt>{flags}> variable.
B<$dc-E<gt>{flags}> contains modified printer dialog flags. B<new> also sets
B<$dc-E<gt>{copies}>, B<$dc-E<gt>{collate}>, B<$dc-E<gt>{maxp}> and
B<$dc-E<gt>{minp}>, B<$dc-E<gt>{xres}>, B<$dc-E<gt>{yres}>, B<$dc-E<gt>{xsize}>,
B<$dc-E<gt>{ysize}> variables.

  $dc->{xres};	# X resolution
  $dc->{yres};	# Y resolution
  $dc->{xsize};	# X size in chosen units
  $dc->{ysize};	# Y size in chosen units

B<NOTE!> Print job is automatically aborted if print job is not ended by
B<L</End>> or B<L</Close>> methods or if an error occurs!

The B<new> class method sets the following optional printer object and document
parameters:

=over

=item * printer

If both B<printer> and B<dialog> attributes omitted- systems B<default printer>
is used. Value of attribute is also used for B<dialog> initialisation.

Set printer's "friendly" name e.g. "HP LaserJet 8500" or network printer's UNC
e.g. "\\\\server\\printer".

=item * dc

If B<dc> is not zero or null- returns only device context without starting the
document and new page.

=item * file

Set B<file> attribute to save printer drivers output into the file specified by
value of attribute. B<Note:> Specified file will not be overwritten- it's name
will be changed to B<file_name(1)... file_name(n)> to avoid overwriting.

=item * pdf

Set this attribute if You want to convert PostScript printer drivers output (see
B<file> attribute) to PDF format. B<WARNING:> This feature needs installed
I<Ghostscript> and atleast one PostScript printer driver. Use this attribute
with B<file> attribute.

Set attribute value to:

   0	- ignore Ghostscript output;
   1	- redirect Ghostscript output to STDOUT;
 other	- redirect Ghostscript output to log file;

=item * dialog

If both B<printer> and B<dialog> attributes omitted- systems B<default printer>
is used.

Printer dialog settings. You may use the combination of the following flags
(B<$dc-E<gt>{flags}> contains modified printer dialog flags):

  ALLPAGES			= 0x000000

The default flag that indicates that the B<All> radio button is initially
selected. This flag is used as a placeholder to indicate that the PAGENUMS and
SELECTION flags are not specified.

  SELECTION			= 0x000001

If this flag is set, the B<Selection> radio button is selected. 
If neither PAGENUMS nor SELECTION is set, the B<All> radio button is selected. 

  PAGENUMS			= 0x000002

If this flag is set, the Pages radio button is selected. 
If this flag is set when the B<new> method returns, the B<$dc-E<gt>{maxp}> and
B<$dc-E<gt>{minp}> variables indicate the starting and ending pages specified by
the user.

  NOSELECTION			= 0x000004

Disables the B<Selection> radio button.

  NOPAGENUMS			= 0x000008

Disables the B<Pages> radio button and the associated edit controls.

  PRINTTOFILE			= 0x000020

If this flag is set, the B<Print to File> check box is selected.

  PRINTSETUP			= 0x000040

Causes the system to display the B<Print Setup> dialog box rather than the
B<Print> dialog box.

  NOWARNING			= 0x000080

Prevents the warning message from being displayed when there is no default
printer.

  USEDEVMODECOPIES		= 0x040000

Same as USEDEVMODECOPIESANDCOLLATE

  USEDEVMODECOPIESANDCOLLATE	= 0x040000

This flag indicates whether your application supports multiple copies and
collation. Set this flag on input to indicate that your application does not
support multiple copies and collation. In this case, the B<$dc-E<gt>{copies}>
member always returns 1, and B<$dc-E<gt>{collate}> member always returns 0. 
If this flag is not set, the application is responsible for printing and
collating multiple copies. In this case, the B<$dc-E<gt>{copies}> member indicates
the number of copies the user wants to print, and the B<$dc-E<gt>{collate}> member
indicates whether the user wants collation.
If this flag is set and the printer driver does not support multiple copies, the
B<Copies> edit control is disabled. Similarly, if this flag is set and the
printer driver does not support collation, the B<Collate> checkbox is disabled.
B<This feature may not work correctly with all printer drivers!>

  DISABLEPRINTTOFILE		= 0x080000

Disables the B<Print to File> check box.

  HIDEPRINTTOFILE		= 0x100000

Hides the B<Print to File> check box.

  NONETWORKBUTTON		= 0x200000

Hides and disables the B<Network> button.

=item * minp

Minor page number in printer dialog (minimal possible value).

=item * maxp

Major page number in printer dialog (maximal possible value).

=item * orientation

=item * copies

Initial number of document copies to print.
See also USEDEVMODECOPIESANDCOLLATE.

=item * collate

If this flag is set, the B<Collate> check box is checked.
See also USEDEVMODECOPIESANDCOLLATE.

Page orientation (portrait by default).

  PORTRAIT			= 1
  LANDSCAPE			= 2

=item * papersize

Defined paper sizes:

  LETTER			= 1
  LETTERSMALL			= 2
  TABLOID			= 3
  LEDGER			= 4
  LEGAL				= 5
  STATEMENT			= 6
  EXECUTIVE			= 7
  A3				= 8
  A4				= 9
  A4SMALL			= 10
  A5				= 11
  B4				= 12
  B5				= 13
  FOLIO				= 14
  QUARTO			= 15
  IN_10X14			= 16
  IN_11X17			= 17
  NOTE				= 18
  ENV_9				= 19
  ENV_10			= 20
  ENV_11			= 21
  ENV_12			= 22
  ENV_14			= 23
  CSHEET			= 24
  DSHEET			= 25
  ESHEET			= 26
  ENV_DL			= 27
  ENV_C5			= 28
  ENV_C3			= 29
  ENV_C4			= 30
  ENV_C6			= 31
  ENV_C65			= 32
  ENV_B4			= 33
  ENV_B5			= 34
  ENV_B6			= 35
  ENV_ITALY			= 36
  ENV_MONARCH			= 37
  ENV_PERSONAL			= 38
  FANFOLD_US			= 39
  FANFOLD_STD_GERMAN		= 40
  FANFOLD_LGL_GERMAN		= 41
  ISO_B4			= 42
  JAPANESE_POSTCARD		= 43
  IN_9X11			= 44
  IN_10X11			= 45
  IN_15X11			= 46
  ENV_INVITE			= 47
  RESERVED_48			= 48
  RESERVED_49			= 49
  LETTER_EXTRA			= 50
  LEGAL_EXTRA			= 51
  TABLOID_EXTRA			= 52
  A4_EXTRA			= 53
  LETTER_TRANSVERSE		= 54
  A4_TRANSVERSE			= 55
  LETTER_EXTRA_TRANSVERSE	= 56
  A_PLUS			= 57
  B_PLUS			= 58
  LETTER_PLUS			= 59
  A4_PLUS			= 60
  A5_TRANSVERSE			= 61
  B5_TRANSVERSE			= 62
  A3_EXTRA			= 63
  A5_EXTRA			= 64
  B5_EXTRA			= 65
  A2				= 66
  A3_TRANSVERSE			= 67
  A3_EXTRA_TRANSVERSE		= 68

=item * duplex

Duplexing mode:

  SIMPLEX			= 1
  VERTICAL			= 2
  HORIZONTAL			= 3

=item * description

Document description. Default is "Printer".

=item * source

Specifies the paper source.

  BIN_ONLYONE			= 1
  BIN_LOWER			= 2
  BIN_MIDDLE			= 3
  BIN_MANUAL			= 4
  BIN_ENVELOPE			= 5
  BIN_ENVMANUAL			= 6
  BIN_AUTO			= 7
  BIN_TRACTOR			= 8
  BIN_SMALLFMT			= 9
  BIN_LARGEFMT			= 10
  BIN_LARGECAPACITY		= 11
  BIN_CASSETTE			= 14
  BIN_FORMSOURCE		= 15

=item * color

Switches between color and monochrome on color printers. Following are the
possible values: 

  MONOCHROME 			= 1
  COLOR				= 2

=item * unit

Document units (inches by default).
Specified unit is used for all coordinates and sizes, except for
L<font sizes|/Font> and L<pen widths|/Pen>.

You may use strings:

  'in' - inches
  'mm' - millimeters
  'cm' - centimeters
  'pt' - points (in/72)

Or unit ratio according to:

  ratio = in / unit

  Example: 2.5409836 cm = 1 in

=back

=head2 Abort

  $dc->Abort();

The B<Abort> method stops the current print job and erases everything drawn
since the last call to the B<L</Start>> method.

See also L</Start>, L</Next> and L</End>.

=head2 Arc

  $dc->Arc($x, $y, $width, $height, $start_angle, $end_angle2);

The B<Arc> method draws an elliptical arc.
B<$x, $y> sets the upper-left corner coordinates of bounding rectangle.
B<$width, $height> sets the width and height of bounding rectangle.
B<$start_angle, $end_angle2> sets the starting and ending angle of the arc
according to the center of bounding rectangle. The current point is not updated.

See also L</ArcTo>, L</Ellipse>, L</Chord> and L</Pie>.

=head2 ArcTo

  $dc->ArcTo($x, $y, $width, $height, $start_angle, $end_angle2);

The B<ArcTo> method draws an elliptical arc.
B<$x, $y> sets the upper-left corner coordinates of bounding rectangle.
B<$width, $height> sets the width and height of bounding rectangle.
B<$start_angle, $end_angle2> sets the starting and ending angle of the arc
according to the center of bounding rectangle. The current point is updated.

See also L</Move>, L</Arc>, L</Ellipse>, L</Chord> and L</Pie>.

=head2 Bezier

  $dc->Bezier(@points);

The B<Polybezier> method draws cubic Bézier curves by using the endpoints and
control points specified by the B<@points> array. The first curve is drawn from
the first point to the fourth point by using the second and third points as
control points. Each subsequent curve in the sequence needs exactly three more
points: the ending point of the previous curve is used as the starting point,
the next two points in the sequence are control points, and the third is the
ending point. The current point is not updated.

See also L</BezierTo>.

=head2 BezierTo

  $dc->Bezier(@points);

The B<BezierTo> method draws one or more Bézier curves.
This method draws cubic Bézier curves by using the control points specified by
the B<@points> array. The first curve is drawn from the current position to the
third point by using the first two points as control points. For each subsequent
curve, the method needs exactly three more points, and uses the ending point
of the previous curve as the starting point for the next. The current point is
updated.

See also L</Bezier> and L</Move>.

=head2 Brush

  $dc->Brush([$r, $g, $b, [$hatch]]);

The B<Brush> method creates a logical brush that has the specified style
and optional hatch style.
If no parameters specified, creates transparent brush.

You may use the following brush hatch styles:

  HS_HORIZONTAL			= 0

Horizontal hatch.

  HS_VERTICAL			= 1

Vertical hatch.

  HS_FDIAGONAL			= 2

A 45-degree downward, left-to-right hatch.

  HS_BDIAGONAL			= 3

A 45-degree upward, left-to-right hatch.

  HS_CROSS			= 4

Horizontal and vertical cross-hatch 

  HS_DIAGCROSS			= 5

45-degree crosshatch.

See also L</Pen>.

=head2 Caps

  $dc->Caps($index);

The B<Caps> method retrieves device-specific information about a specified
device.

B<$index> specifies the item to return. This parameter can be one of the
following values:

  DRIVERVERSION

The device driver version.

  HORZSIZE

Width, in millimeters, of the physical screen.

  VERTSIZE

Height, in millimeters, of the physical screen.

  HORZRES

Width, in pixels, of the screen.

  VERTRES

Height, in raster lines, of the screen.

  LOGPIXELSX

Number of pixels per logical inch along the screen width.

  LOGPIXELSY

Number of pixels per logical inch along the screen height.

  BITSPIXEL

Number of adjacent color bits for each pixel.

  PLANES

Number of color planes.

  NUMBRUSHES

Number of device-specific brushes.

  NUMPENS

Number of device-specific pens.

  NUMFONTS

Number of device-specific fonts.

  NUMCOLORS

Number of entries in the device's color table, if the device has a color depth
of no more than 8 bits per pixel. For devices with greater color depths, -1 is
returned.

  ASPECTX

Relative width of a device pixel used for line drawing.

  ASPECTY

Relative height of a device pixel used for line drawing.

  ASPECTXY

Diagonal width of the device pixel used for line drawing.

  CLIPCAPS

Flag that indicates the clipping capabilities of the device. If the device can
clip to a rectangle, it is 1. Otherwise, it is 0.

  SIZEPALETTE

Number of entries in the system palette. This index is valid only if the device
driver sets the RC_PALETTE bit in the RASTERCAPS index and is available only if
the driver is compatible with 16-bit Windows.

  NUMRESERVED

Number of reserved entries in the system palette. This index is valid only if
the device driver sets the RC_PALETTE bit in the RASTERCAPS index and is
available only if the driver is compatible with 16-bit Windows.

  COLORRES

Actual color resolution of the device, in bits per pixel. This index is valid
only if the device driver sets the RC_PALETTE bit in the RASTERCAPS index and
is available only if the driver is compatible with 16-bit Windows.

  PHYSICALWIDTH

For printing devices: the width of the physical page, in device units. For
example, a printer set to print at 600 dpi on 8.5"x11" paper has a physical
width value of 5100 device units. Note that the physical page is almost always
greater than the printable area of the page, and never smaller.

  PHYSICALHEIGHT

For printing devices: the height of the physical page, in device units. For
example, a printer set to print at 600 dpi on 8.5"x11" paper has a physical
height value of 6600 device units. Note that the physical page is almost always
greater than the printable area of the page, and never smaller.

  PHYSICALOFFSETX

For printing devices: the distance from the left edge of the physical page to
the left edge of the printable area, in device units. For example, a printer
set to print at 600 dpi on 8.5"x11" paper, that cannot print on the leftmost
0.25" of paper, has a horizontal physical offset of 150 device units.

  PHYSICALOFFSETY

For printing devices: the distance from the top edge of the physical page to the
top edge of the printable area, in device units. For example, a printer set to
print at 600 dpi on 8.5"x11" paper, that cannot print on the topmost 0.5" of
paper, has a vertical physical offset of 300 device units.

  SCALINGFACTORX

Scaling factor for the x-axis of the printer.

  SCALINGFACTORY

Scaling factor for the y-axis of the printer. 

  RASTERCAPS

Value that indicates the raster capabilities of the device, as shown in the
following table:

    0x0001	Capable of transferring bitmaps.
    0x0002	Requires banding support.
    0x0004	Capable of scaling.
    0x0008	Capable of supporting bitmaps larger than 64K.
    0x0010	Capable of supporting features of 16-bit Windows 2.0.
    0x0080	Capable of supporting the SetDIBits and GetDIBits functions
		(Win API).
    0x0100	Specifies a palette-based device.
    0x0200	Capable of supporting the SetDIBitsToDevice function (Win API).
    0x0800	Capable of performing the StretchBlt function (Win API).
    0x1000	Capable of performing flood fills.
    0x2000	Capable of performing the StretchDIBits function (Win API).

  CURVECAPS

Value that indicates the curve capabilities of the device, as shown in the
following table:

    0		Device does not support curves.
    1		Device can draw circles.
    2		Device can draw pie wedges.
    4		Device can draw chord arcs.
    8		Device can draw ellipses.
    16		Device can draw wide borders.
    32		Device can draw styled borders.
    64		Device can draw borders that are wide and styled.
    128		Device can draw interiors.
    256		Device can draw rounded rectangles.

  LINECAPS

Value that indicates the line capabilities of the device, as shown in the
following table:

    0		Device does not support lines.
    2		Device can draw a polyline.
    4		Device can draw a marker.
    8		Device can draw multiple markers.
    16		Device can draw wide lines.
    32		Device can draw styled lines.
    64		Device can draw lines that are wide and styled.
    128		Device can draw interiors.

  POLYGONALCAPS

Value that indicates the polygon capabilities of the device, as shown in the
following table:

    0		Device does not support polygons.
    1		Device can draw alternate-fill polygons.
    2		Device can draw rectangles.
    4		Device can draw winding-fill polygons.
    8		Device can draw a single scanline.
    16		Device can draw wide borders.
    32		Device can draw styled borders.
    64		Device can draw borders that are wide and styled.
    128		Device can draw interiors.

  TEXTCAPS

Value that indicates the text capabilities of the device, as shown in the
following table:

    0x0001	Device is capable of character output precision.
    0x0002	Device is capable of stroke output precision.
    0x0004	Device is capable of stroke clip precision.
    0x0008	Device is capable of 90-degree character rotation.
    0x0010	Device is capable of any character rotation.
    0x0020	Device can scale independently in the x- and y-directions.
    0x0040	Device is capable of doubled character for scaling.
    0x0080	Device uses integer multiples only for character scaling.
    0x0100	Device uses any multiples for exact character scaling.
    0x0200	Device can draw double-weight characters.
    0x0400	Device can italicize.
    0x0800	Device can underline.
    0x1000	Device can draw strikeouts.
    0x2000	Device can draw raster fonts.
    0x4000	Device can draw vector fonts.

See also L</new>.

=head2 Chord

  $dc->Chord($x, $y, $width, $height, $start_angle, $end_angle2);

The B<Chord> method draws a chord (a region bounded by the intersection of an
ellipse and a line segment, called a "secant"). The chord is outlined by using
the current pen and filled by using the current brush. 
B<$x, $y> sets the upper-left corner coordinates of bounding rectangle.
B<$width, $height> sets the width and height of bounding rectangle.
B<$start_angle, $end_angle2> sets the starting and ending angle of the chord
according to the center of bounding rectangle.

See also L</Ellipse>, L</Pie>, L</Arc> and L</ArcTo>.

=head2 Close

  $dc->Close([$image_handle_or_path]);

The B<Close> method finishes current print job, closes all open handles and
frees memory.

If optional image handle or path is provided-  closes only that image!

See also L</new> and L</Image>.

=head2 Color

  $dc->Color($b, $g, $b);

The B<Color> method sets the text color to the specified color.

See also L</Write> and L</Font>.

=head2 Ellipse

  $dc->Ellipse($x, $y, $width, $height);

The B<Ellipse> method draws an ellipse. The center of the ellipse is the
center of the specified bounding rectangle. The ellipse is outlined by using the
current pen and is filled by using the current brush. B<$x, $y> sets the
upper-left corner coordinates of bounding rectangle. B<$width, $height> sets the
width and height of bounding rectangle.

See also L</Pie>, L</Chord>, L</Arc> and L</ArcTo>.

=head2 End

  $dc->End();

The B<End> method finishes a current print job.

See also L</Start>, L</Next>, L</Abort> and L</Page>.

=head2 Fill

  $dc->Fill($mode);

The B<Fill> method sets the polygon fill mode for methods that fill
polygons.

  ALTERNATE			= 1

Selects alternate mode (fills the area between odd-numbered and even-numbered
polygon sides on each scan line).

  WINDING			= 2

Selects winding mode (fills any region with a nonzero winding value).

See also L</PDraw> and L</Poly>.

=head2 Font

  $font_handle = $dc->Font([$face, [$size, [$angle, [$charset]]]]);

B<or>

  $dc->Font($font_handle);

The B<Font> method creates and selects a logical font that has specific
characteristics and returns handle to it B<or> selects given font by it's
handle. Fontsize is set in pts.

Defaults to:

  $face = 'Courier';	# fontface
  $size = 10;		# fontsize
  $angle = 0;		# text direction angle in degrees
  $charset = DEFAULT;	# character set code

B<$face> may include any combination of the following attributes: B<bold italic
underline strike>.

Defined character set constants:

  ANSI				= 0
  DEFAULT			= 1
  SYMBOL			= 2
  MAC				= 77
  SHIFTJIS			= 128
  HANGEUL			= 129
  JOHAB				= 130
  GB2312			= 134
  CHINESEBIG5			= 136
  GREEK				= 161
  TURKISH			= 162
  VIETNAMESE			= 163
  HEBREW			= 177
  ARABIC			= 178
  BALTIC			= 186
  RUSSIAN			= 204
  THAI				= 222
  EASTEUROPE			= 238
  OEM				= 255

See also L</Write>, and L</Color>.

=head2 Image

  $image_handle = $dc->Image($filename);
  ($image_handle, $original_width, $original_height) = $dc->Image($filename);

B<or>

  $image_handle = $dc->Image($filename, $x, $y, $width, $height);
  ($image_handle, $original_width, $original_height) = $dc->Image($filename, $x, $y, $width, $height);
  $dc->Image($image_handle, $x, $y, $width, $height);

The B<Image> method loads an image file into memory and returns a handle
to it or draws it by it's filename or handle. B<$x, $y> specifies coordinates of
the image upper-left corner. B<$width, $height> specifies the width and height
of image on the paper. Once loaded by image path- image is cached in to memory
and it may be referenced by it's path.

In second case if signed integer is given- method assumes it's a handle!

In array context also returns original image width an d height B<$original_width, $original_height>.

Natively it supports B<EMF> and B<WMF> format files.
B<BMP, CUT, ICO, JPEG, JNG, KOALA, LBM, IFF, MNG, PBM, PBMRAW, PCD, PCX, PGM,
PGMRAW, PNG, PPM, PPMRAW, PSD, RAS, TARGA, TIFF, WBMP> bitmap formats are
handled via L<FreeImage library|/INSTALLATION>.
After usage, you should use B<L</Close>> to unload image from memory and destroy
a handle.

See also L</Close>.

=head2 Line

  $dc->Line(@endpoints);

The B<Line> method draws a series of line segments by connecting the
points in the specified array. The current point is not updated.

See also L</LineTo>.

=head2 LineTo

  $dc->LineTo(@endpoints);

The B<LineTo> method draws a series of line segments by connecting the
points in the specified array. The current point is updated.

See also L</Line>.

=head2 Move

  $dc->Move();

The B<Move> method updates the current position to the specified point.

See also L</ArcTo>, L</LineTo> and L</BezierTo>.

=head2 Next

  $dc->Next([$description]);

The B<Next> method ends and starts new print job. Equivalent for:

  $dc->End();
  $dc->Start([$description]);

Default description - "Printer".

See also L</Start>, L</End>, L</Abort> and L</Page>.

=head2 Page

  $dc->Page();

The B<Page> method starts new page.

See also L</Start>, L</Next> and L</End>.

=head2 PAbort

  $dc->PAbort();

The B<PAbort> method closes and discards any paths.


=head2 PBegin

  $dc->PBegin();

The B<PBegin> method opens a path bracket.

See also L</PClip>, L</PDraw>, L</PEnd> and L</PAbort>.

=head2 PClip

  $dc->PClip($mode);

The B<PClip> method selects the current path as a clipping region,
combining the new region with any existing clipping region by using the
specified mode.

Where B<$mode> is one of the following:

  CR_AND			= 1

The new clipping region includes the intersection (overlapping areas) of the
current clipping region and the current path.

  CR_OR				= 2

The new clipping region is the current path.

  CR_XOR			= 3

The new clipping region includes the areas of the current clipping region with
those of the current path excluded.

  CR_DIFF			= 4

The new clipping region includes the union (combined areas) of the current
clipping region and the current path.

  CR_COPY			= 5

The new clipping region includes the union of the current clipping region and
the current path but without the overlapping areas.

See also L</PBegin>, L</PDraw>, L</PEnd> and L</PAbort>.

=head2 PDraw

  $dc->PDraw();

The B<PDraw> method closes any open figures in a path, strokes the outline
of the path by using the current pen, and fills its interior by using the
current brush and fill mode.

See also L</PBegin>, L</PClip>, L</PEnd>, L</PAbort> and L</Fill>.

=head2 PEnd

  $dc->PEnd();

The B<PEnd> method closes a path bracket and selects the path defined by
the bracket.

See also L</PBegin>, L</PClip>, L</PDraw> and L</PAbort>.

=head2 Pen

  $dc->Pen([$width, $r, $g, $b, [$style]]);

The B<Pen> method creates a logical pen that has the specified style,
width, and color. The pen can subsequently be used to draw lines and curves.
Pen width is set in pts regardless of unit attribute in B<L</new>> constructor
or whatever is set by B<L</Unit>> method.
Using dashed or dotted styles will set the pen width to 1 px!
If no parameters specified, creates transparent pen.

You may use the following pen styles:

  PS_DASH			= 0x00000001

Pen is dashed.

  PS_DOT			= 0x00000002

Pen is dotted.

  PS_DASHDOT			= 0x00000003

Pen has alternating dashes and dots.

  PS_DASHDOTDOT			= 0x00000004

Pen has alternating dashes and double dots.

  PS_NULL			= 0x00000005

Pen is invisible. 

  PS_INSIDEFRAME		= 0x00000006

Pen is solid. When this pen is used in drawing method that takes a bounding
rectangle, the dimensions of the figure are shrunk so that it fits entirely in
the bounding rectangle, taking into account the width of the pen.

  PS_SOLID			= 0x00010000

Pen is solid (default).

  PS_JOIN_ROUND			= 0x00010000

Joins are round (default).

  PS_ENDCAP_ROUND		= 0x00010000

End caps are round (default).

  PS_ENDCAP_SQUARE		= 0x00010100

End caps are square.

  PS_ENDCAP_FLAT		= 0x00010200

End caps are flat.

  PS_JOIN_BEVEL			= 0x00011000

Joins are beveled.

  PS_JOIN_MITER			= 0x00012000

Joins are mitered.

See also L</Brush>.

=head2 Pie

  $dc->Pie($x, $y, $width, $height, $start_angle, $end_angle2);

The B<Pie> method draws a pie-shaped wedge bounded by the intersection of an
ellipse and two radials. The pie is outlined by using the current pen and filled
by using the current brush. 
B<$x, $y> sets the upper-left corner coordinates of bounding rectangle.
B<$width, $height> sets the width and height of bounding rectangle.
B<$start_angle, $end_angle2> sets the starting and ending angle of the pie
according to the center of bounding rectangle.

See also L</Ellipse>, L</Chord>, L</Arc> and L</ArcTo>.

=head2 Poly

  $dc->Poly(@vertices);

The B<Poly> method draws a polygon consisting of two or more vertices
connected by straight lines. The polygon is outlined by using the current pen
and filled by using the current brush and polygon fill mode. 

See also L</Rect> and L</Fill>.

=head2 Rect

  $dc->Rect($x, $y, $width, $height, [$ellipse_width, $ellipse_height]);

The B<Rect> method draws a rectangle or rounded rectangle. The rectangle
is outlined by using the current pen and filled by using the current brush.
B<$x, $y> sets the upper-left corner coordinates of rectangle. B<$width,
$height> sets the width and height of rectangle. Optional parameters
B<$ellipse_width, $ellipse_height> sets the width and height of ellipse used to
draw rounded corners.

See also L</Poly>.

=head2 Space

  $dc->Space($eM11, $eM12, $eM21, $eM22, $eDx, $eDy);

The B<Space> method sets a two-dimensional linear transformation
between world space and page space. This transformation can be used to scale,
rotate, shear, or translate graphics output. Transformation on the next page is
reset to default. Default page origin is upper-left corner, B<x> from left to
right and B<y> from top to bottom.

  0
  ------- x
  |
  |
  | y

For any coordinates B<(x, y)> in world space, the transformed coordinates in
page space B<(x', y')> can be determined by the following algorithm: 

  x' = x * eM11 + y * eM21 + eDx, 
  y' = x * eM12 + y * eM22 + eDy, 

where the transformation matrix is represented by the following: 

  | eM11 eM12 0 |
  | eM21 eM22 0 |
  | eDx  eDy  1 |

=head2 Start

  $dc->Start([$description])

The B<Start> method starts a print job.
Default description - "Printer".

B<NOTE!> Print job is automatically aborted if print job is not ended by
B<L</End>> or B<L</Close>> methods or if an error occurs!

See also L</Next>, L</End>, L</Abort> and L</Page>.

=head2 Unit

  $dc->Unit([$unit]);

The B<Unit> method sets or gets current unit ratio.

Specified unit is used for all coordinates and sizes, except for
L<font sizes|/Font> and L<pen widths|/Pen>.

You may use strings:

  'in' - inches
  'mm' - millimeters
  'cm' - centimeters
  'pt' - points (in / 72)

Or unit ratio according to:

  ratio = in / unit

  Example: 2.5409836 cm = 1 in

=head2 Write

  # String mode (SM):
  $dc->Write($text, $x, $y, [$format, [$just_width]]);

  # Draw mode (DM):
  $dc->Write($text, $x, $y, $width, $height, [$format, [$tab_stop]]);

B<SM:>
The B<Write> method B<string mode> writes a character string at the specified
location, using the currently selected font, text color and alignment.

B<DM:>
The B<Write> method B<draw mode> draws formatted text in the specified rectangle.
In array context method returns array containing B<($width, $height, $length,
$text)>. B<$height> is returned in scalar context. B<$length> receives the
number of characters processed by B<Write>, including white-space characters.
See CALCRECT and MODIFYSTRING flags. Optional B<$tab_stop> parameter
specifies the number of average character widths per tab stop.

Optional text format flags:

  NOUPDATECP			= 0x00000000 (SM)

The current position is not updated after each text output call. The reference
point is passed to the text output method.

  TOP				= 0x00000000 (SM & DM)

B<SL:> The reference point will be on the top edge of the bounding rectangle.

B<ML:> Top justifies text. This value must be combined with SINGLELINE.

  LEFT				= 0x00000000 (SM & DM)

B<SL:> The reference point will be on the left edge of the bounding rectangle.

B<ML:> Aligns text to the left.

  UPDATECP			= 0x00000001 (SM)

The current position is updated after each text output call. The current
position is used as the reference point.

  RIGHT				= 0x00000002 (SM & DM)

B<SL:> The reference point will be on the right edge of the bounding rectangle.

B<ML:> Aligns text to the right.

  VCENTER			= 0x00000004 (DM)

Centers text vertically (single line only).

  BOTTOM			= 0x00000008 (SM & DM)

B<SL:> The reference point will be on the bottom edge of the bounding rectangle.

B<ML:> Justifies the text to the bottom of the rectangle. This value must be
combined with SINGLELINE.

  WORDBREAK			= 0x00000010 (DM)

Breaks words. Lines are automatically broken between words if a word extends
past the edge of the specified rectangle. A carriage return-linefeed sequence
also breaks the line.

  BASELINE			= 0x00000018 (SM)

The reference point will be on the base line of the text.

  SINGLELINE			= 0x00000020 (DM)

Displays text on a single line only. Carriage returns and linefeeds do not break
the line.

  EXPANDTABS			= 0x00000040 (DM)

Expands tab characters. Number of characters per tab is eight.

  NOCLIP			= 0x00000100 (DM)

Draws without clipping. B<Write> is somewhat faster when NOCLIP is used.

  EXTERNALLEADING		= 0x00000200 (DM)

Includes the font external leading in line height. Normally, external leading is
not included in the height of a line of text.

  CALCRECT			= 0x00000400 (DM)

Determines the B<$width> and B<$height> of the rectangle. If there are multiple
lines of text, B<Write> uses the width of the given rectangle and extends the
base of the rectangle to bound the last line of text. If there is only one line
of text, B<Write> modifies the width of the rectangle so that it bounds the
last character in the line. In either case, B<Write> returns the height of the
formatted text, but does not draw the text.

  NOPREFIX			= 0x00000800 (DM)

Turns off processing of prefix characters. Normally, B<Write> interprets the
ampersand (&) mnemonic-prefix character as a directive to underscore the
character that follows, and the double ampersand (&&) mnemonic-prefix characters
as a directive to print a single ampersand. By specifying NOPREFIX, this
processing is turned off.

  INTERNAL			= 0x00001000 (DM)

Uses the system font to calculate text metrics.

  EDITCONTROL			= 0x00002000 (DM)

Duplicates the text-displaying characteristics of a multiline edit control.
Specifically, the average character width is calculated in the same manner as
for an edit control, and the method does not display a partially visible last
line.

  PATH_ELLIPSIS			= 0x00004000 (DM)
  END_ELLIPSIS			= 0x00008000 (DM)

Replaces part of the given string with ellipses, if necessary, so that the
result fits in the specified rectangle. The B<$text> element of returning
array is not modified unless the MODIFYSTRING flag is specified.

You can specify END_ELLIPSIS to replace characters at the end of the string,
or PATH_ELLIPSIS to replace characters in the middle of the string. If the
string contains backslash (\) characters, PATH_ELLIPSIS preserves as much as
possible of the text after the last backslash.

  MODIFYSTRING			= 0x00010000 (DM)

Modifies the B<$text> element of returning array to match the displayed text.
This flag has no effect unless the END_ELLIPSIS or PATH_ELLIPSIS flag is
specified.

  RTLREADING			= 0x00020000 (SM & DM)

Layout in right to left reading order for bi-directional text when the selected
font is a Hebrew or Arabic font. The default reading order for all text is left
to right.

  WORD_ELLIPSIS			= 0x00040000 (DM)

Truncates text that does not fit in the rectangle and adds ellipses.

  CENTER			= 0x00080000 (SM & DM)

B<SL:> The reference point will be aligned horizontally with the center of the
bounding rectangle.

B<ML:> Centers text horizontally in the rectangle.

  JUSTIFY			= 0x80000000 (SM)

Extends space characters to match given justification width (B<$just_width>).

B<Note:> Allways use B<$just_width> parameter with B<JUSTIFY> flag!

See also L</Font> and L</Color>.

=head1 SEE ALSO

L<Win32::Printer::Enum>, Win32 Platform SDK GDI documentation.

=head1 AUTHOR

B<Edgars Binans>, I<admin@wasx.net>. I<http://www.wasx.net>

=head1 COPYRIGHT AND LICENSE

This library may use I<FreeImage> 2.5.4, a free, open source image library
supporting all common bitmap formats. Get your free copy from 
L<http://sourceforge.net>. I<FreeImage> is licensed under terms of B<GNU GPL>.

This library may use I<Ghostscript> for PDF support. I<GNU Ghostscript> is
licensed under terms of B<GNU GPL>. I<AFPL Ghostscript> is licensed under terms
of B<Aladdin Free Public License>. Download I<Ghostscript> from
L<http://sourceforge.net>.

B<Win32::Printer, Copyright (C) 2003 Edgars Binans E<lt>I<admin@wasx.net>E<gt>>.
Website: L<http://www.wasx.net>.

B<THIS LIBRARY IS FREE FOR NON-COMMERCIAL USE!!!>

=cut
