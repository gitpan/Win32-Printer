/*----------------------------------------------------------------------------*\
| Win32::Printer                                                               |
| V 0.6.2 (14.08.2003)                                                         |
| Copyright (C) 2003 Edgars Binans <admin@wasx.net>                            |
| http://www.wasx.net                                                          |
\*----------------------------------------------------------------------------*/

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <winspool.h>
#include <commdlg.h>

MODULE = Win32::Printer         PACKAGE = Win32::Printer

PROTOTYPES: DISABLE

char*
_GetLastError()
    PREINIT:
      char msg[255];
    CODE:
      FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, NULL, GetLastError(), 0, msg, 255, NULL);
      RETVAL = msg;
    OUTPUT:
      RETVAL

HDC
_CreatePrinter(printer, dialog, Flags, copies, collate, minp, maxp, orient, papersize, duplex, source, color)
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
    PREINIT:
      DWORD error;
      PRINTDLG *lppd;
      DEVMODE *lpdm;
      DEVNAMES *lpdn;
      LPTSTR pPrinterName;
    CODE:
      RETVAL = (HDC) NULL;
      Newz(0, lppd, 1, PRINTDLG);
      lppd->lStructSize = sizeof(PRINTDLG);
      lppd->Flags = PD_RETURNDEFAULT;
      lppd->nFromPage = minp;
      lppd->nToPage = maxp;
      lppd->nMinPage = minp;
      lppd->nMaxPage = maxp;
      lppd->nCopies = 1;
      if (PrintDlg(lppd)) {
         lpdm = GlobalLock(lppd->hDevMode);
         lpdm->dmFields |= DM_PAPERSIZE | DM_ORIENTATION | DM_DUPLEX | DM_COPIES | DM_COLLATE | DM_DEFAULTSOURCE | DM_COLOR;
         lpdm->dmOrientation = orient;
         lpdm->dmPaperSize = papersize;
         lpdm->dmDuplex = duplex;
         lpdm->dmCopies = copies;
         lpdm->dmCollate = collate;
         lpdm->dmDefaultSource = source;
         lpdm->dmColor = color;
         lpdn = GlobalLock(lppd->hDevNames);
         if (dialog == 0) {
            if (strlen(printer) != 0) {
               RETVAL = CreateDC("WINSPOOL", printer, NULL, lpdm);
            } else {
               New(0, pPrinterName, lpdn->wOutputOffset - lpdn->wDeviceOffset, char);
               Copy((char*)lpdn + lpdn->wDeviceOffset, pPrinterName, lpdn->wOutputOffset - lpdn->wDeviceOffset, char);
               RETVAL = CreateDC("WINSPOOL", pPrinterName, NULL, lpdm);
               Safefree(pPrinterName);
            }
         } else {
            lppd->Flags = PD_RETURNDC | Flags;
            if (PrintDlg(lppd)) {
               if (Flags & PD_USEDEVMODECOPIESANDCOLLATE) {
                  copies = 1;
                  collate = 0;
               } else {
                  copies = lpdm->dmCopies;
                  collate = lpdm->dmCollate;
                  lpdm->dmCopies = 1;
                  lpdm->dmCollate = 0;
               }
               RETVAL = lppd->hDC;
               Flags = lppd->Flags;
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

BOOL
_DeleteDC(hdc)
      HDC hdc;
    CODE:
      RETVAL = DeleteDC(hdc);
    OUTPUT:
      RETVAL

int
_StartDoc(hdc, DocName)
      HDC hdc;
      LPCTSTR DocName;
    PREINIT:
      DOCINFO di;
    CODE:
      di.cbSize = sizeof(DOCINFO);
      di.lpszDocName = DocName;
      di.lpszOutput = NULL;
      di.lpszDatatype = NULL;
      di.fwType = NULL;
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

HFONT
_CreateFont(nHeight, nWidth, nEscapement, nOrientation, fnWeight, fdwItalic, fdwUnderline, fdwStrikeOut, fdwCharset, fdwOutputPrecision, fdwClipPrecision, fdwQuality, fdwPitchAndFamily, Face)
      int nHeight;
      int nWidth;
      int nEscapement;
      int nOrientation;
      int fnWeight;
      DWORD fdwItalic;
      DWORD fdwUnderline;
      DWORD fdwStrikeOut;
      DWORD fdwCharset;
      DWORD fdwOutputPrecision;
      DWORD fdwClipPrecision;
      DWORD fdwQuality;
      DWORD fdwPitchAndFamily;
      LPCTSTR Face;
    CODE:
      RETVAL = CreateFont(nHeight, nWidth, nEscapement, nOrientation, fnWeight, fdwItalic, fdwUnderline, fdwStrikeOut, fdwCharset, fdwOutputPrecision, fdwClipPrecision, fdwQuality, fdwPitchAndFamily, Face);
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
      lb.lbHatch = NULL;;
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
      RETVAL = PolylineTo(hdc, lpPoints, (items-1) / 2);
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
      HENHMETAFILE hemf;
      LPVOID mfb;
      BYTE *Data;
      PerlIO *file;
      METAFILEPICT mfp;
      METAFILE_HEADER MfHdr;
      UINT nSize;
      LPCTSTR lpPathName = PerlEnv_get_childdir();
    CODE:
      SetCurrentDirectory(lpPathName);
      hemf = GetMetaFile(lpszMetaFile);
      mfp.mm = MM_ANISOTROPIC;
      mfp.xExt = -1;
      mfp.yExt = -1;
      mfp.hMF  = NULL;
      if (hemf == NULL) {
         file = PerlIO_open(lpszMetaFile, "rb");
         if (file != NULL) {
            PerlIO_read(file, &MfHdr, sizeof(METAFILE_HEADER));
            mfp.xExt = MfHdr.right - MfHdr.left;
            mfp.yExt = MfHdr.bottom - MfHdr.top;
            PerlIO_seek(file, 0, SEEK_END);
            nSize = (UINT) PerlIO_tell(file) - 22;
            New(0, Data, nSize, BYTE);
            PerlIO_seek(file, 22, 0);
            PerlIO_read(file, Data, nSize);
            hemf=SetMetaFileBitsEx(nSize, Data);
            Safefree(Data);
            PerlIO_close(file);
         }
      }
      if (hemf != NULL) {
         nSize = GetMetaFileBitsEx(hemf, NULL, NULL);
         New(0, mfb, nSize, LPVOID);
         nSize = GetMetaFileBitsEx(hemf, nSize, mfb);
         hemf = SetWinMetaFileBits(nSize, mfb, hdc, &mfp);
         Safefree(mfb);
      }
      RETVAL = hemf;
    OUTPUT:
      RETVAL

HENHMETAFILE
_GetEnhMetaFile(lpszMetaFile)
      LPCTSTR lpszMetaFile;
    PREINIT:
      HENHMETAFILE hemf;
      char *dir = PerlEnv_get_childdir();
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
      char *dir = PerlEnv_get_childdir();
      int Image;
      BITMAPINFO *lpbmi;
      HMODULE hFreeImage = NULL;
      PROC fnFreeImage_Load = NULL;
      PROC fnFreeImage_GetFileType = NULL;
      PROC fnFreeImage_Unload = NULL;
      PROC fnFreeImage_GetInfo = NULL;
      PROC fnFreeImage_GetBits = NULL;
    CODE:
      RETVAL = NULL;
      hFreeImage = LoadLibrary("FreeImage.dll");
      if (hFreeImage) {
         fnFreeImage_Load = GetProcAddress(hFreeImage, "_FreeImage_Load@12");
         fnFreeImage_GetFileType = GetProcAddress(hFreeImage, "_FreeImage_GetFileType@8");
         fnFreeImage_GetInfo = GetProcAddress(hFreeImage, "_FreeImage_GetInfo@4");
         fnFreeImage_GetBits = GetProcAddress(hFreeImage, "_FreeImage_GetBits@4");
         fnFreeImage_Unload = GetProcAddress(hFreeImage, "_FreeImage_Unload@4");
         if (fnFreeImage_Load && fnFreeImage_GetFileType && fnFreeImage_GetInfo && fnFreeImage_GetBits && fnFreeImage_Unload) {
            SetCurrentDirectory(dir);
            if (Type == -1) {
               Image = fnFreeImage_Load(fnFreeImage_GetFileType(BmpFile, 16), BmpFile, 0);
            } else {
               Image = fnFreeImage_Load(Type, BmpFile, 0);
            }
            if (Image) {
               lpbmi = (BITMAPINFO *) fnFreeImage_GetInfo(Image);
               hdc = CreateEnhMetaFile(hdc, (LPCTSTR) NULL, NULL, (LPCTSTR) NULL);
               StretchDIBits(hdc, 0, 0, lpbmi->bmiHeader.biWidth, lpbmi->bmiHeader.biHeight, 0, 0, lpbmi->bmiHeader.biWidth, lpbmi->bmiHeader.biHeight, (CONST VOID *) fnFreeImage_GetBits(Image), lpbmi, DIB_RGB_COLORS, SRCCOPY);
               RETVAL = CloseEnhMetaFile(hdc);
               fnFreeImage_Unload(Image);
            } else {
               if (!GetLastError()) {
                  SetLastError(ERROR_INVALID_DATA);
               }
            }
         }
         FreeLibrary(hFreeImage);
      }
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

BOOL
_DeleteEnhMetaFile(hemf)
      HENHMETAFILE hemf;
    CODE:
      RETVAL = DeleteEnhMetaFile(hemf);
    OUTPUT:
      RETVAL
