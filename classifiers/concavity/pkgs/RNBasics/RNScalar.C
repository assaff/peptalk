/* Source file for GAPS scalar class  */



/* Include files */

#include "RNBasics/RNBasics.h"



/* Public scalar variables */

#if (RN_MATH_PRECISION == RN_FLOAT_PRECISION)
    RNScalar RN_SMALL_EPSILON = 1.0E-4;
    RNScalar RN_EPSILON = 1.0E-3;
    RNScalar RN_BIG_EPSILON = 1.0E-2;
    RNScalar RN_INFINITY = 2.0E4;
#else
    RNScalar RN_SMALL_EPSILON = 1.0E-9;
    RNScalar RN_EPSILON = 1.0E-6;
    RNScalar RN_BIG_EPSILON = 1.0E-3;
    RNScalar RN_INFINITY = 1.0E6;
#endif



/* Useful variables */

const RNScalar RN_E = 2.7182818284590452354;
const RNScalar RN_PI = 3.14159265358979323846;
const RNScalar RN_PI_OVER_FOUR = 0.25 * RN_PI;
const RNScalar RN_PI_OVER_TWO = 0.5 * RN_PI;
const RNScalar RN_THREE_PI_OVER_TWO = 1.5 * RN_PI;
const RNScalar RN_TWO_PI = 2.0 * RN_PI;
const RNScalar RN_ONE_OVER_PI = 1.0 / RN_PI;
const RNScalar RN_SQRT_TWO = 1.4142136;
const RNScalar RN_SQRT_THREE = 1.7320508;



int RNInitScalar() 
{
    /* Return OK status */
    return TRUE;
}



void RNStopScalar()
{
}



void
RNSetInfinity(RNScalar infinity)
{
    // Set scalar range
    RN_INFINITY = infinity;
#   if (RN_MATH_PRECISION == RN_FLOAT_PRECISION)
       RN_EPSILON = 1.0E-6 * infinity;
       RN_SMALL_EPSILON = 0.1 * RN_EPSILON;
       RN_BIG_EPSILON = 10.0 * RN_EPSILON;
#   else 
       RN_EPSILON = 1.0E-10 * infinity;
       RN_SMALL_EPSILON = 0.1 * RN_EPSILON;
       RN_BIG_EPSILON = 10.0 * RN_EPSILON;
#endif    
}



void
RNSetEpsilon(RNScalar epsilon)
{
    // Set scalar range
    RN_EPSILON = epsilon;
#   if (RN_MATH_PRECISION == RN_FLOAT_PRECISION)
       RN_INFINITY = 1.0E7 * epsilon;
       RN_SMALL_EPSILON = 0.1 * RN_EPSILON;
       RN_BIG_EPSILON = 10.0 * RN_EPSILON;
#   else 
       RN_INFINITY = 1.0E10 * epsilon;
       RN_SMALL_EPSILON = 0.1 * RN_EPSILON;
       RN_BIG_EPSILON = 10.0 * RN_EPSILON;
#endif    
}



int RNCompareScalars(const void *value1, const void *value2)
{
  const RNScalar *scalar1 = (const RNScalar *) value1;
  const RNScalar *scalar2 = (const RNScalar *) value2;
  if (*scalar1 < *scalar2) return -1;
  else if (*scalar1 > *scalar2) return 1;
  else return 0;
}



