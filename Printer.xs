/*----------------------------------------------------------------------------*\
| Win32::Printer                                                               |
| V 0.8.4 (2004-11-04)                                                         |
| Copyright (C) 2003-2004 Edgars Binans <admin@wasx.net>                       |
| http://www.wasx.net                                                          |
\*----------------------------------------------------------------------------*/

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifdef EBBL
#define EBBL_NAL
#include "ebblwc.h"
#endif

#ifdef FREE
#include "FreeImage.h"
#endif

#ifdef GHOST
#include "iapi.h"
#endif

#include <winspool.h>
#include <commdlg.h>

LONG exfilt()
{
  return EXCEPTION_EXECUTE_HANDLER;
}

MODULE = Win32::Printer         PACKAGE = Win32::Printer

PROTOTYPES: DISABLE

LPTSTR
_GetLastError()
    PREINIT:
      char msg[255];
    CODE:
      FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, NULL, GetLastError(), 0, msg, 255, NULL);
      RETVAL = msg;
    OUTPUT:
      RETVAL

unsigned int
_Get3PLibs()
    CODE:
      RETVAL  = 0x00000000;
#ifdef FREE
      RETVAL |= 0x00000001;
#endif
#ifdef GHOST
      RETVAL |= 0x00000002;
#endif
#ifdef EBBL
      RETVAL |= 0x00000004;
#endif
    OUTPUT:
      RETVAL

HDC
_CreatePrinter(printer, dialog, Flags, copies, collate, minp, maxp, orient, papersize, duplex, source, color, height, width)
      LPTSTR printer;
      BOOL dialog;
      int Flags;
      int copies;
      int collate;
      int minp;
      int maxp;
      int orient;
      int papersize;
      int duplex;
      int source;
      int color;
      int height;
      int width;
    PREINIT:
      DWORD error;
      PRINTDLG *lppd;
      DEVMODE *lpdm;
      DEVNAMES *lpdn;
      LPTSTR pPrinterName;
      int printlen;
      HGLOBAL newDevNames;
      LPTSTR dnch;
      LPTSTR winspool = "winspool";
    CODE:
      RETVAL = (HDC) NULL;
      Newz(0, lppd, 1, PRINTDLG);
      lppd->lStructSize = sizeof(PRINTDLG);
      lppd->Flags = PD_RETURNDEFAULT;
      if (PrintDlg(lppd)) {
         lpdm = GlobalLock(lppd->hDevMode);
         if (height > 0 && width > 0) {
            lpdm->dmFields |= DM_PAPERLENGTH;
            lpdm->dmFields |= DM_PAPERWIDTH;
            lpdm->dmPaperLength = height;
            lpdm->dmPaperWidth = width;
         } else {
            lpdm->dmFields |= DM_PAPERSIZE;
            lpdm->dmPaperSize = papersize;
         }
         if (orient == 1 || orient == 2) {
            lpdm->dmFields |= DM_ORIENTATION;
            lpdm->dmOrientation = orient;
         }
         if (duplex == 1 || duplex == 2 || duplex == 3) {
            lpdm->dmFields |= DM_DUPLEX;
            lpdm->dmDuplex = duplex;
         }
         lpdm->dmFields |= DM_COPIES | DM_COLLATE | DM_DEFAULTSOURCE | DM_COLOR;
         lpdm->dmCopies = copies;
         lpdm->dmCollate = collate;
         lpdm->dmDefaultSource = source;
         lpdm->dmColor = color;
         if (dialog == 0) {
            lpdn = GlobalLock(lppd->hDevNames);
            if (strlen(printer) != 0) {
               RETVAL = CreateDC("winspool", printer, NULL, lpdm);
            } else {
               New(0, pPrinterName, lpdn->wOutputOffset - lpdn->wDeviceOffset, char);
               Copy((LPTSTR )lpdn + lpdn->wDeviceOffset, pPrinterName, lpdn->wOutputOffset - lpdn->wDeviceOffset, char);
               RETVAL = CreateDC("winspool", pPrinterName, NULL, lpdm);
               Safefree(pPrinterName);
            }
         } else {
            lppd->nFromPage = minp;
            lppd->nToPage = maxp;
            lppd->nMinPage = minp;
            lppd->nMaxPage = maxp;
            printlen = strlen(printer) < 32 ? (strlen(printer) + 1) : 32;
            newDevNames = GlobalAlloc(GMEM_MOVEABLE, 17 + printlen);
            dnch = GlobalLock(newDevNames);
            Copy(winspool, dnch + 8, 9, char);
            Copy(printer, dnch + 17, printlen, char);
            dnch[17 + printlen] = '\0';
            lpdn = (DEVNAMES *)dnch;
            lpdn->wDriverOffset = 8;
            lpdn->wDeviceOffset = 17;
            lpdn->wOutputOffset = 17 + printlen;
            lpdn->wDefault = 1;
            lppd->hDevNames = newDevNames;
            Copy(printer, lpdm->dmDeviceName, printlen, char);
            lppd->Flags = PD_RETURNDC | Flags;
            if (PrintDlg(lppd)) {
               RETVAL = lppd->hDC;
               Flags = lppd->Flags;
               copies = lpdm->dmCopies;
               collate = lpdm->dmCollate;
               minp = lppd->nFromPage;
               maxp = lppd->nToPage;
            }
         }
         error = GetLastError();
         GlobalUnlock(lppd->hDevNames);
         GlobalUnlock(lppd->hDevMode);
      }
      Safefree(lppd);
      if (RETVAL) {
         SetGraphicsMode(RETVAL, GM_ADVANCED);
      } else {
         if (dialog == 0) {
            SetLastError(error);
         } else {
            if (CommDlgExtendedError()) {
               croak("Print dialog error!\n");
            } else {
               SetLastError(ERROR_CANCELLED);
            }
         }
      }
    OUTPUT:
      Flags
      copies
      collate
      minp
      maxp
      RETVAL

