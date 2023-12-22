//   *****************************        File : example_exe.cpp (program test of dll)       **********************************
#include <stdio.h>
#include "example_dll.h"

int main(void)
{
        hello("World");
        printf("%d\n", Double(333));
        CppFunc();

        MyClass a;
        a.func();

        return 0;
}
//   *******************************                 End file : example_exe.cpp              **********************************
