/* Include file for external stuff */



/* Standard dependency include files */

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <assert.h>
#include <string.h>
#include <ctype.h>
#include <math.h>
#include <limits.h>



/* Machine dependent include files */

#if !defined(__APPLE__)
#include <malloc.h>
#endif

#if (RN_OS == RN_WINDOWSNT)
#   include <float.h>
#   include <windows.h>
#endif

#if (RN_OS == RN_LINUX)
#   include <float.h>
#endif

#if ((RN_OS == RN_IRIX) || (RN_OS == RN_LINUX))
#   include <sys/time.h>
#endif