LPCTSTR
_SaveAs(index, suggest, indir)
      int index;
      LPTSTR suggest;
      LPCTSTR indir;
    PREINIT:
      OPENFILENAME ofn;
      char file[MAX_PATH];
    CODE:
      ofn.lStructSize = sizeof(OPENFILENAME);
      ofn.hwndOwner = NULL;
      ofn.lpstrFilter = "Print files (*.prn, *.ps, *.pcl, *.afp)\0*.prn;*.ps;*.pcl;*.afp\0PDF files (*.pdf)\0*.pdf\0Enhenced Metafiles (*.emf)\0*.emf\0All files (*.*)\0*.*\0";
      ofn.lpstrCustomFilter = NULL;
      ofn.nFilterIndex = index;
      strcpy(file, suggest);
      ofn.lpstrFile = file;
      ofn.nMaxFile = MAX_PATH;
      ofn.lpstrFileTitle = NULL;
      if (indir[0] == '\0') {
         ofn.lpstrInitialDir = PerlEnv_get_childdir();
      } else {
         ofn.lpstrInitialDir = indir;
      }
      ofn.lpstrTitle = "Win32::Printer - Save As";
      ofn.Flags = OFN_NOCHANGEDIR | OFN_EXPLORER | OFN_PATHMUSTEXIST;
      if (index == 3) {
        ofn.Flags |= OFN_OVERWRITEPROMPT;
      }
      if (GetSaveFileName(&ofn)) {
         RETVAL = ofn.lpstrFile;
      } else {
         if (CommDlgExtendedError()) {
            croak("Save As dialog error!\n");
         } else {
            SetLastError(ERROR_CANCELLED);
         }
         RETVAL = "";
      }
    OUTPUT:
      RETVAL

LPCTSTR
_Open(index, multi)
      int index;
      int multi;
    PREINIT:
      OPENFILENAME ofn;
      char file[MAX_PATH];
    CODE:
      int x = 0;
      ofn.lStructSize = sizeof(OPENFILENAME);
      ofn.hwndOwner = NULL;
      ofn.lpstrFilter = "Print files (*.prn, *.ps, *.pcl, *.afp)\0*.prn;*.ps;*.pcl;*.afp\0PDF files (*.pdf)\0*.pdf\0Enhenced Metafiles (*.emf)\0*.emf\0All files (*.*)\0*.*\0";
      ofn.lpstrCustomFilter = NULL;
      ofn.nFilterIndex = index;
      file[0] = '\0';
      ofn.lpstrFile = file;
      ofn.nMaxFile = 65535;
      ofn.lpstrFileTitle = NULL;
      ofn.lpstrInitialDir = NULL;
      ofn.lpstrTitle = "Win32::Printer - Open";
      ofn.Flags = OFN_NOCHANGEDIR | OFN_EXPLORER | OFN_HIDEREADONLY;
      if (multi == 1) {
         ofn.Flags |= OFN_ALLOWMULTISELECT;
      }
      if (GetOpenFileName(&ofn)) {
         if (multi == 1) {
            while (1) {
               if ((ofn.lpstrFile[x] == '\0') && (ofn.lpstrFile[x + 1] != '\0')) {
                  ofn.lpstrFile[x] = 42;
               } else if ((ofn.lpstrFile[x] == '\0') && (ofn.lpstrFile[x + 1] == '\0')) {
                  break;
               }
               x++;
            }
         }
         RETVAL = ofn.lpstrFile;
      } else {
         if (CommDlgExtendedError()) {
            croak("Open dialog error!\n");
         } else {
            SetLastError(ERROR_CANCELLED);
         }
         RETVAL = "";
      }
    OUTPUT:
      RETVAL

BOOL
_DeleteDC(hdc)
      HDC hdc;
    CODE:
      RETVAL = DeleteDC(hdc);
    OUTPUT:
      RETVAL

int
_StartDoc(hdc, DocName, FileName)
      HDC hdc;
      LPCTSTR DocName;
      LPCTSTR FileName;
    PREINIT:
      DOCINFO di;
    CODE:
      di.cbSize = sizeof(DOCINFO);
      di.lpszDocName = DocName;
      di.lpszOutput = FileName;
      di.lpszDatatype = NULL;
      di.fwType = 0;
      RETVAL = StartDoc(hdc, &di);
    OUTPUT:
      RETVAL

int
_EndDoc(hdc)
      HDC hdc;
    CODE:
      RETVAL = EndDoc(hdc);
    OUTPUT:
      RETVAL

int
_AbortDoc(hdc)
      HDC hdc;
    CODE:
      RETVAL = AbortDoc(hdc);
    OUTPUT:
      RETVAL

int 
_StartPage(hdc)
      HDC hdc;
    CODE:
      RETVAL = StartPage(hdc);
      SetBkMode(hdc, TRANSPARENT);
    OUTPUT:
      RETVAL

int
_EndPage(hdc)
      HDC hdc;
    CODE:
      RETVAL = EndPage(hdc);
    OUTPUT:
      RETVAL

HGDIOBJ 
_SelectObject(hdc, hgdiobj)
      HDC hdc;
      HGDIOBJ hgdiobj;
    CODE:
      RETVAL = SelectObject(hdc, hgdiobj);
    OUTPUT:
      RETVAL

BOOL
_DeleteObject(hObject);
      HGDIOBJ hObject;
    CODE:
      RETVAL = DeleteObject(hObject);
    OUTPUT:
      RETVAL

