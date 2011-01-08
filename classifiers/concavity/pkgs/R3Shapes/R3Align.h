// Include file for alignment utility functions



// Functions to align lists of points

R3Point R3Centroid(int npoints, R3Point *points);
R3Triad R3PrincipleAxes(const R3Point& centroid, int npoints, R3Point *points, RNScalar *variances = NULL);
RNLength R3AverageDistance(const R3Point& center, int npoints, R3Point *points);
R3Affine R3NormalizationTransformation(int npoints, R3Point *points,
  RNBoolean align_center = TRUE, RNBoolean align_rotation = TRUE, int align_scale = 1);
R4Matrix R3AlignPoints(int count, R3Point *points1, R3Point *points2, RNScalar* weights = NULL, 
  RNBoolean align_center = TRUE, RNBoolean align_rotation = TRUE, int align_scale = 1);
