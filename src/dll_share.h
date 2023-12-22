//**********************  File : dll_share.h (include file shared beetween build or use DLL)  ****************
#ifndef DLLCODE_H
#define DLLCODE_H

/* Test Windows platform */

#if defined(__NT__) || defined(_WIN32) || defined(_Windows) // __NT__ with OpenWatcom, _WIN32 with GCC, MSVC, clang, Pelles C, lcc (?) _Windows with Borland C/C++ defined Windows Platforms

  /* You should define BUILD_DLL *only* when building the DLL. */
  
  #ifdef BUILD_DLL
    #define FUNCAPI  __declspec(dllexport)
  #else
    #define FUNCAPI  __declspec(dllimport)
  #endif

  /* Define calling convention in one place, for convenience. */
  #if defined(__LCC__) // || defined(__WATCOMC__)
    #define  _stdcall
  #elif defined (__BORLANDC__) || defined(__POCC__)
    #define FUNCALL __stdcall
  #else	
    #define FUNCALL __cdecl
  # endif

#elif defined(_linux) || defined(UNIX)

	#if defined(BUILD_DLL) && defined(HAS_GCC_VISIBILITY)
	#   define FUNCAPI  _attribute_  _((visibility("default")))
	#endif

#else /* __NT__ or _WIN32 or _Windows or _Linux not defined. */

  /* Define with no value on non-Windows OSes. */
  #define FUNCAPI
  #define FUNCALL

#endif

/* if used by C++ code, identify these functions as C items */
#ifdef __cplusplus
extern "C" {
#endif

/*------------------------------------------------------------------------

 Another instructions : 		declarations of exported functions of DLL. 
 
 All functions must be declared here, but instancied in file dll_core.c. 
 Noted prefix FUNCAPI valued at :
		__declspec(dllexport) when generate DLL (define BUILD_DLL)
		__declspec(dllimport) when use DLL (not define BUILD_DLL)
 
------------------------------------------------------------------------*/

FUNCAPI int Hello();
FUNCAPI int Addint(int i1, int i2);
FUNCAPI int Subint(int i1, int i2);
FUNCAPI int Multint(int i1, int i2);
FUNCAPI int Divint(int i1, int i2);
FUNCAPI int Squarint(int i);
FUNCAPI double Adddbl(double i1, double i2);
FUNCAPI double Subdbl(double i1, double i2);
FUNCAPI double Multdbl(double i1, double i2);
FUNCAPI double Divdbl(double i1, double i2);
FUNCAPI double Squardbl(double i);

#ifdef __cplusplus
}
#endif

#endif
//*****************************          End file : dll_share.h           *****************************