int
_GetDeviceCaps(hdc, nIndex)
      HDC hdc;
      int nIndex;
    CODE:
      RETVAL = GetDeviceCaps(hdc, nIndex);
    OUTPUT:
      RETVAL

BOOL
_SetWorldTransform(hdc, eM11, eM12, eM21, eM22, eDx, eDy)
      HDC hdc;
      FLOAT eM11;
      FLOAT eM12;
      FLOAT eM21;
      FLOAT eM22;
      FLOAT eDx;
      FLOAT eDy;
    PREINIT:
      XFORM Xform;
    CODE:
      Xform.eM11 = eM11;
      Xform.eM12 = eM12;
      Xform.eM21 = eM21;
      Xform.eM22 = eM22;
      Xform.eDx = eDx;
      Xform.eDy = eDy;
      RETVAL = SetWorldTransform(hdc, &Xform);
    OUTPUT:
      RETVAL

int
_IsNT()
    CODE:
      OSVERSIONINFO osi;
      osi.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
      GetVersionEx(&osi);
      if (osi.dwPlatformId == VER_PLATFORM_WIN32_NT) {
        RETVAL = 1;
      } else {
        RETVAL = 0;
      }
    OUTPUT:
      RETVAL

HFONT
_CreateFont(Height, Escapement, Orientation, Weight, Italic, Underline, StrikeOut, CharSet, FaceName)
      long Height;
      long Escapement;
      long Orientation;
      long Weight;
      BYTE Italic;
      BYTE Underline;
      BYTE StrikeOut;
      BYTE CharSet;
      LPCTSTR FaceName;
    CODE:
      LOGFONT lf;
      int len = strlen(FaceName);
      lf.lfHeight = -Height;
      lf.lfWidth = 0;
      lf.lfEscapement = Escapement;
      lf.lfOrientation = Orientation;
      lf.lfWeight = Weight;
      lf.lfItalic = Italic;
      lf.lfUnderline = Underline;
      lf.lfStrikeOut = StrikeOut;
      lf.lfCharSet = CharSet;
      lf.lfOutPrecision = OUT_DEFAULT_PRECIS;
      lf.lfClipPrecision = CLIP_DEFAULT_PRECIS;
      lf.lfQuality = PROOF_QUALITY;
      lf.lfPitchAndFamily = DEFAULT_PITCH;
      if (len > 31) {
        memcpy(lf.lfFaceName, FaceName, 32);
      } else {
        memcpy(lf.lfFaceName, FaceName, len + 1);
      }
      RETVAL = CreateFontIndirect(&lf);
    OUTPUT:
      RETVAL

SV*
_GetTextFace(hdc)
      HDC hdc;
    CODE:
      char face[32];
      RETVAL = newSVpvn("", 0);
      GetTextFace(hdc, 32, face);
      sv_catpv(RETVAL, face);
    OUTPUT:
      RETVAL

BOOL 
_TextOut(hdc, nXStart, nYStart, lpString, align)
      HDC hdc;
      int nXStart;
      int nYStart;
      LPCTSTR lpString;
      int align;
    CODE:
      SetTextAlign(hdc, align);
      RETVAL = TextOut(hdc, nXStart, nYStart, lpString, strlen(lpString));
      SetTextAlign(hdc, TA_LEFT);
    OUTPUT:
      RETVAL

int
_DrawText(hdc, lpString, x1, y1, x2, y2, uFormat, uiLengthDrawn, tabStop)
      HDC hdc;
      LPTSTR lpString;
      LONG x1;
      LONG y1;
      LONG x2;
      LONG y2;
      UINT uFormat;
      UINT uiLengthDrawn;
      UINT tabStop;
    PREINIT:
      RECT Rect;
      DRAWTEXTPARAMS DTParams;
    CODE:
      Rect.left = x1;
      Rect.top = y1;
      Rect.right = x2;
      Rect.bottom = y2;
      DTParams.cbSize = sizeof(DRAWTEXTPARAMS);
      DTParams.iTabLength = tabStop;
      DTParams.iLeftMargin = 0;
      DTParams.iRightMargin = 0;
      RETVAL = DrawTextEx(hdc, lpString, -1, &Rect, uFormat | DT_TABSTOP, &DTParams);
      x2 = Rect.right;
      y2 = Rect.bottom;
      uiLengthDrawn = DTParams.uiLengthDrawn;
    OUTPUT:
      x2
      uiLengthDrawn
      lpString
      RETVAL

COLORREF
_SetTextColor(hdc, cRed, cGreen, cBlue)
      HDC hdc;
      BYTE cRed;
      BYTE cGreen;
      BYTE cBlue;
    PREINIT:
      COLORREF crColor = RGB(cRed, cGreen, cBlue);
    CODE:
      RETVAL = SetTextColor(hdc, crColor);
    OUTPUT:
      RETVAL

BOOL
_SetJustify(hdc, string, width)
      HDC hdc;
      LPCTSTR string;
      int width;
    PREINIT:
      SIZE size;
      TEXTMETRIC tm;
      int spaces = 0;
      int len = 0;
      LPCTSTR str = string;
    CODE:
      if (width > -1) {
         GetTextMetrics(hdc, &tm);
         while (*str != '\0') {
            if (*str == tm.tmBreakChar) {
               spaces++;
            }
            str++;
            len++;
         }
         GetTextExtentPoint32(hdc, string, len, &size);
         RETVAL = SetTextJustification(hdc, width - size.cx, spaces);
      } else {
         RETVAL = SetTextJustification(hdc, 0, 0);
      }
    OUTPUT:
      RETVAL

