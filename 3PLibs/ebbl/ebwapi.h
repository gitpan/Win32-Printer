////////////////////////////////////////////////////////////////////////////////
//									      //
//  ebwinapi.cpp 2004-08-11						      //
//  Copyright (c) 2003-2004, Edgars Binans				      //
//									      //
//  Web: http://www.wasx.net	Mail: admin@wasx.net			      //
//									      //
////////////////////////////////////////////////////////////////////////////////

#ifndef ebbl_WIN_API
#define ebbl_WIN_API

#define WIN32_LEAN_AND_MEAN
#define VC_EXTRALEAN

#include <windows.h>

#ifdef WIN_EXPORT
  #define WIN_API __declspec(dllexport)
#else
  #ifdef WIN_IMPORT
    #define WIN_API __declspec(dllimport)
  #else
    #define WIN_API
  #endif
#endif

#ifdef WIN_EXPORTS
BOOL APIENTRY DllMain(HANDLE, DWORD  ul_reason_for_call, LPVOID)
{
  switch (ul_reason_for_call) {
    case DLL_PROCESS_ATTACH:
    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:
    case DLL_PROCESS_DETACH:
    break;
  }
  return TRUE;
}
#endif

#endif
