/* Source file for the R3 scene class */



/* Include files */

#include "R3Graphics.h"



/* Public functions */

int 
R3InitScene()
{
    /* Return success */
    return TRUE;
}



void 
R3StopScene()
{
}



R3Scene::
R3Scene(void)
  : camera(NULL),
    bbox(R3null_box)
{
}



void R3Scene::
InsertLight(R3Light *light) 
{
  // Insert light
  lights.Insert(light);
}



void R3Scene::
InsertNode(R3Node *node) 
{
  // Insert node
  nodes.Insert(node);

  // Update bounding box
  bbox.Union(node->BBox());
}



void R3Scene::
SetCamera(R3Camera *camera) 
{
  // Remember camera
  this->camera = camera;
}



RNClassID R3Scene::
Intersects(const R3Ray& ray, 
           R3Node **hit_node, R3Point *hit_point, 
           R3Vector *hit_normal, RNScalar *hit_t) const
{
  // Temporary variables
  R3Point point;
  R3Vector normal;
  RNScalar t;

  // Find closest node intersection
  R3Node *closest_node = NULL;
  RNScalar closest_t = RN_INFINITY;
  for (int i = 0; i < nodes.NEntries(); i++) {
    R3Node *node = nodes.Kth(i);
    if (node->Intersects(ray, &point, &normal, &t)) {
      if (t < closest_t) {
        if (hit_node) *hit_node = node;
        if (hit_point) *hit_point = point;
        if (hit_normal) *hit_normal = normal;
        if (hit_t) *hit_t = t;
        closest_node = node;
        closest_t = t;
      }
    }
  }
  
  // Check if found any hit
  if (closest_node) return R3_POINT_CLASS_ID;
  else return RN_NULL_CLASS_ID;
}



void R3Scene::
Draw(const R3DrawFlags draw_flags) const
{
  // Load camera
  // camera.Load(); (interactive camera loaded in Redraw functions)

  // Load lights
  for (int i = 0; i < lights.NEntries(); i++)
    lights.Kth(i)->Draw(i);

  // Draw nodes
  for (int i = 0; i < nodes.NEntries(); i++)
    nodes.Kth(i)->Draw(draw_flags);
}