HPEN
_CreatePen(fnPenStyle, nWidth, cRed, cGreen, cBlue)
      int fnPenStyle;
      int nWidth;
      BYTE cRed;
      BYTE cGreen;
      BYTE cBlue;
    PREINIT:
      LOGBRUSH lb;
    CODE:
      lb.lbStyle = BS_SOLID;
      lb.lbColor = RGB(cRed, cGreen, cBlue);
      lb.lbHatch = NULL;
      RETVAL = ExtCreatePen(fnPenStyle, nWidth, &lb, 0, NULL);
    OUTPUT:
      RETVAL

BOOL
_MoveTo(hdc, X, Y)
      HDC hdc;
      int X;
      int Y;
    PREINIT:
      POINT Point;
    CODE:
      RETVAL = MoveToEx(hdc, X, Y, &Point);
      X = Point.x;
      Y = Point.y;
    OUTPUT:
      X
      Y
      RETVAL

BOOL
_Polyline(hdc, ...)
      HDC hdc;
    PREINIT:
      POINT *lpPoints;
      int i, j;
    CODE:
      New(0, lpPoints, items, POINT);
      i = 1; j = 0;
      while (i < items) {
         lpPoints[j].x = SvIV(ST(i));
         i++;
         lpPoints[j].y = SvIV(ST(i));
         i++; j++;
      }
      RETVAL = Polyline(hdc, lpPoints, (items-1) / 2);
      Safefree(lpPoints);
    OUTPUT:
      RETVAL

BOOL
_PolylineTo(hdc, ...)
      HDC hdc;
    PREINIT:
      POINT *lpPoints;
      int i, j;
    CODE:
      New(0, lpPoints, items, POINT);
      i = 1; j = 0;
      while (i < items) {
         lpPoints[j].x = SvIV(ST(i));
         i++;
         lpPoints[j].y = SvIV(ST(i));
         i++; j++;
      }
      RETVAL = PolylineTo(hdc, lpPoints, (items - 1) / 2);
      Safefree(lpPoints);
    OUTPUT:
      RETVAL

HBRUSH 
_CreateBrushIndirect(lbStyle, lbHatch, cRed, cGreen, cBlue)
      UINT lbStyle;
      LONG lbHatch;
      BYTE cRed;
      BYTE cGreen;
      BYTE cBlue;
    PREINIT:
      LOGBRUSH lb;
    CODE:
      lb.lbStyle = lbStyle;
      lb.lbColor = RGB(cRed, cGreen, cBlue);
      lb.lbHatch = lbHatch;
      RETVAL = CreateBrushIndirect(&lb);
    OUTPUT:
      RETVAL

int
_SetPolyFillMode(hdc, iPolyFillMode)
      HDC hdc;
      int iPolyFillMode;
    CODE:
      RETVAL = SetPolyFillMode(hdc, iPolyFillMode);
    OUTPUT:
      RETVAL

BOOL
_Rectangle(hdc, nLeftRect, nTopRect, nRightRect, nBottomRect)
      HDC hdc;
      int nLeftRect;
      int nTopRect;
      int nRightRect;
      int nBottomRect;
    CODE:
      RETVAL = Rectangle(hdc, nLeftRect, nTopRect, nRightRect, nBottomRect);
    OUTPUT:
      RETVAL

BOOL
_RoundRect(hdc, nLeftRect, nTopRect, nRightRect, nBottomRect, nWidth, nHeight)
      HDC hdc;
      int nLeftRect;
      int nTopRect;
      int nRightRect;
      int nBottomRect;
      int nWidth;
      int nHeight;
    CODE:
      RETVAL = RoundRect(hdc, nLeftRect, nTopRect, nRightRect, nBottomRect, nWidth, nHeight);
    OUTPUT:
      RETVAL

BOOL
_Ellipse(hdc, nLeftRect, nTopRect, nRightRect, nBottomRect)
      HDC hdc;
      int nLeftRect;
      int nTopRect;
      int nRightRect;
      int nBottomRect;
    CODE:
      RETVAL = Ellipse(hdc, nLeftRect, nTopRect, nRightRect, nBottomRect);
    OUTPUT:
      RETVAL

BOOL
_Chord(hdc, nLeftRect, nTopRect, nRightRect, nBottomRect, nXRadial1, nYRadial1, nXRadial2, nYRadial2)
      HDC hdc;
      int nLeftRect;
      int nTopRect;
      int nRightRect;
      int nBottomRect;
      int nXRadial1;
      int nYRadial1;
      int nXRadial2;
      int nYRadial2;
    CODE:
      RETVAL = Chord(hdc, nLeftRect, nTopRect, nRightRect, nBottomRect, nXRadial1, nYRadial1, nXRadial2, nYRadial2);
    OUTPUT:
      RETVAL

BOOL
_Pie(hdc, nLeftRect, nTopRect, nRightRect, nBottomRect, nXRadial1, nYRadial1, nXRadial2, nYRadial2)
      HDC hdc;
      int nLeftRect;
      int nTopRect;
      int nRightRect;
      int nBottomRect;
      int nXRadial1;
      int nYRadial1;
      int nXRadial2;
      int nYRadial2;
    CODE:
      RETVAL = Pie(hdc, nLeftRect, nTopRect, nRightRect, nBottomRect, nXRadial1, nYRadial1, nXRadial2, nYRadial2);
    OUTPUT:
      RETVAL

BOOL
_Polygon(hdc, ...)
      HDC hdc;
    PREINIT:
      POINT *Points;
      int i, j;
    CODE:
      New(0, Points, items, POINT);
      i = 1; j = 0;
      while (i < items) {
         Points[j].x = SvIV(ST(i));
         i++;
         Points[j].y = SvIV(ST(i));
         i++; j++;
      }
      RETVAL = Polygon(hdc, Points, (items-1) / 2);
      Safefree(Points);
    OUTPUT:
      RETVAL

