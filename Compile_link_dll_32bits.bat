@echo off
REM 	Save of initial PATH on PATHINIT variable
set PATHINIT=%PATH%
REM      Mandatory, add to PATH the binary directory of compiler Digital Mars (You can adapt this directory at your personal software environment)
set PATH=C:\TDM-GCC-32\bin;%PATH%
g++ -c -DBUILDING_EXAMPLE_DLL example_dll.cpp
g++ -shared -o example_dll.dll example_dll.o -Wl,--out-implib,libexample_dll.a
g++ -c example_exe.cpp
g++ -o example_exe.exe example_exe.o -L. -lexample_dll
example_exe.exe
set PATH=%PATHINIT%
