// Source file for alignment utility functions



// Include files

#include "R3Shapes/R3Shapes.h"



R3Point 
R3Centroid(int npoints, R3Point *points)
{
  // Compute center of mass
  R3Point centroid(0.0, 0.0, 0.0);
  for (int i = 0; i < npoints; i++) 
    centroid += points[i];
  centroid /= npoints;

  // Return center of mass
  return centroid;
}



R3Triad 
R3PrincipleAxes(const R3Point& centroid, int npoints, R3Point *points, RNScalar *variances)
{
  // Compute covariance matrix
  RNScalar m[9] = { 0 };
  for (int i = 0; i < npoints; i++) {
    RNScalar x = points[i][0] - centroid[0];
    RNScalar y = points[i][1] - centroid[1];
    RNScalar z = points[i][2] - centroid[2];
    m[0] += x*x;
    m[4] += y*y;
    m[8] += z*z;
    m[1] += x*y;
    m[3] += x*y;
    m[2] += x*z;
    m[6] += x*z;
    m[5] += y*z;
    m[7] += y*z;
  }

  // Normalize covariance matrix
  for (int i = 0; i < 9; i++) {
    m[i] /= npoints;
  }

  // Calculate SVD of second order moments
  RNScalar U[9];
  RNScalar W[3];
  RNScalar Vt[9];
  RNSvdDecompose(3, 3, m, U, W, Vt);  // m == U . DiagonalMatrix(W) . Vt

  // Principle axes are in Vt
  R3Vector axes[3];
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      axes[i][j] = Vt[3*i+j];
    }
  }
  
  // Normalize all axis vectors (probably not necessary)
  RNLength length0 = axes[0].Length();
  RNLength length1 = axes[1].Length();
  RNLength length2 = axes[2].Length();
  if (RNIsPositive(length0)) axes[0] /= length0;
  if (RNIsPositive(length1)) axes[1] /= length1;
  if (RNIsPositive(length2)) axes[2] /= length2;

  // Flip axes so that "heavier" on positive side
  int positive_count[3] = { 0, 0, 0 };
  int negative_count[3] = { 0, 0, 0 };
  for (int i = 0; i < npoints; i++) {
    for (int j = 0; j < 3; j++) {
      RNScalar dot = axes[j].Dot(points[i].Vector());
      if (dot > 0.0) positive_count[j]++;
      else negative_count[j]++;
    }
  }
  for (int j =0; j < 3; j++) {
    if (positive_count[j] < negative_count[j]) {
      axes[j].Flip();
    }
  }

  // Compute orthonormal triad of axes
  axes[2] = axes[0] % axes[1];

  // Just checking
  assert(RNIsEqual(axes[0].Length(), 1.0, RN_BIG_EPSILON));
  assert(RNIsEqual(axes[1].Length(), 1.0, RN_BIG_EPSILON));
  assert(RNIsEqual(axes[2].Length(), 1.0, RN_BIG_EPSILON));
  assert(RNIsZero(axes[0].Dot(axes[1]), RN_BIG_EPSILON));
  assert(RNIsZero(axes[1].Dot(axes[2]), RN_BIG_EPSILON));
  assert(RNIsZero(axes[0].Dot(axes[2]), RN_BIG_EPSILON));

  // Return variances (eigenvalues)
  if (variances) {
    variances[0] = W[0];
    variances[1] = W[1];
    variances[2] = W[2];
  }

  // Return triad of axes
  return R3Triad(axes[0], axes[1], axes[2]);
}



RNLength
R3AverageDistance(const R3Point& center, int npoints, R3Point *points)
{
  // Compute average distance between a position on the surface and a center point
  RNScalar distance = 0.0;
  for (int i = 0; i < npoints; i++) 
    distance += R3Distance(points[i], center);
  distance /= npoints;

  // Return average distance
  return distance;
}



R3Affine 
R3NormalizationTransformation(int npoints, R3Point *points,  RNBoolean translate, RNBoolean rotate, int scale) 
{
  // Initialize transformation
  R3Affine affine(R3identity_affine);

  // Compute center of mass
  R3Point centroid = R3Centroid(npoints, points);

  // Translate center of mass back to original (if not translating)
  if (!translate) {
    affine.Translate(centroid.Vector());
  }

  // Scale by inverse of radius
  if ((scale != 0) && (scale != 2)) {
    RNScalar radius = R3AverageDistance(centroid, npoints, points);
    if (RNIsPositive(radius)) affine.Scale(1.0 / radius);
  }

  // Rotate to align principal axes with XYZ
  if (rotate || (scale == 2)) {
    RNScalar variances[3] = { 0 };
    R3Triad triad = R3PrincipleAxes(centroid, npoints, points, variances);
    if (!rotate) affine.Transform(R3Affine(triad.InverseMatrix()));
    if (scale == 2) {
      if (variances[0] > 0) affine.XScale(1.0 / variances[0]);
      if (variances[1] > 0) affine.XScale(1.0 / variances[1]);
      if (variances[2] > 0) affine.XScale(1.0 / variances[2]);
    }
    affine.Transform(R3Affine(triad.InverseMatrix()));
  }

  // Translate center of mass to origin
  affine.Translate(-(centroid.Vector()));
  
  // Return normalization transformation
  return affine;
}



