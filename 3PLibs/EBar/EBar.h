#include <windows.h>

#define EB_ESUCCESS	0
#define EB_ESELECT	1
#define EB_ECHAR	2
#define EB_ESIZE	4
#define EB_EGDI		8
#define EB_EMEM		16

#define EB_25MATRIX	0x00000001
#define EB_25INT	0x00000002
#define EB_25IND	0x00000004
#define EB_25IATA	0x00000008

#define EB_27		0x00000010

#define EB_39		0x00000020
#define EB_39EX		0x00000040
#define EB_39DUMB	0x00000080

#define EB_93		0x00000100

#define EB_128X		0x00000200
#define EB_128A		0x00000400
#define EB_128B		0x00000800
#define EB_128C		0x00001000
#define EB_128S		0x00002000
#define EB_128EAN	0x00004000

#define EB_EAN13	0x00008000
#define EB_UPCA		0x00010000
#define EB_EAN8		0x00020000
#define EB_UPCE		0x00040000
#define EB_ISBN		0x00080000
#define EB_ISBN2	0x00100000
#define EB_ISSN		0x00200000
#define EB_AD2		0x00400000
#define EB_AD5		0x00800000

#define EB_CHK		0x01000000
#define EB_TXT		0x02000000

typedef struct ebc_tag {
  HDC		hdc;
  unsigned	nbw;
  unsigned	bh;
  unsigned	flags;
  char		*file;
  char		chk1;
  char		chk2;
  HFONT		hfont;
  char		*font;
  int		size;
  int		weight;
  COLORREF	color;
  int		error;
} ebc_t, *pebc_t;

HENHMETAFILE EBar(pebc_t ebc, char *enstring);
const char *EBarV(void);
