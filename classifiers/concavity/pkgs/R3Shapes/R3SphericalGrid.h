// Header file for GAPS scalar grid class



// Class definition

class R3SphericalGrid {
public:
  // Constructors
  R3SphericalGrid(int phi_resolution = 0, int theta_resolution = 0, int radius_resolution = 0);
  R3SphericalGrid(const R3SphericalGrid& grid);
  ~R3SphericalGrid(void);

  // Grid property functions
  int NEntries(void) const;
  int PhiResolution(void) const;
  int ThetaResolution(void) const;
  int RadiusResolution(void) const;
  int Resolution(int dim) const;
  RNScalar Sum(void) const;
  RNScalar Maximum(void) const;
  RNScalar Minimum(void) const;
  RNInterval Range(void) const;
  RNScalar L1Norm(void) const;
  RNScalar L2Norm(void) const;
  RNScalar Volume(void) const;
  RNScalar Integral(RNScalar (*f)(RNScalar)) const;
  RNScalar Integral(const R3SphericalGrid& g, RNScalar (*f)(RNScalar, RNScalar)) const;
  int Cardinality(void) const;
  RNLength WorldRadius(void) const;
  R3Point WorldOrigin(void) const;
  R3Sphere WorldSphere(void) const;

  // Transformation property functions
  const R3Affine& WorldToGridTransformation(void) const;
  const R3Affine& GridToWorldTransformation(void) const;
  RNScalar WorldToGridScaleFactor(void) const;
  RNScalar GridToWorldScaleFactor(void) const;

  // Grid value access functions
  RNScalar GridValue(int i, int j, int k) const;
  RNScalar GridValue(RNCoord x, RNCoord y, RNCoord z) const;
  RNScalar GridValue(const R3Point& grid_point) const;
  RNScalar WorldValue(RNCoord x, RNCoord y, RNCoord z) const;
  RNScalar WorldValue(const R3Point& world_point) const;
  RNScalar& operator()(int i, int j,int k);

  // Grid manipulation functions
  void Abs(void);
  void Sqrt(void);
  void Square(void);
  void Negate(void);
  void Invert(void);
  void Normalize(void);
  void Clear(RNScalar value = 0);
  void Add(RNScalar value);
  void Add(const R3SphericalGrid& grid);
  void Subtract(RNScalar value);
  void Subtract(const R3SphericalGrid& grid);
  void Multiply(RNScalar value);
  void Multiply(const R3SphericalGrid& grid);
  void Divide(RNScalar value);
  void Divide(const R3SphericalGrid& grid);
  void Threshold(RNScalar threshold, RNScalar low, RNScalar high);
  void SetGridValue(int i, int j, int k, RNScalar value);
  void AddGridValue(int i, int j, int k, RNScalar value);
  void Add(const R3Grid& grid);

  // Arithmetic operators
  R3SphericalGrid& operator=(const R3SphericalGrid& grid);
  R3SphericalGrid& operator+=(RNScalar scale);
  R3SphericalGrid& operator+=(const R3SphericalGrid& grid);
  R3SphericalGrid& operator-=(RNScalar scale);
  R3SphericalGrid& operator-=(const R3SphericalGrid& grid);
  R3SphericalGrid& operator*=(RNScalar scale);
  R3SphericalGrid& operator*=(const R3SphericalGrid& grid);
  R3SphericalGrid& operator/=(RNScalar scale);
  R3SphericalGrid& operator/=(const R3SphericalGrid& grid);

  // Rasterization functions
  void RasterizeGridPoint(RNCoord x, RNCoord y, RNCoord z, RNScalar value);
  void RasterizeGridPoint(const R3Point& point, RNScalar value);
  void RasterizeWorldPoint(RNCoord x, RNCoord y, RNCoord z, RNScalar value);
  void RasterizeWorldPoint(const R3Point& point, RNScalar value);

  // Relationship functions
  RNScalar Dot(const R3SphericalGrid& grid) const;
  RNScalar L1Distance(const R3SphericalGrid& grid) const;
  RNScalar L2Distance(const R3SphericalGrid& grid) const;
  RNScalar L2DistanceSquared(const R3SphericalGrid& grid) const;

  // Transformation manipulation functions
  void SetWorldToGridTransformation(const R3Affine& affine);
  void SetWorldToGridTransformation(const R3Box& world_box);
  void SetWorldToGridTransformation(const R3Point& world_origin, const R3Vector& world_axis1, const R3Vector& world_axis2, RNLength world_radius);

  // Transformation utility functions
  R3Point GridPosition(const R3Point& world_point) const;
  R3Point GridPosition(RNCoord x, RNCoord y, RNCoord z) const;
  R3Point WorldPosition(const R3Point& grid_point) const;
  R3Point WorldPosition(RNCoord x, RNCoord y, RNCoord z) const;

