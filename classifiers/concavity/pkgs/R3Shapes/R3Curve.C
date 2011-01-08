/* Source file for the R3 curve class */



/* Include files */

#include "R3Shapes/R3Shapes.h"



/* Public functions */

int 
R3InitCurve()
{
    /* Return success */
    return TRUE;
}



void 
R3StopCurve()
{
}



R3Curve::
R3Curve(void)
{
}



R3Curve::
~R3Curve(void)
{
}



const RNBoolean R3Curve::
IsCurve(void) const
{
    // All curve shapes are curves
    return TRUE;
}




