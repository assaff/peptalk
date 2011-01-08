/* Source file for the R3 light class */



/* Include files */

#include "R3Graphics.h"



/* Private variables - mirrored in RNUtils/UI.C */

RNScalar R3light_constant_attenuation = 1.0; // inches ???
RNScalar R3light_linear_attenuation = 0.01; // inches ???
RNScalar R3light_quadratic_attenuation = 0.001; // inches ???



/* Public variables */

R3PointLight R3null_point_light;



/* Class type definitions */

RN_CLASS_TYPE_DEFINITIONS(R3PointLight);



/* Public functions */

int 
R3InitPointLight()
{
    /* Return success */
    return TRUE;
}



void 
R3StopPointLight()
{
}



R3PointLight::
R3PointLight(void)
{
}



R3PointLight::
R3PointLight(const R3PointLight& light)
    : R3Light(light),
      position(light.position)
{
}



R3PointLight::
R3PointLight(const R3Point& position,
	     const RNRgb& color,
	     RNScalar intensity,
	     RNBoolean active)
    : R3Light(color, intensity, active),
      position(position)
{
}



RNScalar R3PointLight::
IntensityAtPoint(const R3Point& point) const
{
    // Return intensity at point
    RNLength d = R3Distance(point, position);
    RNScalar denom = R3light_constant_attenuation;
    denom += d * R3light_linear_attenuation;
    denom += d * d * R3light_quadratic_attenuation;
    if (RNIsZero(denom)) return Intensity();
    else return (Intensity() / denom);
}



R3Vector R3PointLight::
DirectionFromPoint(const R3Point& point) const
{
    // Return direction to point
    R3Vector L = position - point;
    L.Normalize();
    return L;
}



RNScalar R3PointLight::
RadiusOfInfluence(RNScalar intensity_threshhold) const
{
    // Return distance beyond which intensity is below threshold
    // kq*d^2 + kl*d + (kc - 1/a) = 0 (use quadratic formula)
    if (RNIsZero(Intensity())) return 0.0;
    if (RNIsZero(intensity_threshhold)) return RN_INFINITY;
    RNScalar A = R3light_quadratic_attenuation;
    RNScalar B = R3light_linear_attenuation;
    RNScalar C = R3light_constant_attenuation - Intensity() / intensity_threshhold;
    RNScalar radius = (-B + sqrt(B*B - 4.0*A*C)) / (2.0*A);
    return radius;
}



void R3PointLight::
SetPosition(const R3Point& position)
{
    // Set position
    this->position = position;
}



void R3PointLight::
Draw(int i) const
{
    // Draw light
    GLenum index = (GLenum) (GL_LIGHT2 + i);
    if (index > GL_LIGHT7) return;
    GLfloat buffer[4];
    buffer[0] = Intensity() * Color().R();
    buffer[1] = Intensity() * Color().G();
    buffer[2] = Intensity() * Color().B();
    buffer[3] = 1.0;
    glLightfv(index, GL_DIFFUSE, buffer);
    glLightfv(index, GL_SPECULAR, buffer);
    buffer[0] = Position().X();
    buffer[1] = Position().Y();
    buffer[2] = Position().Z();
    buffer[3] = 1.0;
    glLightfv(index, GL_POSITION, buffer);
    buffer[0] = 180.0;
    glLightf(index, GL_SPOT_CUTOFF, buffer[0]);
    glEnable(index);
}



