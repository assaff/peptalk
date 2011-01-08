/* Source file for the R3 light class */



/* Include files */

#include "R3Graphics.h"



/* Public variables */

R3DirectionalLight R3null_directional_light;
R3DirectionalLight R3default_directional_light(R3Vector(0.0, 0.0, -1.0), RNRgb(1.0, 1.0, 1.0), 1.0, TRUE);



/* Class type definitions */

RN_CLASS_TYPE_DEFINITIONS(R3DirectionalLight);



/* Public functions */

int 
R3InitDirectionalLight()
{
    /* Return success */
    return TRUE;
}



void 
R3StopDirectionalLight()
{
}



R3DirectionalLight::
R3DirectionalLight(void)
{
}



R3DirectionalLight::
R3DirectionalLight(const R3DirectionalLight& light)
    : R3Light(light),
      direction(light.direction)
{
}



R3DirectionalLight::
R3DirectionalLight(const R3Vector& direction,
		   const RNRgb& color,
		   RNScalar intensity,
		   RNBoolean active)
    : R3Light(color, intensity, active),
      direction(direction)
{
    // Make sure direction is normalized
    this->direction.Normalize();
}



void R3DirectionalLight::
SetDirection(const R3Vector& direction)
{
    // Set direction
    this->direction = direction;
    this->direction.Normalize();
}



RNScalar R3DirectionalLight::
IntensityAtPoint(const R3Point& ) const
{
    // Return intensity at point
    return Intensity();
}



R3Vector R3DirectionalLight::
DirectionFromPoint(const R3Point& ) const
{
    // Return direction to point
    return -(Direction());
}



void R3DirectionalLight::
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
    buffer[0] = -(Direction().X());
    buffer[1] = -(Direction().Y());
    buffer[2] = -(Direction().Z());
    buffer[3] = 0.0;
    glLightfv(index, GL_POSITION, buffer);
    buffer[0] = 180.0;
    glLightf(index, GL_SPOT_CUTOFF, buffer[0]);
    glEnable(index);
}



