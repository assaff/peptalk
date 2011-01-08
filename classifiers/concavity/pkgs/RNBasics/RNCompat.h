/* Include file for machine dependent switches */



/************************************************************************* 
Compile Switches:
*************************************************************************/

#define RN_NULL 0



/* Operating system selection */

#define RN_IRIX 1
#define RN_WINDOWSNT 2
#define RN_LINUX 3

#ifdef _WIN32
#  define RN_OS RN_WINDOWSNT
#else 
#  ifdef RN_USE_SGI
#    define RN_OS RN_IRIX
#  else 
#    define RN_OS RN_LINUX
#  endif
#endif



/* Compiler selection */

#define RN_CFRONT 1
#define RN_MSVC 2
#define RN_NCC 3
#define RN_GCC 4
#if (RN_OS == RN_IRIX)
#   define RN_CC RN_NCC
#elif (RN_OS == RN_WINDOWSNT)
#   define RN_CC RN_MSVC
#else
#   define RN_CC RN_NULL
#endif



/* Graphics library selection */

#define RN_IRISGL 1
#define RN_OPENGL 2
#define RN_3DR 3
#define RN_XLIB 4
#ifdef RN_USE_IRISGL
#   define RN_2D_GRFX RN_IRISGL
#   define RN_3D_GRFX RN_IRISGL
#else
#   ifdef RN_USE_OPENGL
#       define RN_2D_GRFX RN_OPENGL
#       define RN_3D_GRFX RN_OPENGL
#   else
#       define RN_2D_GRFX RN_OPENGL
#       define RN_3D_GRFX RN_OPENGL
#   endif
#endif



/* Math precision selection */

#define RN_FLOAT_PRECISION 1
#define RN_DOUBLE_PRECISION 2
#ifdef RN_USE_SINGLE_PRECISION
#   define RN_MATH_PRECISION RN_FLOAT_PRECISION
#else
#   define RN_MATH_PRECISION RN_DOUBLE_PRECISION
#endif



/************************************************************************* 
Compatability definitions
*************************************************************************/

/* Compiler dependent flags */

#if ((RN_OS == RN_IRIX) && (RN_CC == RN_CFRONT))
#   define _SVR4_SOURCE
#   define _SGI_SOURCE
#   define _BSD_COMPAT
#endif

#if (RN_CC == RN_MSVC)
#   pragma warning(disable : 4244) // Cast of double literals to float
#   pragma warning(disable : 4305) // Cast of double literals to float
#   define _WIN32_WINNT 0x400  // Include newer windows sockets header files
#endif

#if (RN_CC == RN_MSVC)
#define _CRT_SECURE_CPP_OVERLOAD_STANDARD_NAMES 1
#define _CRT_SECURE_NO_WARNINGS 1
#endif
