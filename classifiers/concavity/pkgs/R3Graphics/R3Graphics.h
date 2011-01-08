/* Include file for R3 graphics module */

#ifndef __R3__GRAPHICS__H__
#define __R3__GRAPHICS__H__



/* Dependency include files */

#include "R3Shapes/R3Shapes.h"



/* Viewing include files */

#include "R3Graphics/R2Viewport.h"
#include "R3Graphics/R3Camera.h"
#include "R3Graphics/R3Viewer.h"



/* Material include files */

#include "R3Graphics/R3Brdf.h"
#include "R3Graphics/R2Texture.h"
#include "R3Graphics/R3Material.h"



/* Light include files */

#include "R3Graphics/R3Light.h"
#include "R3Graphics/R3DirectionalLight.h"
#include "R3Graphics/R3PointLight.h"
#include "R3Graphics/R3SpotLight.h"



/* Scene include files */

#include "R3Graphics/R3Node.h"
#include "R3Graphics/R3Scene.h"



/* Utility include files */

#include "R3Graphics/R3Io.h"



/* Initialization functions */

int R3InitGraphics(void);
void R3StopGraphics(void);



#endif











