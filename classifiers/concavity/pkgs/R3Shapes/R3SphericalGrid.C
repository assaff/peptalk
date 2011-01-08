// Source file for GAPS scalar grid class



////////////////////////////////////////////////////////////////////////
// This class stores a regular grid on a sphere. 
// The X dimension represents azimuth (phi)
// measured from the X axis in the counter-clockwise direction.
// The Y dimension of the grid represents downward altitude (theta)
// measured from the positive y axis (the north pole). 
// The Z dimension represents radius (distance from the origin).
// The spherical grid covers up to a radius of ZResolution 
// with samples at radius 0.5, 1.5, ... ZResolution()-0.5.
// So, (i,j,k) on the spherical grid represents the
// point on the sphere with spherical coordinates:
// (2Pi*j/r,Pi*(2i+1)/(2r)) and distance (k+1)/r from the origin,
// where r is the resolution of the sampling.
////////////////////////////////////////////////////////////////////////



// Include files

#include "R3Shapes/R3Shapes.h"



R3SphericalGrid::
R3SphericalGrid(int phi_resolution, int theta_resolution, int radius_resolution)
  : grid(phi_resolution, theta_resolution, radius_resolution)
{
}



R3SphericalGrid::
R3SphericalGrid(const R3SphericalGrid& g)
  : grid(g.grid)
{
}



R3SphericalGrid::
~R3SphericalGrid(void)
{
}



R3Point R3SphericalGrid::
GridPosition(RNCoord x, RNCoord y, RNCoord z) const
{
  // Transform point from world coordinates to grid coordinates
  R3Point p = grid.GridPosition(x, y, z);
  RNLength radius = p.Vector().Length();
  RNCoord gz = Z(radius);
  if (RNIsZero(p.X()) && RNIsZero(p.Z())) {
    if (p.Y() < 0) return R3Point(0, ThetaResolution()-1, gz);
    else return R3Point(0, 0, radius);
  }
  else {
    assert(radius != 0.0);
    p /= radius;
    RNAngle phi = atan2(p.Z(), p.X());
    if (phi < 0) phi += RN_TWO_PI;
    RNAngle theta = acos(p.Y());
    RNCoord gx = X(phi);
    RNCoord gy = Y(theta);
    return R3Point(gx, gy, gz);
  }
}



R3Point R3SphericalGrid::
WorldPosition(RNCoord x, RNCoord y, RNCoord z) const
{
  // Transform point from grid coordinates to world coordinates
  RNAngle phi = Phi(x);
  RNAngle theta = Theta(y);
  RNLength radius = Radius(z);
  RNScalar sin_theta = sin(theta);
  RNCoord gx = radius * sin_theta * cos(phi);
  RNCoord gy = radius * cos(theta);
  RNCoord gz = radius * sin_theta * sin(phi);
  return grid.WorldPosition(gx, gy, gz);
}



RNScalar R3SphericalGrid::
GridValue(RNScalar x, RNScalar y, RNScalar z) const
{
  // Adjust coordinates (this is different from R3Grid)
  while (x < 0) x += PhiResolution();
  while (x >= PhiResolution()) x -= PhiResolution();
  if (y < 0) y = 0;
  if (y > ThetaResolution()-1) y = ThetaResolution()-1; 
  if ((z < 0) || (z > RadiusResolution()-1)) return 0.0;

  // Trilinear interpolation
  int ix1 = (int) x;
  int iy1 = (int) y;
  int iz1 = (int) z;
  int ix2 = ix1 + 1;
  int iy2 = iy1 + 1;
  int iz2 = iz1 + 1;
  if (ix2 >= PhiResolution()) ix2 = 0;  // This is different from R3Grid
  if (iy2 >= ThetaResolution()) iy2 = iy1;
  if (iz2 >= RadiusResolution()) iz2 = iz1;
  float dx = x - ix1;
  float dy = y - iy1;
  float dz = z - iz1;
  float value = 0.0;
  value += GridValue(ix1, iy1, iz1) * (1.0-dx) * (1.0-dy) * (1.0-dz);
  value += GridValue(ix1, iy1, iz2) * (1.0-dx) * (1.0-dy) * dz;
  value += GridValue(ix1, iy2, iz1) * (1.0-dx) * dy * (1.0-dz);
  value += GridValue(ix1, iy2, iz2) * (1.0-dx) * dy * dz;
  value += GridValue(ix2, iy1, iz1) * dx * (1.0-dy) * (1.0-dz);
  value += GridValue(ix2, iy1, iz2) * dx * (1.0-dy) * dz;
  value += GridValue(ix2, iy2, iz1) * dx * dy * (1.0-dz);
  value += GridValue(ix2, iy2, iz2) * dx * dy * dz;
  return value;
}