static R4Matrix
SetQuaternion(RNScalar p[4])
{
  R4Matrix m(R4identity_matrix);
  RNScalar l;

  if(p[0]<0){
    p[0]=-p[0];
    p[1]=-p[1];
    p[2]=-p[2];
    p[3]=-p[3];
  }
  l=p[0]*p[0]+p[1]*p[1]+p[2]*p[2]+p[3]*p[3];
  if(l<.000001){return R4identity_matrix;}

  l=sqrt(l);
  p[0]/=l;
  p[1]/=l;
  p[2]/=l;
  p[3]/=l;

  m[0][0]=p[0]*p[0]+p[1]*p[1]-p[2]*p[2]-p[3]*p[3];
  m[0][1]=2*(p[1]*p[2]+p[0]*p[3]);
  m[0][2]=2*(p[1]*p[3]-p[0]*p[2]);

  m[1][0]=2*(p[1]*p[2]-p[0]*p[3]);
  m[1][1]=p[0]*p[0]+p[2]*p[2]-p[1]*p[1]-p[3]*p[3];
  m[1][2]=2*(p[2]*p[3]+p[0]*p[1]);

  m[2][0]=2*(p[1]*p[3]+p[0]*p[2]);
  m[2][1]=2*(p[2]*p[3]-p[0]*p[1]);
  m[2][2]=p[0]*p[0]+p[3]*p[3]-p[1]*p[1]-p[2]*p[2];

  return m;
}


RNScalar 
R3AlignError(R3Point *list1, R3Point *list2, RNScalar* weights, int count, 
  R4Matrix& rotation, R3Point& center1, R3Point& center2, RNScalar s1, RNScalar s2)
{
  RNScalar w = 1;
  RNScalar error = 0;
  for(int i=0;i<count;i++){
    if(weights!=NULL){w=weights[i]*weights[i];}
    R3Vector v1= (list1[i]-center1)/s1;
    R3Vector v2= (list2[i]-center2)/s2;
    R3Vector v = v1 - rotation * v2;
    error += v.Dot(v) * w;
  }
  return sqrt(error);
}


R4Matrix
R3AlignPoints(int count, R3Point *list1, R3Point *list2, RNScalar* weights, RNBoolean align_center, RNBoolean align_rotation, int align_scale)
{
  int i,j,k;

  // Check number of points
  if (count < 1) align_center = 0;
  if (count < 2) align_scale = 0;
  if (count < 3) align_rotation = 0;

  // Compute centers
  R3Point center1(0.0, 0.0, 0.0);
  R3Point center2(0.0, 0.0, 0.0);
  if (align_center){
    center1 = R3Centroid(count, list1);
    center2 = R3Centroid(count, list2);
  }

  // Compute scales
  RNScalar s1 = 1;
  RNScalar s2 = 1;
  if (align_scale){
    s1 = R3AverageDistance(center1, count, list1);
    s2 = R3AverageDistance(center2, count, list2);
  }

  // Compute cross-covariance of two point sets
  R4Matrix rotation = R4identity_matrix;
  if (align_rotation) {
    RNScalar w;
    R4Matrix m = R4identity_matrix;
    m[0][0] = m[1][1] = m[2][2] = 0;
    for (i=0; i< count; i++){
      R3Vector p1 = (list1[i] - center1) / s1;
      R3Vector p2 = (list2[i] - center2) / s2;
      if (weights == NULL) { w = 1; }
      else { w = weights[i]; }
      w *= w;
      for(j=0;j<3;j++){
        for(k=0;k<3;k++){
          m[j][k]+=p1[j]*p2[k]*w;
        }
      }
    }
    for(j=0;j<3;j++){for(k=0;k<3;k++){m[j][k] /= count;}}

    // Make cross-covariance matrix skew-symmetric
    R4Matrix a = R4identity_matrix;
    for(j=0;j<3;j++){for(k=0;k<3;k++){a[j][k]=m[j][k]-m[k][j];}}
    
    // Compute trace of cross-covariance matrix
    RNScalar trace=m[0][0]+m[1][1]+m[2][2];
    
    // Setup symmetric matrix whose eigenvectors give quaternion terms of optimal rotation
    RNScalar M[16];
    M[0]=trace;
    M[1]=M[4]=a[1][2];
    M[2]=M[8]=a[2][0];
    M[3]=M[12]=a[0][1];
    for(j=0;j<3;j++){
      for(k=0;k<3;k++){M[4*(j+1)+(k+1)]=m[j][k]+m[k][j];}
      M[4*(j+1)+(j+1)]-=trace;
    }

    // Perform SVD to get eigenvectors (quaternion terms of optimal rotation)
    RNScalar U[16];
    RNScalar W[4];
    RNScalar Vt[16];
    RNSvdDecompose(4, 4, M, U, W, Vt);  
    
    // Look at error using all eigenvectors and keep best
    int minI=0;
    R4Matrix temp[4];
    RNScalar e[4];
    for(i=0;i<4;i++){
      RNScalar p[4];
      for(j=0;j<4;j++){p[j]=U[4*j+i];}
      if(p[0]<0){for(j=0;j<4;j++){p[j]=-p[j];}}
      temp[i] = SetQuaternion(p);
      e[i]= R3AlignError(list1,list2,weights,count,temp[i],center1,center2,s1,s2);
      if (e[i]<e[minI]) minI=i;
    }
    rotation = temp[minI];
  }

  // Compute result
  R4Matrix result = R4identity_matrix;
  if (align_center) result.Translate(center1.Vector());
  if (align_scale) result.Scale(s1/s2);
  if (align_rotation) result.Transform(rotation);
  if (align_center) result.Translate(-(center2.Vector()));

  // Return resulting matrix that takes list2 to list1
  return result;
}










