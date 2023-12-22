@echo off
REM
REM   	Script de génération de la DLL dll_core.dll et des programmee de test : "testdll_implicit.exe" (chargement implicite de la DLL),
REM 	"testdll_explicit.exe" (chargement explicite de la DLL), et enfin du script de test écrit en python.
REM		Ce fichier de commande est paramètrable avec deux paraamètres : 
REM			a) le premier paramètre permet de choisir la compilation et le linkage des programmes en une seule passe
REM 			soit la compilation et le linkage en deux passes successives : compilation séparée puis linkage,
REM 		b) le deuxième paramètre définit soit une compilation et un linkage en mode 32 bits, soit en mode 64 bits
REM 	 		pour les compilateurs qui le supportent.
REM     Le premier paramètre peut prendre les valeurs suivantes :
REM 		ONE (or unknown value, because only second value of this parameter is tested during execution) ou TWO.
REM     Et le deuxième paramètre peut prendre les valeurs suivantes :
REM 		32, 64 ou  ALL si vous souhaitez lancer les deux générations, 32 bits et 64 bits.
REM
REM 	Author : 						Thierry DECHAIZE
REM		Date creation/modification : 	21/12/2023
REM 	Reason of modifications : 	n° 1 - Blah Blah Blah ...
REM 	 							n° 2 - Blah Blah Blah ...
REM 	Version number :				1.1.1	          	(version majeure . version mineure . patch level)

echo. Lancement du batch de generation d'une DLL et deux tests de celle-ci avec TDM GCC 32 bits ou 64 bits 
REM     Affichage du nom du système d'exploitation Windows :              			Microsoft Windows 11 Famille (par exemple)
REM 	Affichage de la version du système Windows :              					10.0.22621 (par exemple)
REM 	Affichage de l'architecture du processeur supportant le système Windows :   64-bit (par exemple)    
echo.  *********  Quelques caracteristiques du systeme hebergeant l'environnement de developpement.   ***********
WMIC OS GET Name
WMIC OS GET Version
WMIC OS GET OSArchitecture

REM 	Save of initial PATH on PATHINIT variable
set PATHINIT=%PATH%
echo.  **********      Pour cette generation le premier parametre vaut "%1" et le deuxieme "%2".     ************* 
IF "%2" == "32" ( 
   call :complink32 %1
) ELSE (
   IF "%2" == "64" (
      call :complink64 %1	  
   ) ELSE (
      call :complink32 %1
	  call :complink64 %1
	)  
)

goto FIN