BOOL
_PolyBezier(hdc, ...)
      HDC hdc;
    PREINIT:
      POINT *Points;
      int i, j;
    CODE:
      New(0, Points, items, POINT);
      i = 1; j = 0;
      while (i < items) {
         Points[j].x = SvIV(ST(i));
         i++;
         Points[j].y = SvIV(ST(i));
         i++; j++;
      }
      RETVAL = PolyBezier(hdc, Points, (items-1) / 2);
      Safefree(Points);
    OUTPUT:
      RETVAL

BOOL
_PolyBezierTo(hdc, ...)
      HDC hdc;
    PREINIT:
      POINT *Points;
      int i, j;
    CODE:
      New(0, Points, items, POINT);
      i = 1; j = 0;
      while (i < items) {
         Points[j].x = SvIV(ST(i));
         i++;
         Points[j].y = SvIV(ST(i));
         i++; j++;
      }
      RETVAL = PolyBezierTo(hdc, Points, (items-1) / 2);
      Safefree(Points);
    OUTPUT:
      RETVAL

BOOL
_Arc(hdc, nLeftRect, nTopRect, nRightRect, nBottomRect, nXRadial1, nYRadial1, nXRadial2, nYRadial2)
      HDC hdc;
      int nLeftRect;
      int nTopRect;
      int nRightRect;
      int nBottomRect;
      int nXRadial1;
      int nYRadial1;
      int nXRadial2;
      int nYRadial2;
    CODE:
      RETVAL = Arc(hdc, nLeftRect, nTopRect, nRightRect, nBottomRect, nXRadial1, nYRadial1, nXRadial2, nYRadial2);
    OUTPUT:
      RETVAL

BOOL
_ArcTo(hdc, nLeftRect, nTopRect, nRightRect, nBottomRect, nXRadial1, nYRadial1, nXRadial2, nYRadial2)
      HDC hdc;
      int nLeftRect;
      int nTopRect;
      int nRightRect;
      int nBottomRect;
      int nXRadial1;
      int nYRadial1;
      int nXRadial2;
      int nYRadial2;
    CODE:
      RETVAL = ArcTo(hdc, nLeftRect, nTopRect, nRightRect, nBottomRect, nXRadial1, nYRadial1, nXRadial2, nYRadial2);
    OUTPUT:
      RETVAL

BOOL
_BeginPath(hdc)
      HDC hdc;
    CODE:
      RETVAL = BeginPath(hdc);
    OUTPUT:
      RETVAL

BOOL
_EndPath(hdc)
      HDC hdc;
    CODE:
      RETVAL = EndPath(hdc);
    OUTPUT:
      RETVAL

BOOL
_AbortPath(hdc)
      HDC hdc;
    CODE:
      RETVAL = AbortPath(hdc);
    OUTPUT:
      RETVAL

BOOL
_StrokeAndFillPath(hdc)
      HDC hdc;
    CODE:
      RETVAL = StrokeAndFillPath(hdc);
    OUTPUT:
      RETVAL

BOOL
_SelectClipPath(hdc, iMode)
      HDC hdc;
      int iMode;
    CODE:
      RETVAL = SelectClipPath(hdc, iMode);
    OUTPUT:
      RETVAL

int
_DeleteClipPath(hdc)
      HDC hdc;
    CODE:
      RETVAL = SelectClipRgn(hdc, NULL);
    OUTPUT:
      RETVAL

HENHMETAFILE
_GetWinMetaFile(hdc, lpszMetaFile)
      HDC hdc;
      LPCTSTR lpszMetaFile;
    PREINIT:
      typedef struct {
         DWORD     key;
         WORD      hmf;
         _int16    left;
         _int16    top;
         _int16    right;
         _int16    bottom;
         WORD      inch;
         DWORD     reserved;
         WORD      checksum;
      } METAFILE_HEADER, *PMETAFILE_HEADER;
      HMETAFILE hmf;
      HENHMETAFILE hemf = NULL;
      LPVOID mfb;
      BYTE *Data;
      PerlIO *file;
      METAFILEPICT mfp;
      METAFILE_HEADER MfHdr;
      UINT nSize;
      LPCTSTR lpPathName = PerlEnv_get_childdir();
    CODE:
      SetCurrentDirectory(lpPathName);
      hmf = GetMetaFile(lpszMetaFile);
      mfp.mm = MM_ANISOTROPIC;
      mfp.xExt = -1;
      mfp.yExt = -1;
      mfp.hMF  = NULL;
      if (hmf == NULL) {
         file = PerlIO_open(lpszMetaFile, "rb");
         if (file != NULL) {
            PerlIO_read(file, &MfHdr, sizeof(METAFILE_HEADER));
            mfp.xExt = (long)((MfHdr.right - MfHdr.left) * 2540.9836 / MfHdr.inch);
            mfp.yExt = (long)((MfHdr.bottom - MfHdr.top) * 2540.9836 / MfHdr.inch);
            PerlIO_seek(file, 0, SEEK_END);
            nSize = (UINT) PerlIO_tell(file) - 22;
            New(0, Data, nSize, BYTE);
            PerlIO_seek(file, 22, 0);
            PerlIO_read(file, Data, nSize);
            hmf = SetMetaFileBitsEx(nSize, Data);
            Safefree(Data);
            PerlIO_close(file);
         }
      }
      if (hmf != NULL) {
         nSize = GetMetaFileBitsEx(hmf, NULL, NULL);
         New(0, mfb, nSize, LPVOID);
         nSize = GetMetaFileBitsEx(hmf, nSize, mfb);
         hemf = SetWinMetaFileBits(nSize, mfb, hdc, &mfp);
         Safefree(mfb);
      }
      RETVAL = hemf;
    OUTPUT:
      RETVAL