  // I/O functions
  int ReadFile(const char *filename);
  int WriteFile(const char *filename) const;
  int Read(FILE *fp = NULL);
  int Write(FILE *fp = NULL) const;
  int Print(FILE *fp = NULL) const;

  // Debugging functions
  const RNScalar *GridValues(void) const;

private:
  // Utility functions
  static RNScalar L1NormFunction(RNScalar value);
  static RNScalar L2NormFunction(RNScalar value);
  static RNScalar VolumeFunction(RNScalar value);
  static RNScalar L1DistanceFunction(RNScalar value1, RNScalar value2);
  static RNScalar L2DistanceFunction(RNScalar value1, RNScalar value2);
  static RNScalar DotFunction(RNScalar value1, RNScalar value2);

private:
  // Utility functions
  RNAngle Phi(RNScalar x) const;
  RNAngle Theta(RNScalar y) const;
  RNLength Radius(RNScalar z) const;
  RNCoord X(RNAngle phi) const;
  RNCoord Y(RNAngle theta) const;
  RNCoord Z(RNLength radius) const;

private:
  R3Grid grid;
};



// Inline functions

inline int R3SphericalGrid::
NEntries(void) const
{
  // Return total number of entries
  return grid.NEntries();
}



inline int R3SphericalGrid::
PhiResolution(void) const
{
  // Return resolution in Y dimension
  return grid.XResolution();
}




inline int R3SphericalGrid::
ThetaResolution(void) const
{
  // Return resolution in X dimension
  return grid.YResolution();
}




inline int R3SphericalGrid::
RadiusResolution(void) const
{
  // Return resolution in Z dimension
  return grid.ZResolution();
}




inline int R3SphericalGrid::
Resolution(int dim) const
{
  // Return resolution in dimension
  return grid.Resolution(dim);
}



inline RNScalar R3SphericalGrid::
L1Norm(void) const
{
  // Return L1 norm of grid
  return Integral(L1NormFunction);
}



inline RNScalar R3SphericalGrid::
L2Norm(void) const
{
  // Return L2 norm of grid
  return sqrt(Integral(L2NormFunction));
}



inline RNScalar R3SphericalGrid::
Volume(void) const
{
  // Return volume of non-zero entries in grid
  RNScalar scale = GridToWorldScaleFactor();
  return Integral(VolumeFunction) * scale * scale * scale;
}



inline RNScalar R3SphericalGrid::
Sum(void) const
{
  // Return sum of all grid values
  return L1Norm();
}



inline RNScalar R3SphericalGrid::
Minimum(void) const
{
  // Return smallest value
  return grid.Minimum();
}



inline RNScalar R3SphericalGrid::
Maximum(void) const
{
  // Return largest value
  return grid.Maximum();
}



inline RNInterval R3SphericalGrid::
Range(void) const
{
  // Return smallest and largest values
  return grid.Range();
}



inline int R3SphericalGrid::
Cardinality(void) const
{
  // Return number of non-zero grid values
  return grid.Cardinality();
}



inline const R3Affine& R3SphericalGrid::
WorldToGridTransformation(void) const
{
  // Return transformation from world coordinates to grid coordinates
  return grid.WorldToGridTransformation();
}



inline const R3Affine& R3SphericalGrid::
GridToWorldTransformation(void) const
{
  // Return transformation from grid coordinates to world coordinates
  return grid.GridToWorldTransformation();
}



inline RNScalar R3SphericalGrid::
WorldToGridScaleFactor(void) const
{
  // Return transformation from world coordinates to grid coordinates
  return grid.WorldToGridScaleFactor();
}



inline RNScalar R3SphericalGrid::
GridToWorldScaleFactor(void) const
{
  // Return transformation from world coordinates to grid coordinates
  return grid.GridToWorldScaleFactor();
}



inline R3Point R3SphericalGrid::
GridPosition(const R3Point& world_point) const
{
  // Transform point from world coordinates to grid coordinates
  return GridPosition(world_point[0], world_point[1], world_point[2]);
}



inline R3Point R3SphericalGrid::
WorldPosition(const R3Point& grid_point) const
{
  // Transform point from grid coordinates to world coordinates
  return WorldPosition(grid_point[0], grid_point[1], grid_point[2]);
}



inline RNLength R3SphericalGrid::
WorldRadius(void) const
{
  // Return radius covered by sphere in world coordinates
  return (RadiusResolution()-1) * grid.GridToWorldScaleFactor();
}



inline R3Point R3SphericalGrid::
WorldOrigin(void) const
{
  // Return center of sphere in world coordinates
  return WorldPosition(0, 0, 0);
}



