# **************************************     File : testdll_stdcall.py     ******************************
#test_add_stdcall.py
import ctypes, ctypes.util
import os
import sys
if len( sys.argv ) == 1:
    print( "test_add_stdcall.py script wrote by Thierry DECHAIZE, thierry.dechaize@gmail.com" )
    print( "\tusage: python3 test_add.py Name_Dll." )
    exit()

cwd = os.getcwd()
dll_name = cwd + '\\' + sys.argv[1]
print(dll_name)
mydll_path = ctypes.util.find_library(dll_name)
if not mydll_path:
    print("Unable to find the specified DLL.")
    sys.exit()
    
os.add_dll_directory(cwd)
# mydll = ctypes.CDLL(dll_name)          # load the dll __cdecl    
try:    
    mydll = ctypes.WinDLL(dll_name)      # load the dll __stdcall
except OSError:
    print(f"Unable to load the specified DLL : {dll_name}.")
    sys.exit()

# test mandatory in case of Borland generation, the export function is decorated by "_" prefix => call _Add
#if 'BC55' in sys.argv[1]:
#    mydll._Add.argtypes = (ctypes.c_int, ctypes.c_int)
#    print(f"La somme de 42 plus 7 vaut {mydll._Add(42, 7)}. (from script python {sys.argv[0]})")
#else:
mydll.Hello(None)
print(f"----------------------       Lancement des operations arithmetiques avec des entiers        -----------------------");
mydll.Addint.argtypes = [ctypes.c_int, ctypes.c_int]
print(f"La somme de 42 plus 7 vaut {mydll.Addint(42, 7)}. (from script python {sys.argv[0]})")
mydll.Subint.argtypes = [ctypes.c_int, ctypes.c_int]
print(f"La difference de 42 moins 7 vaut {mydll.Subint(42, 7)}. (from script python {sys.argv[0]})")
mydll.Multint.argtypes = [ctypes.c_int, ctypes.c_int]
print(f"La multiplication de 42 par 7 vaut {mydll.Multint(42, 7)}. (from script python {sys.argv[0]})")
#   mydll.Squarint.argtypes = [ctypes.c_int]   Not mandatory here !
print(f"Le carre de 7 par 7 vaut {mydll.Squarint(7)}. (from script python {sys.argv[0]})")
print(f"----------------------    Lancement des operations arithmetiques avec des doubles flottants   ---------------------");
mydll.Adddbl.argtypes = [ctypes.c_double, ctypes.c_double]
mydll.Adddbl.restype = ctypes.c_double
print(f"La somme de 16.9 plus 7.3 vaut {mydll.Adddbl(16.9, 7.3)}. (from script python {sys.argv[0]})")
mydll.Subdbl.argtypes = [ctypes.c_double, ctypes.c_double]
mydll.Subdbl.restype = ctypes.c_double
print(f"La difference de 16.9 moins 7.3 vaut {mydll.Subdbl(16.9, 7.3)}. (from script python {sys.argv[0]})")
mydll.Multdbl.argtypes = [ctypes.c_double, ctypes.c_double]
mydll.Multdbl.restype = ctypes.c_double
print(f"La multiplication de 16.9 par 7.3 vaut {mydll.Multdbl(16.9, 7.3)}. (from script python {sys.argv[0]})")
mydll.Squardbl.argtypes = [ctypes.c_double]
mydll.Squardbl.restype = ctypes.c_double
print(f"Le carre de 7.3 par 7.3 vaut {mydll.Squardbl(7.3)}. (from script python {sys.argv[0]})")
# ************************************      End file : testdll_sdtcall.py      ****************************