int
_EBbl(hdc, emf, string, x, y, flags, baw, bah)
      HDC hdc;
      HENHMETAFILE emf;
      LPTSTR string;
      int x;
      int y;
      unsigned flags;
      int baw;
      int bah;
    PREINIT:
#ifdef EBBL
      ebc_t ebc;
      HPEN pen;
      HPEN prepen;
      HFONT font;
      HBRUSH brush;
#endif
    CODE:
      RETVAL = NULL;
#ifdef EBBL
      ebc.flags = flags;
      ebc.baw = baw;
      ebc.bah = bah;
      __try {
         if (emf) {
           brush = GetCurrentObject(hdc, OBJ_BRUSH);
           font = GetCurrentObject(hdc, OBJ_FONT);
           hdc = CreateEnhMetaFile(hdc, NULL, NULL, NULL);
           SelectObject(hdc, brush);
           SelectObject(hdc, font);
           SetBkMode(hdc, TRANSPARENT);
         }
         pen = CreatePen(PS_NULL, 1, 0xFFFFFFFF);
         prepen = SelectObject(hdc, pen);
         ebc.hdc = hdc;
         RETVAL = EBbl(&ebc, string, x, y);
         SelectObject(hdc, prepen);
         DeleteObject(pen);
         if (emf) {
           emf = CloseEnhMetaFile(hdc);
         }
      }
      __except (exfilt()) {
         RETVAL = 64;
      }
#else
      croak("EBbl is not supported in this build!\n");
#endif
    OUTPUT:
      emf
      RETVAL

HENHMETAFILE
_GetEnhMetaFile(lpszMetaFile)
      LPCTSTR lpszMetaFile;
    PREINIT:
      HENHMETAFILE hemf;
      LPTSTR dir = PerlEnv_get_childdir();
    CODE:
      SetCurrentDirectory(dir);
      hemf = GetEnhMetaFile(lpszMetaFile);
      RETVAL = hemf;
    OUTPUT:
      RETVAL

HENHMETAFILE
_LoadBitmap(hdc, BmpFile, Type);
      HDC hdc;
      LPCTSTR BmpFile;
      int Type;
    PREINIT:
#ifdef FREE
      LPTSTR dir = PerlEnv_get_childdir();
      FIBITMAP *Image;
      BITMAPINFO *lpbmi;
      double resolutionX = 72;
      double resolutionY = 72;
#endif
    CODE:
      RETVAL = NULL;
#ifdef FREE
      SetCurrentDirectory(dir);
      __try {
         if (Type == FIF_UNKNOWN) {
            Type = FreeImage_GetFIFFromFilename(BmpFile);
            if (Type == FIF_UNKNOWN) {
              Type = FreeImage_GetFileType(BmpFile, 16);
            }
         }
         if ((Type != FIF_UNKNOWN) && FreeImage_FIFSupportsReading(Type)) {
            Image = FreeImage_Load(Type, BmpFile, 0);
            if (Image) {
               lpbmi = (BITMAPINFO *) FreeImage_GetInfo(Image);
               hdc = CreateEnhMetaFile(hdc, NULL, NULL, NULL);
               if (lpbmi->bmiHeader.biXPelsPerMeter && lpbmi->bmiHeader.biYPelsPerMeter) {
                  resolutionX = lpbmi->bmiHeader.biXPelsPerMeter / 39.35483881;
                  resolutionY = lpbmi->bmiHeader.biYPelsPerMeter / 39.35483881;
               }
               StretchDIBits(hdc, 0, 0, (int)(GetDeviceCaps(hdc, LOGPIXELSX) * lpbmi->bmiHeader.biWidth / resolutionX), (int)(GetDeviceCaps(hdc, LOGPIXELSY) * lpbmi->bmiHeader.biHeight / resolutionY), 0, 0, lpbmi->bmiHeader.biWidth, lpbmi->bmiHeader.biHeight, (CONST VOID *) FreeImage_GetBits(Image), lpbmi, DIB_RGB_COLORS, SRCCOPY);
               RETVAL = CloseEnhMetaFile(hdc);
               FreeImage_Unload(Image);
            } else {
               if (!GetLastError()) {
                  SetLastError(ERROR_INVALID_DATA);
               }
            }
         } else {
            Image = 0;
         }
      }
      __except (exfilt()) {
         Image = 0;
      }
#else
      croak("FreeImage is not supported in this build!\n");
#endif
    OUTPUT:
      RETVAL

BOOL
_PlayEnhMetaFile(hdc, hemf, nLeftRect, nTopRect, nRightRect, nBottomRect)
      HDC hdc;
      HENHMETAFILE hemf;
      int nLeftRect;
      int nTopRect;
      int nRightRect;
      int nBottomRect;
    PREINIT:
      RECT Rect;
    CODE:
      Rect.left = nLeftRect;
      Rect.top = nTopRect;
      Rect.right = nRightRect;
      Rect.bottom = nBottomRect;
      RETVAL = PlayEnhMetaFile(hdc, hemf, &Rect);
    OUTPUT:
      RETVAL

UINT
_GetEnhSize(hdc, hemf, right, bottom)
      HDC hdc;
      HENHMETAFILE hemf;
      double right;
      double bottom;
    PREINIT:
      ENHMETAHEADER emh;
    CODE:
      RETVAL = GetEnhMetaFileHeader(hemf, sizeof(ENHMETAHEADER), &emh);
      right = (emh.rclFrame.right - emh.rclFrame.left) * GetDeviceCaps(hdc, LOGPIXELSX) / 2540.9836;
      bottom = (emh.rclFrame.bottom - emh.rclFrame.top) * GetDeviceCaps(hdc, LOGPIXELSY) / 2540.9836;
    OUTPUT:
      right
      bottom

