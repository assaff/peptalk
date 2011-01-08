/* Include file for the R3 curve class */



/* Initialization functions */

int R3InitCurve();
void R3StopCurve();



/* Class definition */

class R3Curve : public R3Shape {
    public:
        // Constructors/destructors ???
	R3Curve(void);
	~R3Curve(void);

        // Shape property functions/operators
	const RNBoolean IsCurve(void) const;

	// Curve property functions/operators
	// virtual const R3Point StartPoint(void) const = 0;
	// virtual const R3Point EndPoint(void) const = 0;
};