:complink32
echo.  ******************              Compilation de la DLL en mode 32 bits             *******************
set "PAR1=%~1"
REM Mandatory, add to PATH the binary directory of compiler TDM GCC 32 bits. You can adapt this directory at your personal software environment.
SET PATH=C:\TDM-GCC-32\bin;C:\Outils\pexports-0.43\bin;%PATH%
gcc --version | find "gcc"
if "%PAR1%" == "TWO" (
echo.  ***************************          Generation de la DLL en deux passes          *******************
REM Options used with CLANG/LLVM compiler 64 bits (very similar with syntax of gcc compiler) :
REM 	-Wall									-> set all warning during compilation
REM		-c 										-> compile and assemble only, not call of linker
REM 	-o dll_core64.obj 						-> output of object file indicated just after this option 
REM 	-Dxxxxxx								-> define variable xxxxxx used by preprocessor of compiler CLANG C/C++
REM 	-IC:\TDM-GCC-32\lib\clang\17\include -> set the include path directory (you can add many option -Ixxxxxxx to adapt your list of include path directories)  
REM 				Remark 1 : You can replace option by  to "force" compilation or linkage to X64 architecture
echo.  ***************       Compilation de la DLL avec TDM GCC 32 bits              *****************
gcc -Wall -c -o dll_core.obj src\dll_core.c -DBUILD_DLL -D_WIN32 -DNDEBUG -IC:\TDM-GCC-32\include
REM Options used with linker CLANG/LLVM 64 bits (very similar with syntax of gcc compiler) :
REM 	-s 										-> "s[trip]", remove all symbol table and relocation information from the executable.
REM		-shared									-> generate a shared library => on Window, generate a DLL (Dynamic Linked Library)
REM 	-LC:\TDM-GCC-32\lib					-> -Lxxxxxxxxxx set library path directory to xxxxxxxxxxx (you can add many option -Ixxxxxxx to adapt your list of library path directories)  
REM		-Wl,--output-def=dll_core.def  			-> set the output definition file, normal extension is xxxxx.def
REM		-Wl,--out-implib=libdll_core.a 			-> set the output library file. On Window, you can choose library name beetween "normal name" (xxxxx.lib), or gnu library name (libxxxxx.a)
REM		-Wl,--dll								-> -Wl,... set option ... to the linker, here determine subsystem to windows DLL
REM 	-o dll_core.dll							-> output of executable file indicated just after this option, here relative name of DLL
REM		-lkernel32 -luser32						-> -lxxxxxxxx set library used by linker to xxxxxxxxx
echo.  ***************          Edition de liens de la DLL avec MSYS2  CLANG 32 bits        *******************
gcc -s -shared -LC:\TDM-GCC-32\lib -LC:\TDM-GCC-32\lib -Wl,--output-def=dll_core.def -Wl,--out-implib=libdll_core.dll.a -Wl,--dll -o dll_core.dll -lkernel32 -luser32 dll_core.obj 
echo.  ***************          Listage des symboles exportes dans le fichier de definition           *******************
type dll_core.def
echo.  ***************              Listage des fonctions exportees de la DLL              *******************
REM  dump result of command "gendef" to stdout, here, with indirection of output, generate file dll_core_2.def
pexports dll_core.dll
echo.  ************     Generation et lancement du premier programme de test de la DLL en mode implicite.      *************
gcc -c -DNDEBUG -D_WIN32 -o testdll_implicit.o src\testdll_implicit.c
REM 	Options used by linker of CLANG/LLVM compiler
REM 		-s 									-> Strip output file, here dll file.
REM 		-L.									-> indicate library search path on current directory (presence of dll generatd just before)
gcc -o testdll_implicit.exe -s testdll_implicit.o -L. dll_core.dll
REM 	Run test program of DLL with implicit load
testdll_implicit.exe
echo.  ************     Generation et lancement du deuxieme programme de test de la DLL en mode explicite.     ************
gcc -c -DNDEBUG -D_WIN32 -o testdll_explicit.o src\testdll_explicit.c
gcc -o testdll_explicit.exe -s testdll_explicit.o
REM 	Run test program of DLL with explicit load
testdll_explicit.exe						
 ) ELSE (
echo.  ***************************                Generation de la DLL en une passe                    *******************
REM     Options used by GCC compiler 32 bits of MingW32 included in Winlibs
REM 		-Dxxxxx	 					-> Define variable xxxxxx used by precompiler, here define to build dll with good prefix of functions exported (or imported)
REM 		-shared						-> Set option to generate shared library .ie. on windows systems DLL
REM 		-o xxxxx 					-> Define output file generated by GCC compiler, here dll file
REM 		-Wl,xxxxxxxx				-> Set options to linker : here, first option to generate def file, second option to generate lib file 
gcc -DBUILD_DLL -DNDEBUG -D_WIN32 -shared -o dll_core.dll -Wl,--output-def=dll_core.def -Wl,--out-implib,libdll_core.dll.a src\dll_core.c 
echo.  ***************          Listage des symboles exportes dans le fichier de definition           *******************
type dll_core.def
REM    Show list of exported symbols from a dll 
echo.  ************     				 Dump des sysboles exportes de la DLL dll_core.dll      				  *************
pexports dll_core.dll
echo.  ************     Generation et lancement du premier programme de test de la DLL en mode implicite.      *************
gcc -DNDEBUG -D_WIN32 src\testdll_implicit.c -L. -o testdll_implicit.exe dll_core.dll
REM 	Run test program of DLL with implicit load
testdll_implicit.exe
echo.  ************     Generation et lancement du deuxieme programme de test de la DLL en mode explicite.     ************
gcc -DNDEBUG src\testdll_explicit.c -o testdll_explicit.exe
REM 	Run test program of DLL with explicit load
testdll_explicit.exe
)
echo.  ****************               Lancement du script python 32 bits de test de la DLL.               ********************
%PYTHON32% version.py
REM 	Run test python script of DLL with explicit load
%PYTHON32% testdll_cdecl.py dll_core.dll 
REM 	Return in initial PATH
set PATH=%PATHINIT%
exit /B 