BOOL
_DeleteEnhMetaFile(hemf)
      HENHMETAFILE hemf;
    CODE:
      RETVAL = DeleteEnhMetaFile(hemf);
    OUTPUT:
      RETVAL

SV*
_EnumPrinters(Flags, Server)
      int Flags;
      LPTSTR Server;
    PREINIT:
      int rc;
      LPBYTE buffer;
      DWORD needed, returned;
      PRINTER_INFO_2 *pri2;
      unsigned int i;
    CODE:
      SV* retval = newSVpvn("", 0);
      EnumPrinters(Flags, Server, 2, NULL, 0, &needed, &returned);
      New(0, buffer, needed, BYTE);
      rc = EnumPrinters(Flags, Server, 2, buffer, needed, &needed, &returned);
      pri2 = (PRINTER_INFO_2 *) buffer;
      if ((rc) && (returned)) {
         for (i = 0; i < returned; i++) {
               sv_catpvf(retval, "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t\n",
               pri2[i].pServerName,
               pri2[i].pPrinterName,
               pri2[i].pShareName,
               pri2[i].pPortName,
               pri2[i].pDriverName,
               pri2[i].pComment,
               pri2[i].pLocation,
               pri2[i].pSepFile,
               pri2[i].pPrintProcessor,
               pri2[i].pDatatype,
               pri2[i].pParameters,
               pri2[i].Attributes,
               pri2[i].Priority,
               pri2[i].DefaultPriority,
               pri2[i].StartTime,
               pri2[i].UntilTime,
               pri2[i].Status,
               pri2[i].cJobs,
               pri2[i].AveragePPM
            );
         }
      }
      Safefree(buffer);
      RETVAL = retval;
    OUTPUT:
      RETVAL

SV*
_EnumPrinterDrivers(Server, Env)
      LPTSTR Server;
      LPTSTR Env;
    PREINIT:
      int rc;
      LPBYTE buffer;
      DWORD needed, returned;
      DRIVER_INFO_3 *dri3;
      unsigned int i;
      unsigned int x = 0;
    CODE:
      SV* retval = newSVpvn("", 0);
      EnumPrinterDrivers(Server, Env, 3, NULL, 0, &needed, &returned);
      New(0, buffer, needed, BYTE);
      rc = EnumPrinterDrivers(Server, Env, 3, buffer, needed, &needed, &returned);
      dri3 = (DRIVER_INFO_3 *) buffer;
      if ((rc) && (returned)) {
         for (i = 0; i < returned; i++) {
            if (dri3[i].pDependentFiles != NULL) {
               while (1) {
                  if ((dri3[i].pDependentFiles[x] == '\0') && (dri3[i].pDependentFiles[x + 1] != '\0')) {
                     dri3[i].pDependentFiles[x] = 42;
                  } else if ((dri3[i].pDependentFiles[x] == '\0') && (dri3[i].pDependentFiles[x + 1] == '\0')) {
                     break;
                  }
                  x++;
               }
            }
            sv_catpvf(retval, "%d\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
               dri3[i].cVersion,
               dri3[i].pName,
               dri3[i].pEnvironment,
               dri3[i].pDriverPath,
               dri3[i].pDataFile,
               dri3[i].pConfigFile,
               dri3[i].pHelpFile, 
               dri3[i].pDependentFiles,
               dri3[i].pMonitorName,
               dri3[i].pDefaultDataType
            );
         }
      }
      Safefree(buffer);
      RETVAL = retval;
    OUTPUT:
      RETVAL

SV*
_EnumPorts(Server)
      LPTSTR Server;
    PREINIT:
      int rc;
      LPBYTE buffer;
      DWORD needed, returned;
      PORT_INFO_2 *pi2;
      unsigned int i;
    CODE:
      SV* retval = newSVpvn("", 0);
      EnumPorts(Server, 2, NULL, 0, &needed, &returned);
      New(0, buffer, needed, BYTE);
      rc = EnumPorts(Server, 2, buffer, needed, &needed, &returned);
      pi2 = (PORT_INFO_2 *) buffer;
      if ((rc) && (returned)) {
         for (i = 0; i < returned; i++) {
            sv_catpvf(retval, "%s\t%s\t%s\t%d\n", 
               pi2[i].pPortName,
               pi2[i].pMonitorName,
               pi2[i].pDescription,
               pi2[i].fPortType
            );
         }
      }
      Safefree(buffer);
      RETVAL = retval;
    OUTPUT:
      RETVAL

SV*
_EnumMonitors(Server)
      LPTSTR Server;
    PREINIT:
      int rc;
      LPBYTE buffer;
      DWORD needed, returned;
      MONITOR_INFO_2 *mi2;
      unsigned int i;
    CODE:
      SV* retval = newSVpvn("", 0);
      EnumMonitors(Server, 2, NULL, 0, &needed, &returned);
      New(0, buffer, needed, BYTE);
      rc = EnumMonitors(Server, 2, buffer, needed, &needed, &returned);
      mi2 = (MONITOR_INFO_2 *) buffer;
      if ((rc) && (returned)) {
         for (i = 0; i < returned; i++) {
            sv_catpvf(retval, "%s\t%s\t%s\n",
               mi2[i].pName,
               mi2[i].pEnvironment,
               mi2[i].pDLLName
            );
         }
      }
      Safefree(buffer);
      RETVAL = retval;
    OUTPUT:
      RETVAL