inline R3Sphere R3SphericalGrid::
WorldSphere(void) const
{
  // Return sphere covered by grid in world coordinates
  return R3Sphere(WorldOrigin(), WorldRadius());
}



inline const RNScalar *R3SphericalGrid::
GridValues(void) const
{
  // Return pointer to grid values
  return grid.GridValues();
}



inline RNScalar R3SphericalGrid::
GridValue(int i, int j, int k) const
{
  // Return value at grid point
  return grid.GridValue(i % PhiResolution(), j, k);
}



inline RNScalar R3SphericalGrid::
GridValue(const R3Point& point) const
{
  // Return value at grid point
  return GridValue(point[0], point[1], point[2]);
}



inline RNScalar R3SphericalGrid::
WorldValue(RNCoord x, RNCoord y, RNCoord z) const
{
  // Return value at world point
  return GridValue(GridPosition(x, y, z));
}



inline RNScalar R3SphericalGrid::
WorldValue(const R3Point& point) const
{
  // Return value at world point
  return GridValue(GridPosition(point));
}



inline RNScalar& R3SphericalGrid::
operator()(int i, int j, int k) 
{
  // Return value at grid point
  return grid(i, j, k);
}



inline void R3SphericalGrid::
Abs(void) 
{
  // Take absolute value of every grid value
  grid.Abs();
}



inline void R3SphericalGrid::
Sqrt(void) 
{
  // Take sqrt of every grid value
  grid.Sqrt();
}



inline void R3SphericalGrid::
Square(void) 
{
  // Square every grid value
  grid.Square();
}



inline void R3SphericalGrid::
Negate(void) 
{
  // Negate every grid value
  grid.Negate();
}



inline void R3SphericalGrid::
Invert(void) 
{
  // Negate every grid value
  grid.Invert();
}



inline void R3SphericalGrid::
Normalize(void) 
{
  // Scale so that length of "vector" is one
  RNScalar length = L2Norm();
  if (RNIsNotZero(length)) Divide(length);
}



inline void R3SphericalGrid::
Clear(RNScalar value) 
{
  // Set all grid values to value
  grid.Clear(value);
}



inline void R3SphericalGrid::
Add(RNScalar value) 
{
  // Add value to every grid 
  grid.Add(value);
}



inline void R3SphericalGrid::
Add(const R3SphericalGrid& g) 
{
  // Add passed grid values to corresponding entries of this grid
  grid.Add(g.grid);
}



inline void R3SphericalGrid::
Subtract(RNScalar value) 
{
  // Add the opposite
  grid.Subtract(value);
}



inline void R3SphericalGrid::
Subtract(const R3SphericalGrid& g) 
{
  // Subtract passed grid values from corresponding entries of this grid
  grid.Subtract(g.grid);
}



inline void R3SphericalGrid::
Multiply(RNScalar value) 
{
  // Multiply grid values by value
  grid.Multiply(value);
}



inline void R3SphericalGrid::
Multiply(const R3SphericalGrid& g) 
{
  // Multiply passed grid values by corresponding entries of this grid
  grid.Multiply(g.grid);
}



inline void R3SphericalGrid::
Divide(RNScalar value) 
{
  // Multiply by recipricol
  grid.Divide(value);
}



inline void R3SphericalGrid::
Divide(const R3SphericalGrid& g) 
{
  // Divide passed grid values by corresponding entries of this grid
  grid.Divide(g.grid);
}



inline void R3SphericalGrid::
Threshold(RNScalar threshold, RNScalar low, RNScalar high) 
{
  // Set grid value to low (high) if less/equal (greater) than threshold
  grid.Threshold(threshold, low, high);
}



inline void R3SphericalGrid::
SetGridValue(int i, int j, int k, RNScalar value)
{
  // Set value at grid point
  grid.SetGridValue(i % PhiResolution(), j, k, value);
}



inline void R3SphericalGrid::
AddGridValue(int i, int j, int k, RNScalar value)
{
  // Add value at grid point
  grid.AddGridValue(i % PhiResolution(), j, k, value);
}



inline R3SphericalGrid& R3SphericalGrid::
operator=(const R3SphericalGrid& g) 
{
  // Return this
  grid = g.grid;
  return *this;
}



inline R3SphericalGrid& R3SphericalGrid::
operator+=(RNScalar value) 
{
  // Add value to all grid values 
  grid.Add(value);
  return *this;
}



inline R3SphericalGrid& R3SphericalGrid::
operator+=(const R3SphericalGrid& g) 
{
  // Add passed grid values to corresponding entries of this grid
  grid.Add(g.grid);
  return *this;
}



inline R3SphericalGrid& R3SphericalGrid::
operator-=(RNScalar value) 
{
  // Subtract value from all grid values 
  grid.Subtract(value);
  return *this;
}



