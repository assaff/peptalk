/* Source file for the R2 polygon class */



/* Include files */

#include "R2Shapes/R2Shapes.h"



/* Public functions */

int 
R2InitPolygon()
{
  return TRUE;
}



void 
R2StopPolygon()
{
}



R2Polygon::
R2Polygon(void) 
  : points(NULL),
    npoints(0),
    bbox(R2null_box)
{
}



R2Polygon::
R2Polygon(const R2Polygon& polygon) 
  : points(NULL),
    npoints(polygon.npoints),
    bbox(polygon.bbox)
{
  // Copy points
  if (polygon.npoints > 0) {
    points = new R2Point [ npoints ];
    for (int i = 0; i < npoints; i++) {
      points[i] = polygon.points[i];
    }
  }
}



R2Polygon::
R2Polygon(const R2Point *p, int np)
  : points(NULL),
    npoints(np),
    bbox(R2null_box)
{
  // Copy points
  if (npoints > 0) {
    points = new R2Point [ npoints ];
    for (int i = 0; i < npoints; i++) {
      points[i] = p[i];
      bbox.Union(p[i]);
    }
  }
}



R2Polygon::
~R2Polygon(void) 
{
  // Delete points
  if (points) delete [] points;
}



const R2Point R2Polygon::
ClosestPoint(const R2Point& point) const
{
  // Return closest point on polygon
  R2Point closest_point(0,0);
  RNLength closest_squared_distance = FLT_MAX;
  for (int i = 0; i < npoints; i++) {
    const R2Point& position = points[i];
    RNLength squared_distance = R2SquaredDistance(point, position);
    if (squared_distance < closest_squared_distance) {
      closest_point = position;
      closest_squared_distance = squared_distance;
    }
  }

  // Return closest point
  return closest_point;
}



const RNBoolean R2Polygon::
IsPoint(void) const
{
    // A polygon only lies on a single point if it has one point
    return (npoints == 1);
}



const RNBoolean R2Polygon::
IsLinear(void) const
{
    // A polygon only lies within a line if it has two points
    return (npoints == 2);
}



const RNBoolean R2Polygon::
IsConvex(void) const
{
    RNAbort("Not implemented");
    return FALSE;
}



const RNArea R2Polygon::
Area(void) const
{
    RNAbort("Not implemented");
    return 0;
}



const R2Point R2Polygon::
Centroid(void) const
{
  // Check number of points
  if (npoints == 0) return R2zero_point;

  // Return centroid
  R2Point sum = R2zero_point;
  for (int i = 0; i < npoints; i++) sum += points[i];
  return sum / npoints;
}



const R2Shape& R2Polygon::
BShape(void) const
{
    // Return bounding box
    return bbox;
}



const R2Box R2Polygon::
BBox(void) const
{
    // Return bounding box of polygon
    return bbox;
}



const R2Circle R2Polygon::
BCircle(void) const
{
    // Return bounding circle
    return bbox.BCircle();
}



void R2Polygon::
Empty(void)
{
    // Empty polygon
    if (points) delete [] points;
    points = NULL;
    npoints = 0;
    bbox = R2null_box;
}



void R2Polygon::
Clip(const R2Line& line) 
{
  // Check number of points
  if (npoints == 0) {
    return;
  }
  else if (npoints == 1) {
    if (R2SignedDistance(line, points[0]) < 0) {
      bbox = R2null_box;
      delete [] points;
      points = NULL;
      npoints = 0;
    }
  }
  else {
    // Check bounding box
    R2Halfspace halfspace(line, 0);

    // Check if bounding box is entirely on positive side of line
    if (R2Contains(halfspace, bbox)) {
      return;
    }

    // Check if bounding box is entirely on negative side of line
    if (R2Contains(-halfspace, bbox)) {
      bbox = R2null_box;
      delete [] points;
      points = NULL;
      npoints = 0;
      return;
    }

    // Create new array for points
    int nbuffer = 0;
    R2Point *buffer = new R2Point [ 4 * npoints ];
    if (!buffer) RNAbort("Unable to allocate points during clip");

    // Build buffer with clipped points
    const R2Point *p1 = &points[npoints-1];
    RNScalar d1 = R2SignedDistance(line, *p1);
    for (int i = 0; i < npoints; i++) {
      const R2Point *p2 = &points[i];
      RNScalar d2 = R2SignedDistance(line, *p2);
      if (d2 >= 0) {
        // Insert crossing from negative to positive
        if (d1 < 0) {
          RNScalar t = d2 / (d2 - d1);
          buffer[nbuffer++] = *p2 + t * (*p1 - *p2);
        }

        // Insert point on positive side
        buffer[nbuffer++] = *p2;
      }
      else {
        // Insert crossing from positive to negative
        if (d1 >= 0) {
          RNScalar t = d1 / (d1 - d2);
          buffer[nbuffer++] = *p1 + t * (*p2 - *p1);
        }
      }

      // Remember previous point
      p1 = p2;
      d1 = d2;
    }

    // Copy points
    bbox = R2null_box;
    npoints = nbuffer;
    delete [] points;
    points = new R2Point [ npoints ];
    for (int i = 0; i < npoints; i++) {
      points[i] = buffer[i];
      bbox.Union(points[i]);
    }

    // Delete the buffer of points
    delete [] buffer;
  }
}



void R2Polygon::
Clip(const R2Box& box) 
{
  // Clip to each side of box
  if (npoints == 0) return;
  Clip(R2Line(1, 0, -(box.XMin())));
  if (npoints == 0) return;
  Clip(R2Line(-1, 0, box.XMax()));
  if (npoints == 0) return;
  Clip(R2Line(0, 1, -(box.YMin())));
  if (npoints == 0) return;
  Clip(R2Line(0, -1, box.YMax()));
}



void R2Polygon::
Transform(const R2Transformation& transformation) 
{
  // Transform points
  bbox = R2null_box;
  for (int i = 0; i < npoints; i++) {
    points[i].Transform(transformation);
    bbox.Union(points[i]);
  }
}



void R2Polygon::
Print(FILE *fp) const
{
  // Print points
  fprintf(fp, "%d\n", npoints);
  for (int i = 0; i < npoints; i++) {
    fprintf(fp, "%12.6f %12.6f\n", points[i].X(), points[i].Y());
  }
}



int R2Polygon::
ReadTheraFile(const char *filename)
{
  // Open file
  FILE *fp = fopen(filename, "r");
  if (!fp) {
    fprintf(stderr, "Unable to open polygon file: %s\n", filename);
    return 0;
  }

  // Read header line
  int ndimensions;
  double polygon_depth, sample_spacing;
  if (fscanf(fp, "%d %d %lf %lf", &ndimensions, &npoints, &polygon_depth, &sample_spacing) != 4) {
    fprintf(stderr, "Unable to read polygon file header: %s\n", filename);
    return 0;
  }

  // Allocate points
  points = new R2Point [ npoints ];
  if (!points) {
    fprintf(stderr, "Unable to allocate points for polygon: %s\n", filename);
    return 0;
  }

  // Read points
  for (int i = 0; i < npoints; i++) {
    double x, y;
    if (fscanf(fp, "%lf %lf", &x, &y) != 2) {
      fprintf(stderr, "Unable to read point %d from polygon file %s\n", npoints, filename);
      return 0;
    }

    // Add point
    points[i].Reset(x,y);
    bbox.Union(points[i]);
  }

  // Close file
  fclose(fp);

  // Return success
  return npoints;
}











