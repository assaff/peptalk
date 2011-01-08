/* Include file for the R3 light class */



/* Initialization functions */

int R3InitPointLight();
void R3StopPointLight();



/* Class definition */

class R3PointLight : public R3Light {
    public:
        // Constructor functions
	R3PointLight(void);
        R3PointLight(const R3PointLight& light);
        R3PointLight(const R3Point& position, const RNRgb& color, 
            RNScalar intensity = 1.0, RNBoolean active = TRUE);

	// Property functions/operators
  	const R3Point& Position(void) const;

	// Manipulation functions/operations
  	virtual void SetPosition(const R3Point& position);

	// Evaluation functions
	virtual RNScalar IntensityAtPoint(const R3Point& point) const;
	virtual R3Vector DirectionFromPoint(const R3Point& point) const;
	virtual RNScalar RadiusOfInfluence(RNScalar intensity) const;
	R3Sphere SphereOfInfluence(RNScalar intensity) const;

	// Draw functions/operations
        virtual void Draw(int i) const;

	// Class type definitions
	RN_CLASS_TYPE_DECLARATIONS(R3PointLight);

    private:
	R3Point position;
};



/* Public variables */

extern R3PointLight R3null_point_light;
extern RNScalar R3light_constant_attenuation;
extern RNScalar R3light_linear_attenuation;
extern RNScalar R3light_quadratic_attenuation;



/* Inline functions */

inline const R3Point& R3PointLight::
Position(void) const
{
    // Return position 
    return position;
}



inline R3Sphere R3PointLight::
SphereOfInfluence(RNScalar intensity) const
{
    // Return sphere within which light intensity is below threshhold
    return R3Sphere(Position(), RadiusOfInfluence(intensity));
}