SV*
_EnumPrintProcessors(Server, Env)
      LPTSTR Server;
      LPTSTR Env;
    PREINIT:
      int rc;
      LPBYTE buffer;
      DWORD needed, returned;
      PRINTPROCESSOR_INFO_1 *ppi1;
      unsigned int i;
    CODE:
      SV* retval = newSVpvn("", 0);
      EnumPrintProcessors(Server, Env, 1, NULL, 0, &needed, &returned);
      New(0, buffer, needed, BYTE);
      rc = EnumPrintProcessors(Server, Env, 1, buffer, needed, &needed, &returned);
      ppi1 = (PRINTPROCESSOR_INFO_1 *)buffer;
      if ((rc) && (returned)) {
         for (i = 0; i < returned; i++) {
            sv_catpvf(retval, "%s\n", ppi1[i].pName);
         }
      }
      Safefree(buffer);
      RETVAL = retval;
    OUTPUT:
      RETVAL

SV*
_EnumPrintProcessorDatatypes(Server, Processor)
      LPTSTR Server;
      LPTSTR Processor;
    PREINIT:
      int rc;
      LPBYTE buffer;
      DWORD needed, returned;
      DATATYPES_INFO_1 *dti1;
      unsigned int i;
    CODE:
      SV* retval = newSVpvn("", 0);
      EnumPrintProcessorDatatypes(Server, Processor, 1, NULL, 0, &needed, &returned);
      New(0, buffer, needed, BYTE);
      rc = EnumPrintProcessorDatatypes(Server, Processor, 1, buffer, needed, &needed, &returned);
      dti1 = (DATATYPES_INFO_1 *)buffer;
      if ((rc) && (returned)) {
         for (i = 0; i < returned; i++) {
            sv_catpvf(retval, "%s\n", dti1[i].pName);
         }
      }
      Safefree(buffer);
      RETVAL = retval;
    OUTPUT:
      RETVAL

SV*
_EnumJobs(EnPrinter, begin, end)
      LPTSTR EnPrinter;
      int begin;
      int end;
    PREINIT:
      HANDLE hPrinter;
      int rc;
      LPBYTE buffer;
      DWORD needed, returned;
      JOB_INFO_2 *ji2;
      unsigned int i;
    CODE:
      SV* retval = newSVpvn("", 0);
      if (OpenPrinter(EnPrinter, &hPrinter, NULL)) {
         EnumJobs(hPrinter, begin, end, 2, NULL, 0, &needed, &returned);
         New(0, buffer, needed, BYTE);
         rc = EnumJobs(hPrinter, begin, end, 2, buffer, needed, &needed, &returned);
         ji2 = (JOB_INFO_2 *)buffer;
         if ((rc) && (returned)) {
            for (i = 0; i < returned; i++) {
               sv_catpvf(retval, "%d\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n",
                  ji2[i].JobId,
                  ji2[i].pPrinterName,
                  ji2[i].pMachineName,
                  ji2[i].pUserName,
                  ji2[i].pDocument,
                  ji2[i].pNotifyName,
                  ji2[i].pDatatype,
                  ji2[i].pPrintProcessor,
                  ji2[i].pParameters,
                  ji2[i].pDriverName,
                  ji2[i].pStatus,
                  ji2[i].Status,
                  ji2[i].Priority,
                  ji2[i].Position,
                  ji2[i].StartTime,
                  ji2[i].UntilTime,
                  ji2[i].TotalPages,
                  ji2[i].Size,
                  ji2[i].PagesPrinted
               );
            }
         }
         Safefree(buffer);
      }
      RETVAL = retval;
    OUTPUT:
      RETVAL

LPTSTR 
_GetTempPath()
    PREINIT:
      char msg[MAX_PATH];
    CODE:
      GetTempPath(MAX_PATH, msg);
      RETVAL = msg;
    OUTPUT:
      RETVAL

int
_GhostPDF(ps, pdf)
      LPTSTR ps;
      LPTSTR pdf;
    PREINIT:
#ifdef GHOST
      gs_main_instance *minst;
      int gsargc = 13;
      char pdfpath[MAX_PATH];
      LPTSTR gsargv[] = { "Printer", "-dORIENT1=true", "-dDOINTERPOLATE", "-sstdout=%stderr", "-dNOPAUSE", "-dBATCH", "-dSAFER", "-sDEVICE=pdfwrite", pdfpath, "-c", ".setpdfwrite", "-f", ps };
#endif
    CODE:
      RETVAL = NULL;
#ifdef GHOST
      __try {
         if (gsapi_new_instance(&minst, NULL) == 0) {
            sprintf(pdfpath, "-sOutputFile=%s", pdf);
            if (gsapi_init_with_args(minst, gsargc, (LPTSTR *)gsargv) == 0) {
               RETVAL = 1;
               gsapi_exit(minst);
            }
            gsapi_delete_instance(minst);
         }
      }
      __except (exfilt()) { }
#else
      croak("Ghostscript is not supported in this build!\n");
#endif
    OUTPUT:
      RETVAL

HDC
_CreateMeta(hdc, file, right, bottom)
      HDC hdc;
      LPCTSTR file;
      LONG right;
      LONG bottom;
    PREINIT:
      RECT rect;
    CODE:
      if (file[0] == '\0') { file = NULL; }
      if (right | bottom) {
        rect.left = 0;
        rect.top = 0;
        rect.right = right;
        rect.bottom = bottom;
        RETVAL = CreateEnhMetaFile(hdc, file, &rect, NULL);
      } else {
        RETVAL = CreateEnhMetaFile(hdc, file, NULL, NULL);
      }
      SetGraphicsMode(RETVAL, GM_ADVANCED);
      SetBkMode(RETVAL, TRANSPARENT);
    OUTPUT:
      RETVAL

HENHMETAFILE
_CloseMeta(edc)
      HDC edc;
    CODE:
      RETVAL = CloseEnhMetaFile(edc);
    OUTPUT:
      RETVAL
