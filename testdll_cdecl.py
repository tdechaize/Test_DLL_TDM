# **************************************     File : testdll_cdecl.py     ******************************
#testdll_cdecl.py
import ctypes, ctypes.util
import os
import sys

if len( sys.argv ) == 1:
    print( "testdll_cdecl.py script wrote by Thierry DECHAIZE, thierry.dechaize@gmail.com" )
    print( "\tusage: python test_add_cdecl.py Name_of_Dll." )
    exit()

cwd = os.getcwd()
dll_name = cwd + '\\' + sys.argv[1]
mydll_path = ctypes.util.find_library(dll_name)
if not mydll_path:
    print("Unable to find the specified DLL.")
    sys.exit()
  
#mydll = ctypes.WinDLL(dll_name)          # load the dll __stdcall  
try:    
    mydll = ctypes.CDLL(dll_name)      # load the dll __cdecl
except OSError:
    print(f"Unable to load the specified DLL : {sys.argv[1]}.")
    sys.exit()
    
# test mandatory in case of Borland generation, the export function is decorated by "_" prefix  => call _Add
if 'BC55' in sys.argv[1]  or 'PELLESC64' in sys.argv[1] or 'OW32' in sys.argv[1]: 
#   mydll._Hello(None)
    print(f"----------------------       Lancement des operations arithmetiques avec des entiers        -----------------------");
    mydll._Addint.argtypes = [ctypes.c_int, ctypes.c_int]
    print(f"La somme de 42 plus 7 vaut {mydll._Addint(42, 7)}. (from script python {sys.argv[0]})")
    mydll._Subint.argtypes = [ctypes.c_int, ctypes.c_int]
    print(f"La difference de 42 moins 7 vaut {mydll._Subint(42, 7)}. (from script python {sys.argv[0]})")
    mydll._Multint.argtypes = [ctypes.c_int, ctypes.c_int]
    print(f"La multiplication de 42 par 7 vaut {mydll._Multint(42, 7)}. (from script python {sys.argv[0]})")
    mydll._Divint.argtypes = [ctypes.c_int, ctypes.c_int]
    mydll._Divint.restype = ctypes.c_int
    result = mydll._Divint(42,7)
    print(f"La division de 42 par 7 vaut {result}.                 (from script python {sys.argv[0]})")
    mydll.Squareint.argtypes = [ctypes.c_int]
    print(f"Le carre de 7 par 7 vaut {mydll._Squarint(7)}. (from script python {sys.argv[0]})")
    print(f"----------------------    Lancement des operations arithmetiques avec des doubles flottants   ---------------------");
    mydll._Adddbl.argtypes = [ctypes.c_double, ctypes.c_double]
    mydll._Adddbl.restype = ctypes.c_double
    print(f"La somme de 16.9 plus 7.3 vaut {mydll._Adddbl(16.9, 7.3)}. (from script python {sys.argv[0]})")
    mydll._Subdbl.argtypes = [ctypes.c_double, ctypes.c_double]
    mydll._Subdbl.restype = ctypes.c_double
    print(f"La difference de 16.9 moins 7.3 vaut {mydll._Subdbl(16.9, 7.3)}. (from script python {sys.argv[0]})")
    mydll._Multdbl.argtypes = [ctypes.c_double, ctypes.c_double]
    mydll._Multdbl.restype = ctypes.c_double
    print(f"La multiplication de 16.9 par 7.3 vaut {mydll._Multdbl(16.9, 7.3)}. (from script python {sys.argv[0]})")
    mydll._Divdbl.argtypes = [ctypes.c_double, ctypes.c_double]
    mydll._Divdbl.restype = ctypes.c_double
    print(f"La division de 16.9 par 7.3 vaut {"{0:g}".format(mydll._Divdbl(16.9, 7.3))}.             (from script python {sys.argv[0]})")
    mydll._Squardbl.argtypes = [ctypes.c_double]
    mydll._Squardbl.restype = ctypes.c_double
    print(f"Le carre de 7.3 par 7.3 vaut {mydll._Squardbl(7.3)}. (from script python {sys.argv[0]})")
else:
    mydll.Hello(None)
    print(f"----------------------       Lancement des operations arithmetiques avec des entiers        -----------------------");
    mydll.Addint.argtypes = [ctypes.c_int, ctypes.c_int]
    mydll.Addint.restype = ctypes.c_int
    result = mydll.Addint(42,7)
    print(f"La somme de 42 plus 7 vaut {result}.                  (from script python {sys.argv[0]})")
    mydll.Subint.argtypes = [ctypes.c_int, ctypes.c_int]
    mydll.Subint.restype = ctypes.c_int
    result = mydll.Subint(42,7)
    print(f"La difference de 42 moins 7 vaut {result}.            (from script python {sys.argv[0]})")
    mydll.Multint.argtypes = [ctypes.c_int, ctypes.c_int]
    mydll.Multint.restype = ctypes.c_int
    result = mydll.Multint(42,7)
    print(f"La multiplication de 42 par 7 vaut {result}.         (from script python {sys.argv[0]})")
    mydll.Divint.argtypes = [ctypes.c_int, ctypes.c_int]
    mydll.Divint.restype = ctypes.c_int
    result = mydll.Divint(42,7)
    print(f"La division de 42 par 7 vaut {result}.                 (from script python {sys.argv[0]})")
    mydll.Squarint.argtypes = [ctypes.c_int]
    mydll.Squarint.restype = ctypes.c_int
    result = mydll.Squarint(7)
    print(f"Le carre de 7 par 7 vaut {result}.                    (from script python {sys.argv[0]})")
    print(f"----------------------    Lancement des operations arithmetiques avec des doubles flottants   ---------------------");
    mydll.Adddbl.argtypes = [ctypes.c_double, ctypes.c_double]
    mydll.Adddbl.restype = ctypes.c_double
    print(f"La somme de 16.9 plus 7.3 vaut {mydll.Adddbl(16.9, 7.3)}.                  (from script python {sys.argv[0]})")
    mydll.Subdbl.argtypes = [ctypes.c_double, ctypes.c_double]
    mydll.Subdbl.restype = ctypes.c_double
    print(f"La difference de 16.9 moins 7.3 vaut {"{0:g}".format(mydll.Subdbl(16.9, 7.3))}.             (from script python {sys.argv[0]})")
    mydll.Multdbl.argtypes = [ctypes.c_double, ctypes.c_double]
    mydll.Multdbl.restype = ctypes.c_double
    print(f"La multiplication de 16.9 par 7.3 vaut {"{0:g}".format(mydll.Multdbl(16.9, 7.3))}.        (from script python {sys.argv[0]})")
    mydll.Divdbl.argtypes = [ctypes.c_double, ctypes.c_double]
    mydll.Divdbl.restype = ctypes.c_double
    print(f"La division de 16.9 par 7.3 vaut {"{0:g}".format(mydll.Divdbl(16.9, 7.3))}.             (from script python {sys.argv[0]})")
    mydll.Squardbl.argtypes = [ctypes.c_double]
    mydll.Squardbl.restype = ctypes.c_double
    print(f"Le carre de 7.3 par 7.3 vaut {"{0:g}".format(mydll.Squardbl(7.3))}.                   (from script python {sys.argv[0]})")
# **************************************      End file : testdll_cdecl.py      ******************************

