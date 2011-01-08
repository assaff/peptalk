/* Source file for the R3 light class */



/* Include files */

#include "R3Graphics.h"



/* Class type definitions */

RN_CLASS_TYPE_DEFINITIONS(R3Light);



/* Public variables */

RNScalar R3ambient_light_intensity = 0.2;
RNRgb R3ambient_light_color(1.0, 1.0, 1.0);



/* Public functions */

int 
R3InitLight()
{
    /* Return success */
    return TRUE;
}



void 
R3StopLight()
{
}



R3Light::
R3Light(void)
  : id(0)
{
}



R3Light::
R3Light(const R3Light& light)
    : active(light.active),
      intensity(light.intensity),
      color(light.color),
      id(-1)
{
}



R3Light::
R3Light(const RNRgb& color,
	RNScalar intensity,
	RNBoolean active)
    : active(active),
      intensity(intensity),
      color(color),
      id(-1)
{
}



R3Light::
~R3Light(void)
{
}



void R3Light::
SetActive(RNBoolean active)
{
    // Set active
    this->active = active;
}



void R3Light::
SetIntensity(RNScalar intensity)
{
    // Set intensity
    this->intensity = intensity;
}



void R3Light::
SetColor(const RNRgb& color)
{
    // Set color
    this->color = color;
}



RNRgb R3Light::
DiffuseReflection(const R3Brdf& brdf, 
    const R3Point& point, const R3Vector& normal) const
{
    // Check if light is active
    if (!IsActive()) return RNblack_rgb;

    // Get material properties
    const RNRgb& Dc = brdf.Diffuse();

    // Get light properties
    const RNRgb& Ic = Color();
    RNScalar I = IntensityAtPoint(point);
    R3Vector L = DirectionFromPoint(point);

    // Compute geometric stuff
    RNScalar NL = normal.Dot(L);
    if (RNIsNegativeOrZero(NL)) return RNblack_rgb;

    // Return diffuse component of reflection
    return (I * NL) * Dc * Ic;
}



RNRgb R3Light::
SpecularReflection(const R3Brdf& brdf, const R3Point& eye, 
    const R3Point& point, const R3Vector& normal) const
{
    // Check if light is active
    if (!IsActive()) return RNblack_rgb;

    // Get material properties
    const RNRgb& Sc = brdf.Specular();
    RNScalar s = brdf.Shininess();

    // Get light properties
    const RNRgb& Ic = Color();
    RNScalar I = IntensityAtPoint(point);
    R3Vector L = DirectionFromPoint(point);

    // Compute geometric stuff
    RNScalar NL = normal.Dot(L);
    if (RNIsNegativeOrZero(NL)) return RNblack_rgb;
    R3Vector R = (2.0 * NL) * normal - L;
    R3Vector V = eye - point;
    V.Normalize();
    RNScalar VR = V.Dot(R);
    if (RNIsNegativeOrZero(VR)) return RNblack_rgb;

    // Return specular component of reflection
    return (I * pow(VR,s)) * Sc * Ic;
}



RNRgb R3Light::
Reflection(const R3Brdf& brdf, const R3Point& eye, 
    const R3Point& point, const R3Vector& normal) const
{
    // Check if light is active
    if (!IsActive()) return RNblack_rgb;

    // Get material properties
    const RNRgb& Dc = brdf.Diffuse();
    const RNRgb& Sc = brdf.Specular();
    RNScalar s = brdf.Shininess();

    // Get light properties
    RNScalar I = IntensityAtPoint(point);
    R3Vector L = DirectionFromPoint(point);
    const RNRgb& Ic = Color();

    // Compute geometric stuff
    RNScalar NL = normal.Dot(L);
    if (RNIsNegativeOrZero(NL)) return RNblack_rgb;
    R3Vector R = (2.0 * NL) * normal - L;
    R3Vector V = eye - point;
    V.Normalize();
    RNScalar VR = V.Dot(R);

    // Compute diffuse reflection
    RNRgb rgb = (I * NL) * Dc * Ic;

    // Compute specular reflection
    if (RNIsPositive(VR)) rgb += (I * pow(VR,s)) * Sc * Ic;

    // Return total reflection
    return rgb;
}














