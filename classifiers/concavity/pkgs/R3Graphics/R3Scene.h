/* Include file for the R3 scene class */



/* Initialization functions */

int R3InitScene();
void R3StopScene();



/* Class definition */

class R3Scene {
    public:
        // Constructor functions
	R3Scene(void);

	// Access functions
	const int NLights(void) const;
	const R3Light *Light(int k) const;
	const int NNodes(void) const;
	const R3Node *Node(int k) const;
        const R3Camera *Camera(void) const;

        // Manipulation functions
        void InsertLight(R3Light *light);
        void InsertNode(R3Node *node);
        void SetCamera(R3Camera *camera);

        // Geometric properties
        const R3Box& BBox(void) const;

        // Ray intersection functions
    	RNClassID Intersects(const R3Ray& ray, 
            R3Node **hit_node = NULL, R3Point *hit_point = NULL, 
            R3Vector *hit_normal = NULL, RNScalar *hit_t = NULL) const;

        // Draw functions
        void Draw(const R3DrawFlags draw_flags = R3_DEFAULT_DRAW_FLAGS) const;

    private:
        RNArray<R3Node *> nodes;
        RNArray<R3Light *> lights;
        R3Camera *camera;
        R3Box bbox;
};



/* Inline functions */

inline const int R3Scene::
NLights(void) const
{
    // Return number of lights
    return lights.NEntries();
}



inline const R3Light *R3Scene::
Light(int k) const
{
    // Return kth light
    return lights.Kth(k);
}



inline const int R3Scene::
NNodes(void) const
{
    // Return number of nodes
    return nodes.NEntries();
}



inline const R3Node *R3Scene::
Node(int k) const
{
    // Return kth node
    return nodes.Kth(k);
}



inline const R3Camera *R3Scene::
Camera(void) const
{
    // Return camera
    return camera;
}



inline const R3Box& R3Scene::
BBox(void) const
{
    // Return bounding box 
    return bbox;
}



