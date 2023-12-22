@echo off
REM 	Save of initial PATH on PATHINIT variable
set PATHINIT=%PATH%
REM      Mandatory, add to PATH the binary directory of compiler Digital Mars (You can adapt this directory at your personal software environment)
set PATH=C:\TDM-GCC-64\bin;%PATH%
g++ -c -DBUILDING_EXAMPLE_DLL example_dll.cpp -o example_dll64.o
g++ -shared -o example_dll64.dll example_dll64.o -Wl,--out-implib,libexample_dll64.a
g++ -c example_exe.cpp -o example_exe64.o
g++ -o example_exe64.exe example_exe64.o -L. -lexample_dll64
example_exe64.exe
set PATH=%PATHINIT%
