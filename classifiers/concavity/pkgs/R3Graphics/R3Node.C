/* Source file for the R3 node class */



/* Include files */

#include "R3Graphics.h"



/* Public functions */

int 
R3InitNode()
{
    /* Return success */
    return TRUE;
}



void 
R3StopNode()
{
}



R3Node::
R3Node(R3Shape *shape, R3Material *material)
  : shape(shape),
    material(material),
    bbox(shape->BBox())
{
}



void R3Node::
Draw(const R3DrawFlags draw_flags) const
{
  material->Draw();
  shape->Draw();
}








