//*********************  File : testdll_explicit.c (program main test of dll, with load explicit)  *****************
#include <stdio.h>
#include <stdint.h>
#include <windows.h>
// #include "dll_share.h"
 
typedef int (*HelloFunc)();
typedef int (*AddFuncint)(int,int);
typedef int (*SubFuncint)(int,int);
typedef int (*MulFuncint)(int,int);
typedef int (*DivFuncint)(int,int);
typedef int (*SquarFuncint)(int);
typedef double (*AddFuncdbl)(double,double);
typedef double (*SubFuncdbl)(double,double);
typedef double (*MulFuncdbl)(double,double);
typedef double (*DivFuncdbl)(double,double);
typedef double (*SquarFuncdbl)(double);


int main( int argc, char *argv[ ] )
{
	int a = 42;
	int b = 7;
	int result=0;
	double a1 = 16.9;
	double b1 = 7.3;
	double result1 = 0.0;

#if defined(__x86_64__) || defined(_M_X64) || defined(__amd64__)
	HINSTANCE hLib = LoadLibrary("dll_core64.dll");
#else
	HINSTANCE hLib = LoadLibrary("dll_core.dll");
#endif
	
	if (hLib != NULL) {

		HelloFunc af0 = (HelloFunc)GetProcAddress(hLib, "Hello");	
		AddFuncint af1 = (AddFuncint)GetProcAddress(hLib, "Addint");
		SubFuncint af2 = (SubFuncint)GetProcAddress(hLib, "Subint");	
		MulFuncint af3 = (MulFuncint)GetProcAddress(hLib, "Multint");
		DivFuncint af4 = (DivFuncint)GetProcAddress(hLib, "Divint");
		SquarFuncint af5 = (SquarFuncint)GetProcAddress(hLib, "Squarint");
		AddFuncdbl af6 = (AddFuncdbl)GetProcAddress(hLib, "Adddbl");
		SubFuncdbl af7 = (SubFuncdbl)GetProcAddress(hLib, "Subdbl");	
		MulFuncdbl af8 = (MulFuncdbl)GetProcAddress(hLib, "Multdbl");
		DivFuncdbl af9 = (DivFuncdbl)GetProcAddress(hLib, "Divdbl");
		SquarFuncdbl af10 = (SquarFuncdbl)GetProcAddress(hLib, "Squardbl");
	
		(*af0)();
		printf("----------------------       Lancement des operations arithmetiques avec des entiers        -----------------------\n");		
		result = (*af1)(a, b);
		printf("La somme de %i plus %i vaut %i. \t\t(from application with explicit load of DLL %s)\n", a,b,result,argv[0]);
		result = (*af2)(a, b);
		printf("La soustraction de %i moins %i vaut %i.  (from application with explicit load of DLL %s)\n", a,b,result,argv[0]);
		result = (*af3)(a, b);
		printf("La multiplication de %i par %i vaut %i. (from application with explicit load of DLL %s)\n", a,b,result,argv[0]);
		result = (*af4)(a, b);
		printf("La division de %i par %i vaut %i.         (from application with explicit load of DLL %s)\n", a,b,result,argv[0]);
		result = (*af5)(b);
		printf("Le carre de %i par %i vaut %i.\t\t(from application with explicit load of DLL %s)\n", b,b,result,argv[0]);
		printf("----------------------    Lancement des operations arithmetiques avec des doubles flottants   ---------------------\n");	
		result1 = (*af6)(a1, b1);
		printf("La somme de %.1f plus %.1f vaut %.2f. \t       (from application with explicit load of DLL %s)\n", a1,b1,result1,argv[0]);
		result1 = (*af7)(a1, b1);
		printf("La soustraction de %.1f moins %.1f vaut %.2f.   (from application with explicit load of DLL %s)\n", a1,b1,result1,argv[0]);
		result1 = (*af8)(a1, b1);
		printf("La multiplication de %.1f par %.1f vaut %.2f. (from application with explicit load of DLL %s)\n", a1,b1,result1,argv[0]);
		result1 = (*af9)(a1, b1);
		printf("La division de %.1f par %.1f vaut %.3f.        (from application with explicit load of DLL %s)\n", a1,b1,result1,argv[0]);
		result1 = (*af10)(b1);
		printf("Le carre de %.1f par %.1f vaut %.2f. \t       (from application with explicit load of DLL %s)\n", b1,b1,result1,argv[0]);	
		
		FreeLibrary(hLib);
		
	} else { 	
#if defined(__x86_64__) || defined(_M_X64) || defined(__amd64__)
		printf("Unable to load the specified DLL : dll_core64.dll.");
#else
		printf("Unable to load the specified DLL : dll_core.dll.");
#endif
	}
	
	return EXIT_SUCCESS;
}
// **************************************     End file : testdll_explicit.c     *******************************************