:complink64
echo.  ***************************          Compilation de la DLL en mode 64 bits        *******************
set "PAR1=%~1"
REM      Mandatory, add to PATH the binary directory of compiler CLANG 64 bits included in MSYS2. You can adapt this directory at your personal software environment.
SET PATH=C:\TDM-GCC-64\bin;C:\Outils\pexports-0.43\bin;%PATH%
gcc --version | find "gcc"
if "%PAR1%" == "TWO" (
echo.  ***************************          Generation de la DLL en deux passes          *******************
REM Options used with CLANG/LLVM compiler 64 bits (very similar with syntax of gcc compiler) :
REM 	-Wall									-> set all warning during compilation
REM		-c 										-> compile and assemble only, not call of linker
REM 	-o dll_core64.obj 								-> output of object file indicated just after this option 
REM 	-Dxxxxxx								-> define variable xxxxxx used by preprocessor of compiler CLANG C/C++
REM 	-IC:\TDM-GCC-32\lib\clang\17\include -> set the include path directory (you can add many option -Ixxxxxxx to adapt your list of include path directories)  
REM 				Remark 1 : You can replace option  by to "force" compilation or linkage to X86 architecture
echo.  ***************       Compilation de la DLL avec TDM GCC 64 bits                   *****************
gcc -Wall -c -o dll_core64.obj src\dll_core.c -DBUILD_DLL -D_WIN32 -DNDEBUG  -IC:\TDM-GCC-64\include
REM Options used with linker CLANG/LLVM 64 bits (very similar with syntax of gcc compiler) :
REM 	-s 										-> "s[trip]", remove all symbol table and relocation information from the executable. 
REM		-shared									-> generate a shared library => on Window, generate a DLL (Dynamic Linked Library)
REM 	-LC:\TDM-GCC-64\lib					-> -Lxxxxxxxxxx set library path directory to xxxxxxxxxxx (you can add many option -Ixxxxxxx to adapt your list of library path directories)  
REM		-Wl,--output-def=dll_core64.def  		-> set the output definition file, normal extension is xxxxx.def
REM		-Wl,--out-implib=libdll_core64.dll.a-	-> set the output library file. On Window, you can choose library name beetween "normal name" (xxxxx.lib), or gnu library name (libxxxxx.a)
REM		-Wl,--dll								-> -Wl,... set option ... to the linker, here determine subsystem to windows DLL
REM		-lkernel32 -luser32						-> -lxxxxxxxx set library used by linker to xxxxxxxxx
echo.  ***************          Edition de liens de la DLL avec TDM GCC 64 bits      *******************
gcc -s -shared -LC:\TDM-GCC-64\lib -LC:\TDM-GCC-64\lib -Wl,--output-def=dll_core64.def -Wl,--out-implib=libdll_core64.dll.a -Wl,--dll -o dll_core64.dll  -lkernel32 -luser32 dll_core64.obj
echo.  ***************          Listage des symboles exportes dans le fichier de definition           *******************
type dll_core64.def
echo.  ***************            Listage des fonctions exportees de la DLL dll_core64.dll            *******************
REM  dump result of command "gendef" to stdout, here, with indirection of output ">", generate file dll_core64_2.def
pexports dll_core64.dll
echo.  ************     Generation et lancement du premier programme de test de la DLL en mode implicite.    *************
gcc -c -DNDEBUG -D_WIN32 -o testdll_implicit64.o  src\testdll_implicit.c
REM 	Options used by linker of CLANG/LLVM compiler
REM 		-s 									-> Strip output file, here dll file.
REM 		-L.									-> indicate library search path on current directory (presence of dll)
gcc -o testdll_implicit64.exe -s testdll_implicit64.o  -L. dll_core64.dll
REM 	Run test program of DLL with implicit load
testdll_implicit64.exe
echo.  ************     Generation et lancement du deuxieme programme de test de la DLL en mode explicite.   ************
gcc -c -DNDEBUG -D_WIN32  -o testdll_explicit64.o src\testdll_explicit.c
gcc -o testdll_explicit64.exe  -s testdll_explicit64.o
REM 	Run test program of DLL with explicit load
testdll_explicit64.exe					
 ) ELSE (
echo.  ***************************                Generation de la DLL en une passe                    *******************
REM     Options used by GCC compiler 64 bits of MingW64 included in Winlibs
REM 		-Dxxxxx	 					-> Define variable xxxxxx used by precompiler, here define to build dll with good prefix of functions exported (or imported)
REM 		-shared						-> Set option to generate shared library .ie. on windows systems DLL
REM 		-o xxxxx 					-> Define output file generated by GCC compiler, here dll file
REM		    -m64						-> set compilation and linkage to X64 Architecture (64 bits)
REM 		-Wl,xxxxxxxx				-> Set options to linker : here, first option to generate def file, second option to generate lib file 
gcc -DBUILD_DLL -DNDEBUG -D_WIN32 -shared -o dll_core64.dll  -Wl,--output-def=dll_core64.def -Wl,--out-implib,libdll_core64.dll.a src\dll_core.c
echo.  ***************          Listage des symboles exportes dans le fichier de definition           *******************
type dll_core64.def
REM    Show list of exported symbols from a dll 
echo.  ************     				 Dump des sysboles exportes de la DLL dll_core64.dll      		       *************
pexports dll_core64.dll
echo.  ************     Generation et lancement du premier programme de test de la DLL en mode implicite.      *************
gcc -DNDEBUG -D_WIN32 src\testdll_implicit.c  -L. -o testdll_implicit64.exe dll_core64.dll
REM 	Run test program of DLL with implicit load
testdll_implicit64.exe
echo.  ************     Generation et lancement du deuxieme programme de test de la DLL en mode explicite.     ************
gcc -DNDEBUG src\testdll_explicit.c  -o testdll_explicit64.exe
REM 	Run test program of DLL with explicit load
testdll_explicit64.exe
)					
echo.  ****************               Lancement du script python 64 bits de test de la DLL.               ********************
%PYTHON64% version.py
REM 	Run test python script of DLL with explicit load
%PYTHON64% testdll_cdecl.py dll_core64.dll
REM 	Return in initial PATH
set PATH=%PATHINIT%
exit /B 

:FIN
echo.              Fin de la generation de la DLL et des tests avec TDM GCC 32 bits ou 64 bits
