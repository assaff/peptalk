/* Include file for the R3 node class */



/* Initialization functions */

int R3InitNode();
void R3StopNode();



/* Class definition */

class R3Node {
    public:
        // Constructor functions
	R3Node(R3Shape *shape, R3Material *material);

	// Properties
        const R3Shape *Shape(void) const;
        const R3Material *Material(void) const;
        const R3Box& BBox(void) const;

        // Ray intersection functions
    	RNClassID Intersects(const R3Ray& ray, 
            R3Point *hit_point = NULL, R3Vector *hit_normal = NULL, 
            RNScalar *hit_t = NULL) const;

        // Draw functions
        void Draw(const R3DrawFlags draw_flags = R3_DEFAULT_DRAW_FLAGS) const;

    private:
        R3Shape *shape;
        R3Material *material;
        R3Box bbox;
};



/* Inline functions */

inline const R3Shape *R3Node::
Shape(void) const
{
    // Return shape
    return shape;
}



inline const R3Material *R3Node::
Material(void) const
{
    // Return material
    return material;
}



inline const R3Box& R3Node::
BBox(void) const
{
    // Return bounding box
    return bbox;
}



inline RNClassID R3Node::
Intersects(const R3Ray& ray, R3Point *hit_point, R3Vector *hit_normal, RNScalar *hit_t) const
{
  // Intersection ray with node's shape
  return shape->Intersects(ray, hit_point, hit_normal, hit_t);
}


