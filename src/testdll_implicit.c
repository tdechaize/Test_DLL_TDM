//*********************  File : testdll_implicit.c (program main test of dll, with load implicit)  *****************
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdlib.h>
#include <stdio.h>
#include "dll_share.h"

int main(int argc, char** argv)
{
  int a = 42;
  int b = 7;
  int result = 0;
  double a1 = 16.9;
  double b1 = 7.3;
  double result1 = 0.0;
  
  Hello();
  printf("----------------------       Lancement des operations arithmetiques avec des entiers        -----------------------\n");
  result = Addint(a, b);
  printf("Le resultat de l'addition de %i plus %i vaut : %i. \t (from application with implicit load of DLL %s)\n", a,b,result,argv[0]);
  result = Subint(a, b);
  printf("Le resultat de la soustraction de %i moins %i vaut : %i.  (from application with implicit load of DLL %s)\n", a,b,result,argv[0]);
  result = Multint(a, b);
  printf("Le resultat de la multiplication de %i par %i vaut : %i. (from application with implicit load of DLL %s)\n", a,b,result,argv[0]);
  result = Divint(a, b);
  printf("Le resultat de la division de %i par %i vaut : %i.         (from application with implicit load of DLL %s)\n", a,b,result,argv[0]);
  result = Squarint(b);
  printf("Le carre de %i par %i vaut : %i. \t\t\t\t (from application with implicit load of DLL %s)\n", b,b,result,argv[0]);
  printf("----------------------    Lancement des operations arithmetiques avec des doubles flottants   ---------------------\n");
  result1 = Adddbl(a1, b1);
  printf("La somme de %.1f plus %.1f vaut %.2f. \t       (from application with implicit load of DLL %s)\n", a1,b1,result1,argv[0]);
  result1 = Subdbl(a1, b1);
  printf("La soustraction de %.1f moins %.1f vaut %.2f.   (from application with implicit load of DLL %s)\n", a1,b1,result1,argv[0]);
  result1 = Multdbl(a1, b1);
  printf("La multiplication de %.1f par %.1f vaut %.2f. (from application with implicit load of DLL %s)\n", a1,b1,result1,argv[0]);
  result1 = Divdbl(a1, b1);
  printf("La division de %.1f par %.1f vaut %.3f.        (from application with implicit load of DLL %s)\n", a1,b1,result1,argv[0]);
  result1 = Squardbl(b1);
  printf("Le carre de %.1f par %.1f vaut %.2f. \t       (from application with implicit load of DLL %s)\n", b1,b1,result1,argv[0]);	

  return EXIT_SUCCESS;
}
// ****************************************   End file : testdll_implicit.c   *******************************************