inline R3SphericalGrid& R3SphericalGrid::
operator-=(const R3SphericalGrid& g) 
{
  // Subtract passed grid values from corresponding entries of this grid
  grid.Subtract(g.grid);
  return *this;
}



inline R3SphericalGrid& R3SphericalGrid::
operator*=(RNScalar value) 
{
  // Multiply grid values by value
  grid.Multiply(value);
  return *this;
}



inline R3SphericalGrid& R3SphericalGrid::
operator*=(const R3SphericalGrid& g) 
{
  // Multiply passed grid values by corresponding entries of this grid
  grid.Multiply(g.grid);
  return *this;
}



inline R3SphericalGrid& R3SphericalGrid::
operator/=(RNScalar value) 
{
  // Divide grid values by value
  grid.Divide(value);
  return *this;
}



inline R3SphericalGrid& R3SphericalGrid::
operator/=(const R3SphericalGrid& g) 
{
  // Divide passed grid values by corresponding entries of this grid
  grid.Divide(g.grid);
  return *this;
}



inline void R3SphericalGrid::
RasterizeGridPoint(const R3Point& point, RNScalar value)
{
  // Splat value at grid point
  RasterizeGridPoint(point[0], point[1], point[2], value);
}



inline void R3SphericalGrid::
RasterizeWorldPoint(RNCoord x, RNCoord y, RNCoord z, RNScalar value)
{
  // Splat value at world point
  RasterizeGridPoint(GridPosition(x, y, z), value);
}



inline void R3SphericalGrid::
RasterizeWorldPoint(const R3Point& world_point, RNScalar value)
{
  // Splat value at world point
  RasterizeGridPoint(GridPosition(world_point), value);
}



inline RNScalar R3SphericalGrid::
Dot(const R3SphericalGrid& g) const
{
  // Compute dot product between this and grid
  return Integral(g, DotFunction);
}



inline RNScalar R3SphericalGrid::
L1Distance(const R3SphericalGrid& g) const
{
  // Return L1 norm of grid
  return Integral(g, L1DistanceFunction);
}




inline RNScalar R3SphericalGrid::
L2DistanceSquared(const R3SphericalGrid& g) const
{
  // Return L2 norm of grid
  return Integral(g, L2DistanceFunction);
}



inline RNScalar R3SphericalGrid::
L2Distance(const R3SphericalGrid& g) const
{
  // Return L2 norm of grid
  return sqrt(L2DistanceSquared(g));
}



inline int R3SphericalGrid::
ReadFile(const char *filename)
{
  // Read grid from file
  return grid.ReadFile(filename);
}



inline int R3SphericalGrid::
WriteFile(const char *filename) const
{
  // Write grid to file
  return grid.WriteFile(filename);
}



inline int R3SphericalGrid::
Read(FILE *fp)
{
  // Read grid from file
  return grid.ReadGrid(fp);
}



inline int R3SphericalGrid::
Write(FILE *fp) const
{
  // Write grid to file
  return grid.WriteGrid(fp);
}



inline int R3SphericalGrid::
Print(FILE *fp) const
{
  // Print grid values
  return grid.Print(fp);
}



inline RNAngle R3SphericalGrid::
Phi(RNScalar x) const
{
  // Return phi, the angle counterclockwise around the equator (x-z plane) from the x-axis
  return RN_TWO_PI * x / PhiResolution();
}



inline RNAngle R3SphericalGrid::
Theta(RNScalar y) const
{
  // Return theta, the angle from the up axis (y in world coords) to the vector at row i in the grid
  return RN_PI * (2.0*y + 1)/(2.0 * ThetaResolution());
}



inline RNLength R3SphericalGrid::
Radius(RNScalar z) const
{
  // Return radius associated with z in grid
  return z;
}



inline RNCoord R3SphericalGrid::
X(RNAngle phi) const
{
  // Return the X grid coordinate mapping to phi
  RNScalar x = phi * PhiResolution() / (2.0 * RN_PI);
  while (x >= PhiResolution()) x -= PhiResolution();
  while (x < 0) x += PhiResolution();
  return x;
}



inline RNCoord R3SphericalGrid::
Y(RNAngle theta) const
{
  // Return the Y grid coordinate mapping to theta
  RNScalar y = (2.0 * ThetaResolution() * theta - RN_PI) / (2.0 * RN_PI);
  if (y < 0) y = 0;
  while (y >= ThetaResolution()) y = ThetaResolution() - RN_EPSILON;
  return y;
}



inline RNCoord R3SphericalGrid::
Z(RNLength radius) const
{
  // Return the Z coordinate mapping to radius
  return radius;
}