void R3SphericalGrid::
RasterizeGridPoint(RNScalar x, RNScalar y, RNScalar z, RNScalar value)
{
  // Adjust coordinates (this is different from R3Grid)
  while (x < 0) x += PhiResolution();
  while (x >= PhiResolution()) x -= PhiResolution();
  if (y < 0) y = 0;
  if (y > ThetaResolution()-1) y = ThetaResolution()-1; 
  if ((z < 0) || (z > RadiusResolution()-1)) return;

  // Trilinear interpolation
  int ix1 = (int) x;
  int iy1 = (int) y;
  int iz1 = (int) z;
  int ix2 = ix1 + 1;
  int iy2 = iy1 + 1;
  int iz2 = iz1 + 1;
  if (ix2 >= PhiResolution()) ix2 = 0;  // This is different from R3Grid
  if (iy2 >= ThetaResolution()) iy2 = iy1;
  if (iz2 >= RadiusResolution()) iz2 = iz1;
  float dx = x - ix1;
  float dy = y - iy1;
  float dz = z - iz1;
  (*this)(ix1, iy1, iz1) += value * (1.0-dx) * (1.0-dy) * (1.0-dz);
  (*this)(ix1, iy1, iz2) += value * (1.0-dx) * (1.0-dy) * dz;
  (*this)(ix1, iy2, iz1) += value * (1.0-dx) * dy * (1.0-dz);
  (*this)(ix1, iy2, iz2) += value * (1.0-dx) * dy * dz;
  (*this)(ix2, iy1, iz1) += value * dx * (1.0-dy) * (1.0-dz);
  (*this)(ix2, iy1, iz2) += value * dx * (1.0-dy) * dz;
  (*this)(ix2, iy2, iz1) += value * dx * dy * (1.0-dz);
  (*this)(ix2, iy2, iz2) += value * dx * dy * dz;
}



void R3SphericalGrid::
Add(const R3Grid& g)
{
  // Fill spherical grid with samples from g
  for (int k = 0; k < RadiusResolution(); k++) {
    for (int j = 0; j < ThetaResolution(); j++) {
      for (int i = 0; i < PhiResolution(); i++) {
        R3Point world_position = WorldPosition(i, j, k);
        RNScalar value = g.WorldValue(world_position);
        AddGridValue(i, j, k, value);
      }
    }
  }
}



RNScalar R3SphericalGrid::
Integral(RNScalar (*f)(RNScalar)) const
{
  // Return integral of f(grid.value), weighting terms by surface area
  // radius_scale has fraction of volume in shell
  // theta_scale has fraction of volume in slice (proportional to height of slice)
  // phi_scale has fraction of volume in sector
  // mean is weighted average of grid values
  RNScalar mean = 0.0;
  RNScalar max_radius = RadiusResolution()-1;
  RNScalar max_radius_cubed = max_radius * max_radius * max_radius;
  RNScalar last_radius_cubed = 0;
  RNScalar phi_scale = 1.0 / grid.XResolution();
  for (int k = 0; k < grid.ZResolution(); k++) {
    RNScalar radius = Radius(k);
    RNScalar radius_cubed = radius * radius * radius;
    RNScalar radius_scale = (radius_cubed - last_radius_cubed) / max_radius_cubed;
    last_radius_cubed = radius_cubed;
    RNScalar last_y = 1.0;
    for (int j = 0; j < grid.YResolution(); j++) {
      RNAngle theta = Theta(j);
      RNScalar y = cos(theta);
      RNScalar dy = last_y - y; last_y = y;
      RNScalar theta_scale = dy / 2;
      RNScalar scale = phi_scale * theta_scale * radius_scale;
      for (int i = 0; i < grid.XResolution(); i++) {
        mean += scale * f(GridValue(i, j, k));
      }
    }
  }

  // Return integral, volume of sphere is 4/3 PI R^3
  RNScalar volume = (4.0/3.0) * RN_PI * max_radius_cubed;
  return mean * volume;
}



RNScalar R3SphericalGrid::
Integral(const R3SphericalGrid& g, RNScalar (*f)(RNScalar, RNScalar)) const
{
  // Return integral of f(grid.value, g.grid.value), weighting terms by surface area
  // radius_scale has fraction of volume in shell
  // theta_scale has fraction of volume in slice (proportional to height of slice)
  // phi_scale has fraction of volume in sector
  // mean is weighted average of grid values
  RNScalar mean = 0.0;
  RNScalar max_radius = RadiusResolution()-1;
  RNScalar max_radius_cubed = max_radius * max_radius * max_radius;
  RNScalar last_radius_cubed = 0;
  RNScalar phi_scale = 1.0 / grid.XResolution();
  for (int k = 1; k < grid.ZResolution(); k++) {
    RNScalar radius = Radius(k);
    RNScalar radius_cubed = radius * radius * radius;
    RNScalar radius_scale = (radius_cubed - last_radius_cubed) / max_radius_cubed;
    last_radius_cubed = radius_cubed;
    RNScalar last_y = 1.0;
    for (int j = 0; j < grid.YResolution(); j++) {
      RNAngle theta = Theta(j);
      RNScalar y = cos(theta);
      RNScalar dy = last_y - y; last_y = y;
      RNScalar theta_scale = dy / 2;
      RNScalar scale = phi_scale * theta_scale * radius_scale;
      for (int i = 0; i < grid.XResolution(); i++) {
        mean += scale * f(GridValue(i, j, k), g.GridValue(i, j, k));
      }
    }
  }

  // Return integral, volume of sphere is 4/3 PI R^3
  return (4.0/3.0) * RN_PI * max_radius_cubed * mean;
}



void R3SphericalGrid::
SetWorldToGridTransformation(const R3Box& world_box)
{
  // Just checking
  if (RadiusResolution() == 0) return;
  if (world_box.NDimensions() < 3) return;

  // Compute grid dimensions
  RNLength grid_radius = RadiusResolution()-1;

  // Compute world origin
  R3Vector world_origin = world_box.Centroid().Vector();

  // Compute scale
  RNScalar scale = FLT_MAX;
  RNScalar xscale = 2.0 * grid_radius / world_box.XLength();
  if (xscale < scale) scale = xscale;
  RNScalar yscale = 2.0 * grid_radius / world_box.YLength();
  if (yscale < scale) scale = yscale;
  RNScalar zscale = 2.0 * grid_radius / world_box.ZLength();
  if (zscale < scale) scale = zscale;

  // Compute world-to-grid transformation
  R3Affine affine(R3identity_affine);
  affine.Scale(scale);
  affine.Translate(-world_origin);

  // Set transformations
  grid.SetWorldToGridTransformation(affine);
}



void R3SphericalGrid::
SetWorldToGridTransformation(const R3Point& world_origin, const R3Vector& world_axis1, const R3Vector& world_axis2, RNLength world_radius)
{
  // Just checking
  if (RadiusResolution() == 0) return;

  // Compute grid origin
  RNScalar grid_radius = RadiusResolution()-1;
  if (RNIsZero(world_radius)) return;
  if (RNIsZero(grid_radius)) return;

  // Compute scale
  RNScalar scale = grid_radius / world_radius;

  // Compute rotation
  R3Triad world_triad(world_axis1, world_axis2);
  R3Affine rotation(world_triad.InverseMatrix());

  // Compute world-to-grid transformation
  R3Affine affine(R3identity_affine);
  affine.Transform(rotation);
  affine.Scale(scale);
  affine.Translate(-(world_origin.Vector()));

  // Set transformations
  grid.SetWorldToGridTransformation(affine);
}



RNScalar R3SphericalGrid::
L1NormFunction(RNScalar value)
{
  // Return absolute value
  return fabs(value);
}



RNScalar R3SphericalGrid::
L2NormFunction(RNScalar value) 
{
  // Return square of value
  return value * value;
}



RNScalar R3SphericalGrid::
VolumeFunction(RNScalar value) 
{
  // Return volume of grid cell
  return (value != 0.0) ? 1 : 0;
}



RNScalar R3SphericalGrid::
DotFunction(RNScalar value1, RNScalar value2)
{
  // Return product of values
  return value1 * value2;
}



RNScalar R3SphericalGrid::
L1DistanceFunction(RNScalar value1, RNScalar value2) 
{
  // Return absolute value of difference between values
  return fabs(value1 - value2);
}



RNScalar R3SphericalGrid::
L2DistanceFunction(RNScalar value1, RNScalar value2) 
{
  // Return square of difference between values
  RNScalar value = value1 - value2;
  return value * value;
}



