/* Source file for the R3 mesh class */




// Include files

#include "R3Shapes/R3Shapes.h"
#include "ply.h"



// Public variables

RNMark R3mesh_mark = 1;



////////////////////////////////////////////////////////////////////////
// CONSTRUCTORS, DESTRUCTORS
////////////////////////////////////////////////////////////////////////

R3Mesh::
R3Mesh(void) 
  : vertex_block(NULL),
    edge_block(NULL),
    face_block(NULL),
    bbox(R3null_box)
{
  // Initialize name
  name[0] = '\0';

  // Just checking
  assert(IsValid());
}



R3Mesh::
~R3Mesh(void) 
{
  // Delete everything
  Empty();
}



////////////////////////////////////////////////////////////////////////
// MESH PROPERTY FUNCTIONS
////////////////////////////////////////////////////////////////////////

R3Point R3Mesh::
Centroid(void) const
{
  // Return centroid of mesh
  RNArea area = 0;
  R3Point centroid(0,0,0);
  for (int i = 0; i < NFaces(); i++) {
    R3MeshFace *face = Face(i);
    RNArea face_area = FaceArea(face);
    R3Point face_centroid = FaceCentroid(face);
    centroid += face_area * face_centroid;
    area += face_area;
  }

  // Return centroid
  if (area == 0) return centroid;
  else return centroid / area;
}



RNLength R3Mesh::
AverageRadius(const R3Point *center) const
{
  // Get centroid
  R3Point centroid = (center) ? *center : Centroid();

  // Compute average distance between a position on the surface and a center point
  RNArea area = 0;
  RNLength distance = 0;
  for (int i = 0; i < NFaces(); i++) {
    R3MeshFace *face = Face(i);
    RNArea face_area = FaceArea(face);
    R3Point face_centroid = FaceCentroid(face);
    distance += face_area * R3Distance(face_centroid, centroid);
    area += face_area;
  }

  // Return weighted average
  if (area == 0) return 0;
  else return distance / area;
}



R3Triad R3Mesh::
PrincipleAxes(const R3Point *center, RNScalar *variances) const
{
  // Get centroid
  R3Point centroid = (center) ? *center : Centroid();

  // Compute covariance matrix
  RNArea area = 0;
  RNScalar m[9] = { 0 };
  for (int i = 0; i < NFaces(); i++) {
    R3MeshFace *face = Face(i);
    RNArea face_area = FaceArea(face);
    R3Point face_centroid = FaceCentroid(face);
    RNScalar x = face_centroid[0] - centroid[0];
    RNScalar y = face_centroid[1] - centroid[1];
    RNScalar z = face_centroid[2] - centroid[2];
    m[0] += face_area * x*x;
    m[4] += face_area * y*y;
    m[8] += face_area * z*z;
    m[1] += face_area * x*y;
    m[3] += face_area * x*y;
    m[2] += face_area * x*z;
    m[6] += face_area * x*z;
    m[5] += face_area * y*z;
    m[7] += face_area * y*z;
    area += face_area;
  }

  // Normalize covariance matrix
  if (area == 0) return R3xyz_triad;
  for (int i = 0; i < 9; i++) m[i] /= area;

  // Compute eigenvalues and eigenvectors
  RNScalar U[9];
  RNScalar W[3];
  RNScalar Vt[9];
  RNSvdDecompose(3, 3, m, U, W, Vt);  // m == U . DiagonalMatrix(W) . Vt

  // Copy principle axes into more convenient form
  // W has eigenvalues (greatest to smallest) and Vt has eigenvectors (normalized)
  R3Vector axes[3];
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      axes[i][j] = Vt[3*i+j];
    }
  }

  // Flip axes so that "heavier" on positive side for first two dimensions
  int positive_count[3] = { 0, 0, 0 };
  int negative_count[3] = { 0, 0, 0 };
  for (int i = 0; i < NVertices(); i++) {
    R3MeshVertex *vertex = Vertex(i);
    R3Vector vertex_vector = VertexPosition(vertex) - centroid;
    for (int j = 0; j < 2; j++) {
      RNScalar dot = axes[j].Dot(vertex_vector);
      if (dot > 0.0) positive_count[j]++;
      else negative_count[j]++;
    }
  }
  for (int j =0; j < 2; j++) {
    if (positive_count[j] < negative_count[j]) {
      axes[j].Flip();
    }
  }

  // Set third axis to form orthonormal triad with other two
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

  // Return triad
  return R3Triad(axes[0], axes[1], axes[2]);
}



R3Affine R3Mesh::
PCANormalizationTransformation(RNBoolean translate, RNBoolean rotate, int scale) const
{
  // Initialize transformation
  R3Affine affine(R3identity_affine);

  // Compute center of mass
  R3Point centroid = Centroid();

  // Translate center of mass back to original (if not translating)
  if (!translate) {
    affine.Translate(centroid.Vector());
  }

  // Scale by inverse of radius
  if ((scale != 0) && (scale != 2)) {
    RNScalar radius = AverageRadius(&centroid);
    if (RNIsPositive(radius)) affine.Scale(1.0 / radius);
  }

  // Rotate to align principal axes with XYZ
  if (rotate || (scale == 2)) {
    RNScalar variances[3];
    R3Triad triad = PrincipleAxes(&centroid, variances);
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
  
  // Return PCA normalization transformation
  return affine;
}



////////////////////////////////////////////////////////////////////////
// VERTEX, EDGE, FACE PROPERTY FUNCTIONS
////////////////////////////////////////////////////////////////////////

R3Vector R3Mesh:: 
EdgeDirection(const R3MeshEdge *e) const
{
  // Returns the normalized vector pointing in direction of the edge
  R3Vector vector = EdgeVector(e);
  RNLength d = EdgeLength(e);
  if (RNIsPositive(d)) vector /= d;
  return vector;
}



RNAngle R3Mesh:: 
EdgeInteriorAngle(const R3MeshEdge *e) const
{
  // Get attached faces
  R3MeshFace *f0 = FaceOnEdge(e, 0);
  R3MeshFace *f1 = FaceOnEdge(e, 1);
  if (!f0 || !f1) return 0.0;

  // Returns the dihedral angle between the attached faces (in range 0 to 2*PI)
  R3Vector cross_normals = FaceNormal(f0) % FaceNormal(f1);
  RNScalar cos_angle = FaceNormal(f0).Dot(FaceNormal(f1));
  RNScalar acos_angle = (RNIsEqual(cos_angle * cos_angle, 1.0, 1.0E-6)) ? 0.0 : acos(cos_angle);
  RNBoolean convex = (cross_normals.Dot(EdgeVector(e)) > 0);
  RNScalar angle = (convex) ? (RN_PI - acos_angle) : (RN_PI + acos_angle);
  assert((angle >= 0.0) && (angle <= RN_TWO_PI));
  return angle;
}



RNScalar R3Mesh:: 
EdgeAspect(const R3MeshEdge *e) const
{
  // Get attached faces
  R3MeshFace *f0 = FaceOnEdge(e, 0);
  R3MeshFace *f1 = FaceOnEdge(e, 1);
  if (!f0 || !f1) return 0.0;

  // Get edge length
  RNScalar edge_length = EdgeLength(e);
  if (RNIsZero(edge_length)) return RN_INFINITY;

  // Get distances between opposite vertices
  R3MeshVertex *v0 = VertexAcrossFace(f0, e);
  R3MeshVertex *v1 = VertexAcrossFace(f1, e);
  RNScalar opposite_length = R3Distance(v0->position, v1->position);

  // Return ratio
  return opposite_length / edge_length;
}



R3Point R3Mesh::
FaceCentroid(const R3MeshFace *f) const
{
  // Return face centroid
  R3Point centroid = R3zero_point;
  centroid += f->vertex[0]->position;
  centroid += f->vertex[1]->position;
  centroid += f->vertex[2]->position;
  return centroid / 3.0;
}



R3Point R3Mesh::
FacePoint(const R3MeshFace *f, RNMagnitude barycentrics[3]) const
{
  // Return point on the face with the given barycentric coordinates
  R3Point point = R3zero_point;
  point += barycentrics[0] * f->vertex[0]->position;
  point += barycentrics[1] * f->vertex[1]->position;
  point += barycentrics[2] * f->vertex[2]->position;
  return point;
}



R3Point R3Mesh::
FaceBarycentric(const R3MeshFace *f, const R3Point &point) const
{
  // From http://www.devmaster.net/wiki/Ray-triangle_intersection
  R3Point p0 = f->vertex[0]->position;
  R3Point p1 = f->vertex[1]->position;
  R3Point p2 = f->vertex[2]->position;
  R3Vector b = p1 - p0;
  R3Vector c = p2 - p0;
  R3Vector p = point - p0;
  RNDimension dim = f->plane.Normal().MaxDimension();
  RNDimension dim0 = (dim+1)%3;
  RNDimension dim1 = (dim+2)%3;
  RNScalar denom = b[dim1]*c[dim0] - b[dim0]*c[dim1];
  if (denom == 0) return R3zero_point;
  RNScalar b1 = (p[dim1]*c[dim0] - p[dim0]*c[dim1]) / denom;
  RNScalar b2 = (p[dim1]*b[dim0] - p[dim0]*b[dim1]) / -denom;
  RNScalar b0 = 1 - b1 - b2;
  return R3Point(b0, b1, b2);
}



const R3Box& R3Mesh::
FaceBBox(const R3MeshFace *f) const
{
  // Update the face bbox
  if (!(f->flags[R3_MESH_FACE_BBOX_UPTODATE]))
    UpdateFaceBBox((R3MeshFace *) f);

  // Return the bbox of the face
  return f->bbox;
}



RNArea R3Mesh::
FaceArea(const R3MeshFace *f) const
{
  // Return area of face
  R3Vector v1 = f->vertex[1]->position - f->vertex[0]->position;
  R3Vector v2 = f->vertex[2]->position - f->vertex[0]->position;
  R3Vector v3 = v1 % v2;
  return 0.5 * v3.Length();
}



////////////////////////////////////////////////////////////////////////
// GEOMETRY MANIPULATION FUNCTIONS
////////////////////////////////////////////////////////////////////////

void R3Mesh::
SetVertexPosition(R3MeshVertex *v, const R3Point& position)
{
  // Set vertex position
  v->position = position;

  // Mark vertex in need of update to normal
  v->flags.Remove(R3_MESH_VERTEX_NORMAL_UPTODATE);

  // Mark edges/faces in need of update
  for (int i = 0; i < v->edges.NEntries(); i++) {
    R3MeshEdge *e = v->edges[i];
    e->flags.Remove(R3_MESH_EDGE_LENGTH_UPTODATE);
    R3MeshFace *f0 = e->face[0];
    if (f0) f0->flags.Remove(R3_MESH_FACE_PLANE_UPTODATE | R3_MESH_FACE_BBOX_UPTODATE);
    R3MeshFace *f1 = e->face[1];
    if (f1) f1->flags.Remove(R3_MESH_FACE_PLANE_UPTODATE | R3_MESH_FACE_BBOX_UPTODATE);
  }

  // Update bounding box
  bbox.Union(position);
}



////////////////////////////////////////////////////////////////////////
// TOPOLOGY TRAVERSAL FUNCTIONS
////////////////////////////////////////////////////////////////////////

R3MeshEdge *R3Mesh::
EdgeBetweenVertices(const R3MeshVertex *v1, const R3MeshVertex *v2) const
{
  // Check if vertices are same
  if (v1 == v2) return NULL;

  // Search for edge in v1's list
  for (int i = 0; i < v1->edges.NEntries(); i++) {
    R3MeshEdge *e = v1->edges[i];
    if (IsVertexOnEdge(v2, e)) return e;
  }

  // Not found
  return NULL;
}



R3MeshEdge *R3Mesh::
EdgeOnVertex(const R3MeshVertex *v, const R3MeshEdge *e, RNDirection dir) const
{
  RNAbort("Not implemented");
  return NULL;
}



R3MeshEdge *R3Mesh::
EdgeOnVertex(const R3MeshVertex *v, const R3MeshFace *f, RNDirection dir) const
{
  // Return edge on v in dir with respect to f
  if (f->vertex[0] == v) {
    if (dir == RN_CCW) return f->edge[0];
    else return f->edge[2];
  }
  else if (f->vertex[1] == v) {
    if (dir == RN_CCW) return f->edge[1];
    else return f->edge[0];
  }
  else if (f->vertex[2] == v) {
    if (dir == RN_CCW) return f->edge[2];
    else return f->edge[1];
  }
  else {
    // Vertex is not on face
    return NULL;
  }
}



R3MeshEdge *R3Mesh:: 
EdgeAcrossVertex(const R3MeshVertex *v, const R3MeshEdge *e, const R3MeshFace *f) const
{
  // Returns edge on the other side of a vertex from an edge on the same face 
  if (v == f->vertex[0]) {
    if (e == f->edge[0]) return f->edge[2];
    else if (e == f->edge[2]) return f->edge[0];
  }
  else if (v == f->vertex[1]) {
    if (e == f->edge[1]) return f->edge[0];
    else if (e == f->edge[0]) return f->edge[1];
  }
  else if (v == f->vertex[2]) {
    if (e == f->edge[2]) return f->edge[1];
    else if (e == f->edge[1]) return f->edge[2];
  }
  return NULL;
}



R3MeshFace *R3Mesh::
FaceBetweenVertices(const R3MeshVertex *v1, const R3MeshVertex *v2, RNDirection dir) const
{
  RNAbort("Not implemented");
  return NULL;
}



R3MeshVertex *R3Mesh::
VertexBetweenEdges(const R3MeshEdge *e1, const R3MeshEdge *e2) const
{
  // Return vertex shared by edges
  if (e1 == e2) return NULL;
  if ((e1->vertex[0] == e2->vertex[0]) || (e1->vertex[0] == e2->vertex[1])) return e1->vertex[0];
  else if ((e1->vertex[1] == e2->vertex[0]) || (e1->vertex[1] == e2->vertex[1])) return e1->vertex[1];
  else return NULL;
}



R3MeshFace *R3Mesh::
FaceBetweenEdges(const R3MeshEdge *e1, const R3MeshEdge *e2) const
{
  // Return face shared by edges
  if (e1 == e2) return NULL;
  if ((e1->face[0]) && ((e1->face[0] == e2->face[0]) || (e1->face[0] == e2->face[1]))) return e1->face[0];
  else if ((e1->face[1]) && ((e1->face[1] == e2->face[0]) || (e1->face[1] == e2->face[1]))) return e1->face[1];
  else return NULL;
}



R3MeshVertex *R3Mesh::
VertexBetweenFaces(const R3MeshFace *f1, const R3MeshFace *f2, RNDirection dir) const
{
  // Check if faces are same
  if (f1 == f2) return NULL;

  // Return vertex connected to both f1 and f2
  R3MeshEdge *e = EdgeBetweenFaces(f1, f2);
  if (e) {
    // Faces lie on same edge, return vertex in dir with respect to f1
    return VertexOnFace(f1, e, dir);
  }
  else {
    // Faces do not lie on the same edge, check if they share a vertex
    if (f1->vertex[0] == f2->vertex[0]) return f1->vertex[0];
    if (f1->vertex[0] == f2->vertex[1]) return f1->vertex[0];
    if (f1->vertex[0] == f2->vertex[2]) return f1->vertex[0];
    if (f1->vertex[1] == f2->vertex[0]) return f1->vertex[1];
    if (f1->vertex[1] == f2->vertex[1]) return f1->vertex[1];
    if (f1->vertex[1] == f2->vertex[2]) return f1->vertex[1];
    if (f1->vertex[2] == f2->vertex[0]) return f1->vertex[2];
    if (f1->vertex[2] == f2->vertex[1]) return f1->vertex[2];
    if (f1->vertex[2] == f2->vertex[2]) return f1->vertex[2];
    return NULL;
  }
}



R3MeshEdge *R3Mesh::
EdgeBetweenFaces(const R3MeshFace *f1, const R3MeshFace *f2) const
{
  if (f1 == f2) return NULL;
  if (FaceAcrossEdge(f1->edge[0], f1) == f2) return f1->edge[0];
  if (FaceAcrossEdge(f1->edge[1], f1) == f2) return f1->edge[1];
  if (FaceAcrossEdge(f1->edge[2], f1) == f2) return f1->edge[2];
  return NULL;
}



////////////////////////////////////////////////////////////////////////
// TOPOLOGY QUERY FUNCTIONS
////////////////////////////////////////////////////////////////////////

void R3Mesh::
FindConnectedFaces(R3MeshFace *seed, RNArray<R3MeshFace *>& faces)
{
  // Fill array with faces in same connected component as seed
  R3mesh_mark++;
  RNArray<R3MeshFace *> stack;
  stack.Insert(seed);
  while (!stack.IsEmpty()) {
    R3MeshFace *face = stack.Tail();
    stack.RemoveTail();
    if (FaceMark(face) != R3mesh_mark) {
      faces.Insert(face);
      if (FaceOnFace(face, 0)) stack.Insert(FaceOnFace(face, 0));
      if (FaceOnFace(face, 1)) stack.Insert(FaceOnFace(face, 1));
      if (FaceOnFace(face, 2)) stack.Insert(FaceOnFace(face, 2));
      SetFaceMark(face, R3mesh_mark);
    }
  }
}


////////////////////////////////////////////////////////////////////////
// MESH MANIPULATION FUNCTIONS
////////////////////////////////////////////////////////////////////////

void R3Mesh::
Empty(void)
{
  // Delete all faces, edges, vertices
  while (NFaces() > 0) DeleteFace(Face(0));
  while (NEdges() > 0) DeleteEdge(Edge(0));
  while (NVertices() > 0) DeleteVertex(Vertex(0));
}



void R3Mesh::
Transform(const R3Transformation& transformation)
{
  // Transform every vertex position
  bbox = R3null_box;
  for (int i = 0; i < NVertices(); i++) {
    R3MeshVertex *vertex = Vertex(i);
    vertex->position.Transform(transformation);
    vertex->flags.Remove(R3_MESH_VERTEX_NORMAL_UPTODATE);
    bbox.Union(vertex->position);
  }

  // Mark every edge out of date
  for (int i = 0; i < NEdges(); i++) {
    R3MeshEdge *edge = Edge(i);
    edge->flags.Remove(R3_MESH_EDGE_LENGTH_UPTODATE);
  }

  // Mark every face out of date
  for (int i = 0; i < NFaces(); i++) {
    R3MeshFace *face = Face(i);
    face->flags.Remove(R3_MESH_FACE_PLANE_UPTODATE | R3_MESH_FACE_BBOX_UPTODATE);
  }
}



////////////////////////////////////////////////////////////////////////
// TOPOLOGY MANIPULATION FUNCTIONS
////////////////////////////////////////////////////////////////////////

R3MeshVertex *R3Mesh::
CreateVertex(const R3Point& position, R3MeshVertex *v)
{
  // Create vertex
  if (!v) {
    v = new R3MeshVertex();
    v->flags.Add(R3_MESH_VERTEX_ALLOCATED);
  }

  // Set position of new vertex
  SetVertexPosition(v, position);

  // Set ID of new vertex
  v->id = vertices.NEntries();

  // Insert vertex into array
  vertices.Insert(v);

  // Return vertex
  return v;
}



R3MeshVertex *R3Mesh::
CreateVertex(const R3Point& position, const R3Vector& normal, R3MeshVertex *v)
{
  // Create vertex
  if (!v) {
    v = new R3MeshVertex();
    v->flags.Add(R3_MESH_VERTEX_ALLOCATED);
  }

  // Set position/normal of new vertex
  SetVertexPosition(v, position);
  SetVertexNormal(v, normal);

  // Set ID of new vertex
  v->id = vertices.NEntries();

  // Insert vertex into array
  vertices.Insert(v);

  // Return vertex
  return v;
}



R3MeshEdge *R3Mesh::
CreateEdge(R3MeshVertex *v1, R3MeshVertex *v2, R3MeshEdge *e)
{
  // Create edge
  if (!e) {
    e = new R3MeshEdge();
    e->flags.Add(R3_MESH_EDGE_ALLOCATED);
  }

  // Update edge-vertex relations
  e->vertex[0] = v1;
  e->vertex[1] = v2;

  // Set ID of new edge
  e->id = edges.NEntries();

  // Insert edge into vertex lists
  v1->edges.Insert(e);
  v2->edges.Insert(e);

  // Insert edge into array
  edges.Insert(e);

  // Return edge
  return e;
}



R3MeshFace *R3Mesh::
CreateFace(R3MeshVertex *v1, R3MeshVertex *v2, R3MeshVertex *v3, R3MeshFace *f)
{
  // Get/create edges
  R3MeshEdge *e1 = EdgeBetweenVertices(v1, v2);
  if (!e1) e1 = CreateEdge(v1, v2);
  R3MeshEdge *e2 = EdgeBetweenVertices(v2, v3);
  if (!e2) e2 = CreateEdge(v2, v3);
  R3MeshEdge *e3 = EdgeBetweenVertices(v3, v1);
  if (!e3) e3 = CreateEdge(v3, v1);
  assert(e1 && e2 && e3);

  // Create face
  return CreateFace(v1, v2, v3, e1, e2, e3, f);
}



R3MeshFace *R3Mesh::
CreateFace(R3MeshEdge *e1, R3MeshEdge *e2, R3MeshEdge *e3, R3MeshFace *f)
{
  // Get vertices
  R3MeshVertex *v1 = VertexBetweenEdges(e3, e1);
  R3MeshVertex *v2 = VertexBetweenEdges(e1, e2);
  R3MeshVertex *v3 = VertexBetweenEdges(e2, e3);
  assert(v1 && v2 && v3);

  // Create face
  return CreateFace(v1, v2, v3, e1, e2, e3, f);
}



R3MeshFace *R3Mesh::
CreateFace(R3MeshVertex *v1, R3MeshVertex *v2, R3MeshVertex *v3,
           R3MeshEdge *e1, R3MeshEdge *e2, R3MeshEdge *e3, R3MeshFace *f)
{
  // Check if two faces share same side of same edge
  if ((e1->vertex[0] == v1) && e1->face[0]) return NULL;
  if ((e1->vertex[0] == v2) && e1->face[1]) return NULL;
  if ((e2->vertex[0] == v2) && e2->face[0]) return NULL;
  if ((e2->vertex[1] == v3) && e2->face[1]) return NULL;
  if ((e3->vertex[0] == v3) && e3->face[0]) return NULL;
  if ((e3->vertex[1] == v1) && e3->face[1]) return NULL;

  // Create face
  if (!f) {
    f = new R3MeshFace();
    f->flags.Add(R3_MESH_FACE_ALLOCATED);
  }

  // Update face pointers
  UpdateFaceRefs(f, v1, v2, v3, e1, e2, e3);

  // Set face ID
  f->id = faces.NEntries();

  // Insert face into array
  faces.Insert(f);

  // Return face
  return f;
}



void R3Mesh::
DeallocateVertex(R3MeshVertex *v)
{
  // Remove vertex from mesh array by moving last vertex
  assert(!vertices.IsEmpty());
  R3MeshVertex *tail = vertices.Tail();
  int index = v->id;
  RNArrayEntry *entry = vertices.KthEntry(index);
  assert(vertices.EntryContents(entry) == v);
  vertices.EntryContents(entry) = tail;
  tail->id = index;
  vertices.RemoveTail();

  // Reset ID to ease debugging
  v->id = -1;

  // Deallocate vertex
  if (v->flags[R3_MESH_VERTEX_ALLOCATED]) delete v;
}



void R3Mesh::
DeallocateEdge(R3MeshEdge *e)
{
  // Remove edge from mesh array by moving last edge
  assert(!edges.IsEmpty());
  R3MeshEdge *tail = edges.Tail();
  int index = e->id;
  RNArrayEntry *entry = edges.KthEntry(index);
  assert(edges.EntryContents(entry) == e);
  edges.EntryContents(entry) = tail;
  tail->id = index;
  edges.RemoveTail();

  // Reset ID to ease debugging
  e->id = -1;

  // Deallocate edge
  if (e->flags[R3_MESH_EDGE_ALLOCATED]) delete e;
}



void R3Mesh::
DeallocateFace(R3MeshFace *f)
{
  // Remove face from mesh array by moving last face
  assert(!faces.IsEmpty());
  R3MeshFace *tail = faces.Tail();
  int index = f->id;
  RNArrayEntry *entry = faces.KthEntry(index);
  assert(faces.EntryContents(entry) == f);
  faces.EntryContents(entry) = tail;
  tail->id = index;
  faces.RemoveTail();

  // Reset ID to ease debugging
  f->id = -1;

  // Deallocate face
  if (f->flags[R3_MESH_FACE_ALLOCATED]) delete f;
}



void R3Mesh::
DeleteVertex(R3MeshVertex *v)
{
  // Delete edges attached to vertex
  RNArray<R3MeshEdge *> vertex_edges = v->edges;
  for (int i = 0; i < vertex_edges.NEntries(); i++) 
    DeleteEdge(vertex_edges.Kth(i));

  // Deallocate vertex
  DeallocateVertex(v);
}



void R3Mesh::
DeleteEdge(R3MeshEdge *e)
{
  // Delete faces attached to edge
  if (e->face[0]) DeleteFace(e->face[0]);
  if (e->face[1]) DeleteFace(e->face[1]);

  // Remove edge from vertex arrays
  e->vertex[0]->edges.Remove(e);
  e->vertex[1]->edges.Remove(e);

  // Deallocate edge
  DeallocateEdge(e);
}



void R3Mesh::
DeleteFace(R3MeshFace *f)
{
  // Update edge-face relations
  if (f->edge[0]->face[0] == f) f->edge[0]->face[0] = NULL;
  if (f->edge[0]->face[1] == f) f->edge[0]->face[1] = NULL;
  if (f->edge[1]->face[0] == f) f->edge[1]->face[0] = NULL;
  if (f->edge[1]->face[1] == f) f->edge[1]->face[1] = NULL;
  if (f->edge[2]->face[0] == f) f->edge[2]->face[0] = NULL;
  if (f->edge[2]->face[1] == f) f->edge[2]->face[1] = NULL;

  // Deallocate face
  DeallocateFace(f);
}



R3MeshVertex* R3Mesh::
MergeVertex(R3MeshVertex *v1, R3MeshVertex *v2)
{
#if 0
  // Check if there is an edge between the vertices
  // R3MeshEdge *e = EdgeBetweenVertices(v1, v2);
  // if (e) return CollapseEdge(e, v1->position);

  while (TRUE) {
    // Find a vertex v3 connected by edges to both v1 and v2
    R3MeshEdge *e1 = NULL;
    R3MeshEdge *e2 = NULL;
    R3MeshVertex *v3 = NULL;
    for (int i = 0; i < VertexValence(v1); i++) {
      e1 = EdgeOnVertex(v1, i);
      R3MeshVertex *ve1 = VertexAcrossEdge(e1, v1);
      for (int j = 0; j < VertexValence(v2); j++) {
        e2 = EdgeOnVertex(v2, j);
        R3MeshVertex *ve2 = VertexAcrossEdge(e2, v2);
        if (ve1 == ve2) { 
          v3 = ve1; 
          break; 
        }
      }
    }

    if (!v3) break;


    // Find all vertices in the triangle between v1, v2, and v3
    R3mesh_mark++;
    SetVertexMark(v1, R3mesh_mark);
    SetVertexMark(v2, R3mesh_mark);
    SetVertexMark(v3, R3mesh_mark);
    RNArray<R3MeshFace *> faces;
    R3MeshFace *f1 = FaceOnEdge(e1, v1, RN_CW);
    if (f1) faces.Insert(f1);
    R3MeshFace *f2 = FaceOnEdge(e2, v2, RN_CCW);
    if (f2) faces.Insert(f2);
    while (!faces.IsEmpty()) {
    }

  }

  // Get vertices on edge
  R3MeshVertex *v[2];
  v[0] = edge->vertex[0];
  v[1] = edge->vertex[1];

  // Get faces on edge
  R3MeshFace *f[2];
  f[0] = edge->face[0];
  f[1] = edge->face[1];

  // Get other edges and vertex on faces
  R3MeshEdge *ef[2][2] = { { NULL, NULL }, { NULL, NULL } };
  R3MeshFace *ff[2][2] = { { NULL, NULL }, { NULL, NULL } };
  R3MeshVertex *vf[2] = { NULL, NULL };
  if (f[0]) {
    ef[0][0] = EdgeAcrossVertex(v[0], edge, f[0]);
    ef[0][1] = EdgeAcrossVertex(v[1], edge, f[0]);
    vf[0] = VertexAcrossEdge(ef[0][1], v[1]);
    assert(vf[0] == VertexAcrossEdge(ef[0][0], v[0]));
    ff[0][0] = FaceAcrossEdge(ef[0][0], f[0]);
    ff[0][1] = FaceAcrossEdge(ef[0][1], f[0]);
  }
  if (f[1]) {
    ef[1][0] = EdgeAcrossVertex(v[0], edge, f[1]);
    ef[1][1] = EdgeAcrossVertex(v[1], edge, f[1]);
    vf[1] = VertexAcrossEdge(ef[1][1], v[1]);
    assert(vf[1] == VertexAcrossEdge(ef[1][0], v[0]));
    ff[1][0] = FaceAcrossEdge(ef[1][0], f[1]);
    ff[1][1] = FaceAcrossEdge(ef[1][1], f[1]);
  }

  // Make an array of vertices attached by edges to both v1 and v2
  RNArray<R3MeshVertices *> adjacent_vertices;
  for (int i = 0; i < VertexValence(v1); i++) {
    R3MeshEdge *e1 = EdgeOnVertex(v1, i);
    R3MeshVertex *ve1 = VertexAcrossEdge(e1, v1);
    for (int j = 0; j < VertexValence(v2); j++) {
      R3MeshEdge *e2 = EdgeOnVertex(v2, j);
      R3MeshVertex *ve2 = VertexAcrossEdge(e2, v2);
      if (ve1 == ve2) {
        // Check for fin
        for (int k1 = 0; k1 < 2; k1++) {
          R3MeshFace *f1 = FaceOnEdge(e1, k1);
          if (f1) {
            R3MeshVertex *vf1 = VertexAcrossFace(f1, e1);
            for (int k2 = 0; k2 < 2; k2++) {
              R3MeshFace *f2 = FaceOnEdge(e2, k2);
              if (f2) {
                R3MeshVertex *vf2 = VertexAcrossFace(f2, e2);
                if (vf1 == vf2) return NULL;
              }
            }
          }
        }

        // Remember adjacent vertex
        adjacent_vertices.Insert(ve1);
      }
    }
  }

  // Check if vertices are connected
  if (adjacent_vertices.IsEmpty()) {
 }

  // v1 and v2 are not connected, merge references to/from v2 into v1
  for (int i = 0; i < v2->edges.NEntries(); i++) {
    R3MeshEdge *e2 = v2->edges.Kth(i);

    // Update edge-vertex relations 
    for (int j = 0; j < 2; j++) {
      if (e2->vertex[j] == v2) e2->vertex[j] = v1;
    }

    // Update face-vertex relations 
    for (int j = 0; j < 2; j++) {
      R3MeshEdge *f2 = e2->face[j];
      for (int k = 0; k < 3; k++) {
        if (f2->vertex[k] == v2) f2->vertex[k] = v1;
      }
    }

    // Update vertex-edge relations 
    v1->edges.Insert(e2);
  }
 
  // Deallocate vertex
  DeallocateVertex(v2);

  // Return remaining vertex
  return v1;
#else
  RNAbort("Not implemented");
  return NULL;
#endif
}



void R3Mesh::
MergeCoincidentVertices(RNLength epsilon)
{
  // Compute epsilon
  if (epsilon < 0.0) epsilon = 0.0001 * bbox.DiagonalLength();

  // Load all vertices into a regular grid
  const int NUM_GRID_CELLS = 32;
  RNArray<R3MeshVertex *> grid[NUM_GRID_CELLS][NUM_GRID_CELLS][NUM_GRID_CELLS];
  for (int i = 0; i < vertices.NEntries(); i++) {
    R3MeshVertex *v = vertices[i];
    const R3Point& p = v->position;
    int ix = (int) (NUM_GRID_CELLS * (p.X() - bbox.XMin()) / bbox.XLength());
    int iy = (int) (NUM_GRID_CELLS * (p.Y() - bbox.YMin()) / bbox.YLength());
    int iz = (int) (NUM_GRID_CELLS * (p.Z() - bbox.ZMin()) / bbox.ZLength());
    if (ix < 0) ix = 0; else if (ix > NUM_GRID_CELLS-1) ix = NUM_GRID_CELLS-1;
    if (iy < 0) iy = 0; else if (iy > NUM_GRID_CELLS-1) iy = NUM_GRID_CELLS-1;
    if (iz < 0) iz = 0; else if (iz > NUM_GRID_CELLS-1) iz = NUM_GRID_CELLS-1;
    grid[ix][iy][iz].Insert(v);
  }

  // Merge coincident vertices in same grid cell
  for (int ix = 0; ix < NUM_GRID_CELLS; ix++) {
    for (int iy = 0; iy < NUM_GRID_CELLS; iy++) {
      for (int iz = 0; iz < NUM_GRID_CELLS; iz++) {
        // Consider all pairs of vertices in same cell
        for (int j = 0; j < grid[ix][iy][iz].NEntries(); j++) {
          R3MeshVertex *v1 = grid[ix][iy][iz].Kth(j);
          for (int k = j+1; k < grid[ix][iy][iz].NEntries(); k++) {
            R3MeshVertex *v2 = grid[ix][iy][iz].Kth(k);
            // Check if vertices are coincident
            if (R3Contains(v1->position, v2->position)) {
              // Merge coincident vertices
              MergeVertex(v1, v2);
            }
          }
        }
      }
    }
  }
}



R3MeshVertex *R3Mesh::
CollapseEdge(R3MeshEdge *edge, const R3Point& point)
{
  // Get vertices on edge
  R3MeshVertex *v[2];
  v[0] = edge->vertex[0];
  v[1] = edge->vertex[1];

  // Get faces on edge
  R3MeshFace *f[2];
  f[0] = edge->face[0];
  f[1] = edge->face[1];

#if 1
  // Get other edges and vertex on faces
  R3MeshEdge *ef[2][2] = { { NULL, NULL }, { NULL, NULL } };
  R3MeshFace *ff[2][2] = { { NULL, NULL }, { NULL, NULL } };
  R3MeshVertex *vf[2] = { NULL, NULL };
  if (f[0]) {
    ef[0][0] = EdgeAcrossVertex(v[0], edge, f[0]);
    ef[0][1] = EdgeAcrossVertex(v[1], edge, f[0]);
    vf[0] = VertexAcrossEdge(ef[0][1], v[1]);
    assert(vf[0] == VertexAcrossEdge(ef[0][0], v[0]));
    ff[0][0] = FaceAcrossEdge(ef[0][0], f[0]);
    ff[0][1] = FaceAcrossEdge(ef[0][1], f[0]);
  }
  if (f[1]) {
    ef[1][0] = EdgeAcrossVertex(v[0], edge, f[1]);
    ef[1][1] = EdgeAcrossVertex(v[1], edge, f[1]);
    vf[1] = VertexAcrossEdge(ef[1][1], v[1]);
    assert(vf[1] == VertexAcrossEdge(ef[1][0], v[0]));
    ff[1][0] = FaceAcrossEdge(ef[1][0], f[1]);
    ff[1][1] = FaceAcrossEdge(ef[1][1], f[1]);
  }

  // Check if will create a fin
  for (int i = 0; i < VertexValence(v[0]); i++) {
    R3MeshEdge *e0 = EdgeOnVertex(v[0], i);
    if ((e0 == ef[0][0]) || (e0 == ef[1][0])) continue;
    R3MeshVertex *ve0 = VertexAcrossEdge(e0, v[0]);
    for (int j = 0; j < VertexValence(v[1]); j++) {
      R3MeshEdge *e1 = EdgeOnVertex(v[1], j);
      if ((e1 == ef[0][1]) || (e1 == ef[1][1])) continue;
      R3MeshVertex *ve1 = VertexAcrossEdge(e1, v[1]);
      if (ve0 == ve1) return NULL;
    }
  }

  // Update vertex-edge relations
  v[0]->edges.Remove(edge);
  for (int i = 0; i < v[1]->edges.NEntries(); i++) {
    R3MeshEdge *ev1 = v[1]->edges[i];
    if (ev1 == edge) continue;
    if (ev1 == ef[0][1]) continue;
    if (ev1 == ef[1][1]) continue;
    v[0]->edges.Insert(ev1);
  }
  if (f[0]) {
    assert(vf[0] && ef[0][1]);
    vf[0]->edges.Remove(ef[0][1]);
  }
  if (f[1]) {
    assert(vf[1] && ef[1][1]);
    vf[1]->edges.Remove(ef[1][1]);
  }

  // Update edge-vertex relations (v[1]->v[0]) 
  for (int i = 0; i < v[1]->edges.NEntries(); i++) {
    R3MeshEdge *ev = v[1]->edges[i];
    for (int j = 0; j < 2; j++) {
      if (ev->vertex[j] == v[1]) ev->vertex[j] = v[0];
    }
  }
  
  // Update edge-face relations (ef[i][1]->ef[i][0])
  for (int i = 0; i < 2; i++) {
    if (!f[i]) continue;
    assert(ef[i][0]);
    for (int j = 0; j < 2; j++) {
      if (ef[i][0]->face[j] == f[i]) ef[i][0]->face[j] = ff[i][1];
    }
  }

  // Update face-vertex relations (v[1]->v[0])
  for (int i = 0; i < v[1]->edges.NEntries(); i++) {
    R3MeshEdge *ev = v[1]->edges[i];
    for (int j = 0; j < 2; j++) {
      R3MeshFace *fv = ev->face[j];
      if (fv) {
        for (int k = 0; k < 3; k++) {
          if (fv->vertex[k] == v[1]) fv->vertex[k] = v[0];
        }
      }
    }
  }
  
  // Update face-edge relations (ef[i][1]->ef[i][0])
  for (int i = 0; i < 2; i++) {
    if (!f[i]) continue;
    if (!ff[i][1]) continue;
    for (int j = 0; j < 3; j++) {
      if (ff[i][1]->edge[j] == ef[i][1]) {
        ff[i][1]->edge[j] = ef[i][0];
      }
    }
  }

  // Deallocate faces 
  if (f[0]) DeallocateFace(f[0]);
  if (f[1]) DeallocateFace(f[1]);

  // Deallocate edges
  if (f[0]) DeallocateEdge(ef[0][1]);
  if (f[1]) DeallocateEdge(ef[1][1]);
  DeallocateEdge(edge);

  // Deallocate vertex
  DeallocateVertex(v[1]);

  // Set position of remaining vertex
  SetVertexPosition(v[0], point);

  // Return remaining vertex
  return v[0];
#else
  // Set vertex position 
  SetVertexPosition(v[0], point);

  // Make arrays of everything attached to v[1]
  R3mesh_mark++;
  RNArray<R3MeshFace *> faces_to_remove;
  RNArray<R3MeshEdge *> edges_to_remove;
  RNArray<R3MeshVertex *> cw_vertices;
  RNArray<R3MeshVertex *> ccw_vertices;
  for (int i = 0; i < v[1]->edges.NEntries(); i++) {
    R3MeshEdge *v1_e = v[1]->edges[i];
    edges_to_remove.Insert(v1_e);
    R3MeshFace *v1_f = FaceOnEdge(v1_e, v[1], RN_CCW);
    if (v1_f) {
      faces_to_remove.Insert(v1_f);
      if ((v1_f != f[0]) && (v1_f != f[1])) {
        cw_vertices.Insert(VertexOnFace(v1_f, v[1], RN_CW));
        ccw_vertices.Insert(VertexOnFace(v1_f, v[1], RN_CCW));
      }
    }
  }

  // Remove everything attached to v1
  for (int i = 0; i < faces_to_remove.NEntries(); i++) 
    DeleteFace(faces_to_remove[i]);
  for (int i = 0; i < edges_to_remove.NEntries(); i++) 
    DeleteEdge(edges_to_remove[i]);
  DeleteVertex(v[1]);

  // Recreate everything by replacing v1 with v0
  for (int i = 0; i < cw_vertices.NEntries(); i++) {
    CreateFace(v[0], cw_vertices[i], ccw_vertices[i]);
  }

  // Return remaining vertex
  return v[0];
#endif
}



R3MeshVertex *R3Mesh::
CollapseEdge(R3MeshEdge *edge)
{
  // Collapse edge and put new vertex at midpoint
  return CollapseEdge(edge, EdgeMidpoint(edge));
}



R3MeshVertex *R3Mesh::
CollapseFace(R3MeshFace *f, const R3Point& point)
{
  R3MeshVertex *v0 = VertexOnFace(f, 0);
  R3MeshVertex *v1 = VertexOnFace(f, 1);
  R3MeshVertex *v2 = VertexOnFace(f, 2);
  R3MeshEdge *e01 = EdgeBetweenVertices(v0, v1);
  R3MeshVertex *v01 = CollapseEdge(e01, point);
  if (!v01) return NULL;
  R3MeshEdge *e012 = EdgeBetweenVertices(v01, v2);
  assert(e012);
  R3MeshVertex *v012 = CollapseEdge(e012, point);
  return v012;
}



R3MeshVertex *R3Mesh::
CollapseFace(R3MeshFace *face)
{
  // Collapse face and put new vertex at centroid
  return CollapseFace(face, FaceCentroid(face));
}



R3MeshVertex *R3Mesh::
SplitEdge(R3MeshEdge *edge, const R3Point& point, R3MeshEdge **e0, R3MeshEdge **e1)
{
  // Create vertex at split point
  R3MeshVertex *vertex = CreateVertex(point);

  // Get vertices on edge
  R3MeshVertex *v[2];
  v[0] = edge->vertex[0];
  v[1] = edge->vertex[1];

  // Get faces on edge
  R3MeshFace *f[2];
  f[0] = edge->face[0];
  f[1] = edge->face[1];

  // Get other edges and vertex on f[0]
  R3MeshEdge *ef[2][2] = { { NULL, NULL }, { NULL, NULL } };
  R3MeshVertex *vf[2] = { NULL, NULL };
  int m[2] = { 0, 0 };
  int s[2] = { 0, 0 };
  if (f[0]) {
    ef[0][0] = EdgeAcrossVertex(v[0], edge, f[0]);
    ef[0][1] = EdgeAcrossVertex(v[1], edge, f[0]);
    vf[0] = VertexAcrossEdge(ef[0][1], v[1]);
    assert(vf[0] == VertexAcrossEdge(ef[0][0], v[0]));
    m[0] = FaceMaterial(f[0]);
    s[0] = FaceSegment(f[0]);
  }
  if (f[1]) {
    ef[1][0] = EdgeAcrossVertex(v[0], edge, f[1]);
    ef[1][1] = EdgeAcrossVertex(v[1], edge, f[1]);
    vf[1] = VertexAcrossEdge(ef[1][1], v[1]);
    assert(vf[1] == VertexAcrossEdge(ef[1][0], v[0]));
    m[1] = FaceMaterial(f[1]);
    s[1] = FaceSegment(f[1]);
  }

  // Delete the edge and the two adjacent faces
  if (f[0]) DeleteFace(f[0]);
  if (f[1]) DeleteFace(f[1]);
  DeleteEdge(edge);

  // Create two new edges
  R3MeshEdge *e[2];
  e[0] = CreateEdge(v[0], vertex);
  e[1] = CreateEdge(vertex, v[1]);

  // Create two new faces on one side
  if (f[0]) {
    // Create edge splitting f[0]
    R3MeshEdge *es = CreateEdge(vertex, vf[0]);

    // Create new face on v[0] side of split
    assert((vf[0] != v[0]) && (vf[0] != vertex) && (v[0] != vertex));
    assert((ef[0][0] != e[0]) && (ef[0][0] != es) && (e[0] != es));
    R3MeshFace *f00 = CreateFace(vf[0], v[0], vertex, ef[0][0], e[0], es);
    SetFaceMaterial(f00, m[0]);
    SetFaceSegment(f00, s[0]);

    // Create new face on v[1] side of split
    assert((es != e[1]) && (es != ef[0][1]) && (e[1] != ef[0][1]));
    R3MeshFace *f01 = CreateFace(vf[0], vertex, v[1], es, e[1], ef[0][1]);
    SetFaceMaterial(f01, m[0]);
    SetFaceSegment(f01, s[0]);
  }

  // Create two new faces on other side
  if (f[1]) {
    // Create edge splitting f[1]
    R3MeshEdge *es = CreateEdge(vertex, vf[1]);
    
    // Create new face on v[1] side of split
    assert((vf[1] != v[1]) && (vf[1] != vertex) && (v[1] != vertex));
    assert((ef[1][1] != e[1]) && (ef[1][1] != es) && (e[1] != es));
    R3MeshFace *f10 = CreateFace(vf[1], v[1], vertex, ef[1][1], e[1], es);
    SetFaceMaterial(f10, m[1]);
    SetFaceSegment(f10, s[1]);

    // Create new face on v[0] side of split
    assert((es != e[0]) && (es != ef[1][0]) && (e[0] != ef[1][0]));
    R3MeshFace *f11 = CreateFace(vf[1], vertex, v[0], es, e[0], ef[1][0]);
    SetFaceMaterial(f11, m[1]);
    SetFaceSegment(f11, s[1]);
  }

  // Return edges
  if (e0) *e0 = e[0];
  if (e1) *e1 = e[1];

  // Return vertex
  return vertex;
}



R3MeshVertex *R3Mesh::
SplitEdge(R3MeshEdge *e, const R3Plane& plane)
{
  // Compute intersection point with plane
  RNScalar t;
  R3Point point;
  R3Span edge_span = EdgeSpan(e);
  if (!R3Intersects(edge_span, plane, &point, &t)) return NULL;
  if ((RNIsEqual(t, 0.0)) || (RNIsEqual(t, edge_span.Length()))) return NULL;

  // Split edge
  return SplitEdge(e, point);
}



R3MeshVertex *R3Mesh::
SubdivideEdge(R3MeshEdge *e)
{
  // Split edge at midpoint
  return SplitEdge(e, EdgeMidpoint(e));
}



R3MeshVertex *R3Mesh::
SplitFace(R3MeshFace *f, const R3Point& point, R3MeshFace **f0, R3MeshFace **f1, R3MeshFace **f2)
{
  // Find vertices/edges bounding face
  R3MeshVertex *v0 = VertexOnFace(f, 0);
  R3MeshEdge *e0 = EdgeOnFace(f, v0, RN_CCW);
  R3MeshVertex *v1 = VertexAcrossEdge(e0, v0);
  R3MeshEdge *e1 = EdgeOnFace(f, v1, RN_CCW);
  R3MeshVertex *v2 = VertexAcrossEdge(e1, v1);
  R3MeshEdge *e2 = EdgeOnFace(f, v2, RN_CCW);
  int m = FaceMaterial(f);
  int s = FaceSegment(f);

  // Delete face
  DeleteFace(f);

  // Create new vertex at point
  R3MeshVertex *vertex = CreateVertex(point);

  // Create three new edges
  R3MeshEdge *s0 = CreateEdge(v0, vertex);
  R3MeshEdge *s1 = CreateEdge(v1, vertex);
  R3MeshEdge *s2 = CreateEdge(v2, vertex);

  // Create three new faces
  R3MeshFace *t0 = CreateFace(vertex, v0, v1, s0, e0, s1);
  R3MeshFace *t1 = CreateFace(vertex, v1, v2, s1, e1, s2);
  R3MeshFace *t2 = CreateFace(vertex, v2, v0, s2, e2, s0);
  
  // Set face materials
  SetFaceMaterial(t0, m);
  SetFaceMaterial(t1, m);
  SetFaceMaterial(t2, m);

  // Set face segments
  SetFaceSegment(t0, s);
  SetFaceSegment(t1, s);
  SetFaceSegment(t2, s);

  // Return created faces
  if (f0) *f0 = t0;
  if (f1) *f1 = t1;
  if (f2) *f2 = t2;

  // Return new vertex
  return vertex;
}



R3MeshFace *R3Mesh::
SubdivideFace(R3MeshFace *f)
{
  // Find vertices/edges bounding face
  R3MeshVertex *v0 = VertexOnFace(f, 0);
  R3MeshEdge *e0 = EdgeOnFace(f, v0, RN_CCW);
  R3MeshVertex *v1 = VertexAcrossEdge(e0, v0);
  R3MeshEdge *e1 = EdgeOnFace(f, v1, RN_CCW);
  R3MeshVertex *v2 = VertexAcrossEdge(e1, v1);
  R3MeshEdge *e2 = EdgeOnFace(f, v2, RN_CCW);
  int m = FaceMaterial(f);
  int s = FaceSegment(f);

  // Delete face
  DeleteFace(f);

  // Subdivide edges
  R3MeshVertex *ve0 = SubdivideEdge(e0);
  R3MeshVertex *ve1 = SubdivideEdge(e1);
  R3MeshVertex *ve2 = SubdivideEdge(e2);

  // Create new faces
  R3MeshFace *f1 = CreateFace(v0, ve0, ve2);  
  R3MeshFace *f2 = CreateFace(v1, ve1, ve0);  
  R3MeshFace *f3 = CreateFace(v2, ve2, ve1);  
  R3MeshFace *f4 = CreateFace(ve0, ve1, ve2);  

  // Set face materials
  SetFaceMaterial(f1, m);
  SetFaceMaterial(f2, m);
  SetFaceMaterial(f3, m);
  SetFaceMaterial(f4, m);

  // Set face segments
  SetFaceSegment(f1, s);
  SetFaceSegment(f2, s);
  SetFaceSegment(f3, s);
  SetFaceSegment(f4, s);

  // Return interior face
  return f4;
}



int R3Mesh::
SwapEdge(R3MeshEdge *edge)
{
  // Get vertices on edge
  R3MeshVertex *v[2];
  v[0] = edge->vertex[0];
  v[1] = edge->vertex[1];

  // Get faces on edge
  R3MeshFace *f[2];
  f[0] = edge->face[0];
  f[1] = edge->face[1];
  if (!f[0] || !f[1]) return 0;

  // Get edges and vertices across faces
  R3MeshEdge *ef[2][2] = { { NULL, NULL }, { NULL, NULL } };
  R3MeshVertex *vf[2] = { NULL, NULL };
  ef[0][0] = EdgeAcrossVertex(v[0], edge, f[0]);
  ef[0][1] = EdgeAcrossVertex(v[1], edge, f[0]);
  vf[0] = VertexAcrossEdge(ef[0][1], v[1]);
  assert(vf[0] == VertexAcrossEdge(ef[0][0], v[0]));
  ef[1][0] = EdgeAcrossVertex(v[0], edge, f[1]);
  ef[1][1] = EdgeAcrossVertex(v[1], edge, f[1]);
  vf[1] = VertexAcrossEdge(ef[1][1], v[1]);
  assert(vf[1] == VertexAcrossEdge(ef[1][0], v[0]));
  if (EdgeBetweenVertices(vf[0], vf[1])) return 0;

  // Update vertices
  v[0]->edges.Remove(edge);
  v[1]->edges.Remove(edge);
  vf[0]->edges.Insert(edge);
  vf[1]->edges.Insert(edge);

  // Update edge
  edge->vertex[0] = vf[0];
  edge->vertex[1] = vf[1];
  edge->length = 0;
  edge->flags = 0;

  // Update faces
  UpdateFaceRefs(f[0], vf[0], vf[1], v[1], edge, ef[1][1], ef[0][1]);
  UpdateFacePlane(f[0]);
  UpdateFaceBBox(f[0]);
  UpdateFaceRefs(f[1], vf[1], vf[0], v[0], edge, ef[0][0], ef[1][0]);
  UpdateFacePlane(f[1]);
  UpdateFaceBBox(f[1]);

  // Return success
  return 1;
}



void R3Mesh::
FlipEdge(R3MeshEdge *e)
{
  // Reverse order of vertices
  R3MeshVertex *v = e->vertex[0];
  e->vertex[0] = e->vertex[1];
  e->vertex[1] = v;

  // Reverse order of faces
  R3MeshFace *f = e->face[0];
  e->face[0] = e->face[1];
  e->face[1] = f;
}



void R3Mesh::
FlipFace(R3MeshFace *f)
{
  // Reverse orientation of plane
  f->plane.Flip();

  // Reverse order of vertices
  R3MeshVertex *vswap = f->vertex[0];
  f->vertex[0] = f->vertex[2];
  f->vertex[2] = vswap;

  // Reverse order of edges
  R3MeshEdge *eswap = f->edge[0];
  f->edge[0] = f->edge[1];
  f->edge[1] = eswap;
}



////////////////////////////////////////////////////////////////////////
// DRAW FUNCTIONS
////////////////////////////////////////////////////////////////////////

void R3Mesh::
DrawVertices(void) const
{
  // Draw all vertices
  for (int i = 0; i < vertices.NEntries(); i++)
    DrawVertex(vertices[i]);
}



void R3Mesh::
DrawEdges(void) const
{
  // Draw all edges
  for (int i = 0; i < edges.NEntries(); i++)
    DrawEdge(edges[i]);
}



void R3Mesh::
DrawFaces(void) const
{
  // Draw all faces
  for (int i = 0; i < faces.NEntries(); i++) 
    DrawFace(faces[i]);
}



void R3Mesh::
DrawVertexIDs(void) const
{
  // Draw all vertex IDs
  glDisable(GL_LIGHTING);
  for (int i = 0; i < vertices.NEntries(); i++) {
    assert(vertices[i]->id == i);
    unsigned char r = ((i << 16) && 0xFF);
    unsigned char g = (i << 8) && 0xFF;
    unsigned char b = (i << 0) && 0xFF;
    glColor3ub(r, g, b);
    DrawVertex(vertices[i]);
  }
  glEnable(GL_LIGHTING);
}



void R3Mesh::
DrawEdgeIDs(void) const
{
  // Draw all edge IDs
  glDisable(GL_LIGHTING);
  for (int i = 0; i < edges.NEntries(); i++) {
    assert(edges[i]->id == i);
    unsigned char r = ((i << 16) && 0xFF);
    unsigned char g = (i << 8) && 0xFF;
    unsigned char b = (i << 0) && 0xFF;
    glColor3ub(r, g, b);
    DrawEdge(edges[i]);
  }
  glEnable(GL_LIGHTING);
}



void R3Mesh::
DrawFaceIDs(void) const
{
  // Draw all face IDs
  glDisable(GL_LIGHTING);
  for (int i = 0; i < faces.NEntries(); i++) {
    assert(faces[i]->id == i);
    unsigned char r = (i << 16) && 0xFF;
    unsigned char g = (i << 8) && 0xFF;
    unsigned char b = (i << 0) && 0xFF;
    glColor3ub(r, g, b);
    DrawFace(faces[i]);
  }
  glEnable(GL_LIGHTING);
}



void R3Mesh::
DrawVertex(R3MeshVertex *v) const
{
  // Draw box around vertex 
  RNScalar d = 0.001 * BBox().LongestAxisLength();
  R3Sphere(v->position, d).Draw();
}



void R3Mesh::
DrawEdge(R3MeshEdge *e) const
{
  // Draw edge
  R3BeginLine();
  R3LoadPoint(e->vertex[0]->position);
  R3LoadPoint(e->vertex[1]->position);
  R3EndLine();
}



void R3Mesh::
DrawFace(R3MeshFace *f) const
{
  // Draw polygon
  R3BeginPolygon();
  R3LoadNormal(FaceNormal(f));
  R3LoadPoint(f->vertex[0]->position);
  R3LoadPoint(f->vertex[1]->position);
  R3LoadPoint(f->vertex[2]->position);
  R3EndPolygon();
}



////////////////////////////////////////////////////////////////////////
// INTERSECTION FUNCTIONS
////////////////////////////////////////////////////////////////////////

R3MeshType R3Mesh::
Intersection(const R3Ray& ray, R3MeshIntersection *intersection) const
{
  // Initialize pick variables
  R3MeshType type = R3_MESH_NULL_TYPE;
  if (intersection) {
    intersection->type = R3_MESH_NULL_TYPE;
    intersection->vertex = NULL;
    intersection->edge = NULL;
    intersection->face = NULL;
    intersection->t = RN_INFINITY;
  }

  // Check bounding box for intersection 
  if (R3Intersects(ray, bbox)) {
    // Check each face to find closest intersection
    RNScalar min_t = FLT_MAX;
    for (int i = 0; i < faces.NEntries(); i++) {
      // Get ith face
      R3MeshFace *f = faces[i];

      // Get intersection with face
      R3MeshIntersection face_intersection;
      if (Intersection(ray, f, &face_intersection)) {
        if (intersection) *intersection = face_intersection;
        type = face_intersection.type;
        min_t = face_intersection.t;
      }
    }
  }

  // Return intersection type
  return type;
}



R3MeshType R3Mesh::
Intersection(const R3Ray& ray, R3MeshFace *f, R3MeshIntersection *intersection) const
{
  // Initialize pick variables
  R3MeshType type = R3_MESH_NULL_TYPE;
  if (intersection) {
    intersection->type = R3_MESH_NULL_TYPE;
    intersection->vertex = NULL;
    intersection->edge = NULL;
    intersection->face = NULL;
    intersection->t = RN_INFINITY;
  }

  // Check if face intersects ray
  RNScalar t;
  R3Point p;
  if (R3Intersects(ray, FacePlane(f), &p, &t)) {
    // Check if face bbox contains p
    if (R3Contains(FaceBBox(f), p)) {
      // Compute interpolation parameters for intersection point (from Graphics Gems I, page 393)
      RNScalar a, b;
      RNDimension dim = FaceNormal(f).MaxDimension();
      RNDimension dim1 = (dim + 1) % 3;
      RNDimension dim2 = (dim + 2) % 3;
      R3Point& p0 = f->vertex[0]->position;
      R3Point& p1 = f->vertex[1]->position;
      R3Point& p2 = f->vertex[2]->position;
      RNScalar u0 = p[dim1] - p0[dim1];
      RNScalar v0 = p[dim2] - p0[dim2];
      RNScalar u1 = p1[dim1] - p0[dim1];
      RNScalar u2 = p2[dim1] - p0[dim1];
      RNScalar v1 = p1[dim2] - p0[dim2];
      RNScalar v2 = p2[dim2] - p0[dim2];
      if (RNIsZero(u1)) {
        if (RNIsZero(u2)) {
          a = RN_INFINITY;
          b = RN_INFINITY;
        }
        else {
          b = u0/u2;
          if (RNIsLess(b, 0.0) || RNIsGreater(b, 1.0) || RNIsZero(v1)) a = b = RN_INFINITY;
          else a = (v0 - b*v2) / v1;
        }
      }
      else {
        RNScalar denom = v2*u1 - u2*v1;
        if (RNIsZero(denom)) a = b = RN_INFINITY;
        else {
          b = (v0*u1 - u0*v1) / denom;
          if (RNIsLess(b, 0.0) || RNIsGreater(b, 1.0) || RNIsZero(u1)) a = b = RN_INFINITY;
          else a = (u0 - b*u2) / u1;
        }
      }

      // Check if intersection point is inside triangle
      if (RNIsPositiveOrZero(a, 0.001) && RNIsPositiveOrZero(b, 0.001) && RNIsLess(a+b, 1.0, 0.001)) {
        if (RNIsZero(a, 0.01)) {
          if (RNIsZero(b, 0.01)) {
            type = R3_MESH_VERTEX_TYPE;
            if (intersection) {
              intersection->type = type;
              intersection->point = p;
              intersection->vertex = f->vertex[0];
              intersection->edge = f->edge[0];
              intersection->face = f;
              intersection->t = t;
            }
          }
          else if (RNIsEqual(b, 1.0, 0.01)) {
            type = R3_MESH_VERTEX_TYPE;
            if (intersection) {
              intersection->type = type;
              intersection->point = p;
              intersection->vertex = f->vertex[2];
              intersection->edge = f->edge[2];
              intersection->face = f;
              intersection->t = t;
            }
          }
          else {
            type = R3_MESH_EDGE_TYPE;
            if (intersection) {
              intersection->type = type;
              intersection->point = p;
              intersection->vertex = NULL;
              intersection->edge = f->edge[2];
              intersection->face = f;
              intersection->t = t;
            }
          }
        }
        else if (RNIsEqual(a, 1.0, 0.01)) {
          type = R3_MESH_VERTEX_TYPE;
          if (intersection) {
            intersection->type = type;
            intersection->point = p;
            intersection->vertex = f->vertex[1];
            intersection->edge = f->edge[1];
            intersection->face = f;
            intersection->t = t;
          }
        }                      
        else {
          if (RNIsZero(b, 0.01)) {
            type = R3_MESH_EDGE_TYPE;
            if (intersection) {
              intersection->type = type;
              intersection->point = p;
              intersection->vertex = NULL;
              intersection->edge = f->edge[0];
              intersection->face = f;
              intersection->t = t;
            }
          }
          else if (RNIsEqual(a+b, 1.0, 0.01)) {
            type = R3_MESH_EDGE_TYPE;
            if (intersection) {
              intersection->type = type;
              intersection->point = p;
              intersection->vertex = NULL;
              intersection->edge = f->edge[1];
              intersection->face = f;
              intersection->t = t;
            }
          }
          else {
            type = R3_MESH_FACE_TYPE;
            if (intersection) {
              intersection->type = type;
              intersection->point = p;
              intersection->vertex = NULL;
              intersection->edge = NULL;
              intersection->face = f;
              intersection->t = t;
            }
          }
        }
      }
    }
  }

  // Return intersection type
  return type;
}



////////////////////////////////////////////////////////////////////////
// GEOMETRIC QUERY FUNCTIONS
////////////////////////////////////////////////////////////////////////

R3Point R3Mesh::
ClosestPointOnEdge(const R3MeshEdge *e, const R3Point& point) const
{
  // Return closest point on edge
  R3MeshVertex *v0 = VertexOnEdge(e, 0);
  R3MeshVertex *v1 = VertexOnEdge(e, 1);
  const R3Point& p0 = VertexPosition(v0);
  const R3Point& p1 = VertexPosition(v1);
  R3Vector edge_vector = p1 - p0;
  RNScalar edge_length = edge_vector.Length();
  if (edge_length == 0) return p0;
  edge_vector /= edge_length;
  R3Vector point_vector = point - p0;
  RNScalar t = edge_vector.Dot(point_vector);
  if (t <= 0) return p0;
  else if (t >= edge_length) return p1;
  else return p0 + t * edge_vector;
}



R3Point R3Mesh::
ClosestPointOnFace(const R3MeshFace *face, const R3Point& point) const
{
  // Project point point onto face plane
  const R3Plane& plane = FacePlane(face);
  const R3Vector& face_normal = plane.Normal();
  RNScalar plane_signed_distance = R3SignedDistance(plane, point);
  R3Point plane_point = point - plane_signed_distance * face_normal;

  // Check if point is outside each edge
  RNBoolean outside_face = FALSE;
  R3Point closest_edge_point = R3zero_point;
  RNScalar closest_edge_distance_squared = FLT_MAX;
  for (int i = 0; i < 3; i++) {
    R3MeshEdge *edge = EdgeOnFace(face, i);
    R3MeshVertex *v0 = VertexOnEdge(edge, face, RN_CW);
    R3MeshVertex *v1 = VertexOnEdge(edge, face, RN_CCW);
    R3Point p0 = v0->position;
    R3Point p1 = v1->position;
    R3Vector edge_vector = p1 - p0;
    edge_vector.Normalize();
    R3Vector edge_normal = face_normal % edge_vector;
    R3Plane edge_plane(p0, edge_normal);
    RNScalar b = R3SignedDistance(edge_plane, plane_point);
    if (b < 0) {
      outside_face = TRUE;
      R3Point edge_point = ClosestPointOnEdge(edge, point);
      RNScalar distance_squared = R3SquaredDistance(edge_point, point);
      if (distance_squared < closest_edge_distance_squared) {
        closest_edge_distance_squared = distance_squared;
        closest_edge_point = edge_point;
      }
    }
  }

  // Return closest point
  if (!outside_face) return plane_point;
  else return closest_edge_point;
}



R3Point R3Mesh::
RandomPointOnFace(const R3MeshFace *face) const
{
  // Seed random number generator
  static RNBoolean seed = 0;
  if (!seed) { seed = 1; RNSeedRandomScalar(); }

  // Get vertex positions
  R3MeshVertex *v0 = VertexOnFace(face, 0);
  R3MeshVertex *v1 = VertexOnFace(face, 1);
  R3MeshVertex *v2 = VertexOnFace(face, 2);
  const R3Point& p0 = VertexPosition(v0);
  const R3Point& p1 = VertexPosition(v1);
  const R3Point& p2 = VertexPosition(v2);


  // Return random point on face
  RNScalar r1 = sqrt(RNRandomScalar());
  RNScalar r2 = RNRandomScalar();
  R3Point p = p0 * (1.0 - r1) + p1 * r1 * (1.0 - r2) + p2 * r1 * r2;
  return p;
}



////////////////////////////////////////////////////////////////////////
// I/O FUNCTIONS
////////////////////////////////////////////////////////////////////////

int R3Mesh::
ReadFile(const char *filename)
{
  // Parse input filename extension
  const char *extension;
  if (!(extension = strrchr(filename, '.'))) {
    printf("Filename %s has no extension (e.g., .ply)\n", filename);
    return 0;
  }

  // Read file of appropriate type
  int nfaces = 0;
  if (!strncmp(extension, ".obj", 4)) 
    nfaces = ReadObjFile(filename);
  else if (!strncmp(extension, ".off", 4)) 
    nfaces = ReadOffFile(filename);
  else if (!strncmp(extension, ".ray", 4)) 
    nfaces = ReadRayFile(filename);
  else if (!strncmp(extension, ".ply", 4)) 
    nfaces = ReadPlyFile(filename);
  else if (!strncmp(extension, ".cat", 4)) 
    nfaces = ReadCattFile(filename);
  else if (!strncmp(extension, ".ifs", 4)) 
    nfaces = ReadIfsFile(filename);
  else if (!strncmp(extension, ".stl", 4)) 
    nfaces = ReadSTLFile(filename);
  else if (!strncmp(extension, ".wrl", 4)) 
    nfaces = ReadVRMLFile(filename);
  else {
    RNFail("Unable to read file %s (unrecognized extension: %s)\n", filename, extension);
    return 0;
  }

  // Set mesh name, if it doesn't already have one
  if (strlen(Name()) == 0) SetName(filename);

  // Return number of faces created
  return nfaces;
}



int R3Mesh::
ReadObjFile(const char *filename)
{
  // Open file
  FILE *fp;
  if (!(fp = fopen(filename, "r"))) {
    RNFail("Unable to open file %s", filename);
    return 0;
  }

  // Read body
  char buffer[1024];
  int line_count = 0;
  int triangle_count = 0;
  while (fgets(buffer, 1023, fp)) {
    // Increment line counter
    line_count++;

    // Skip white space
    char *bufferp = buffer;
    while (isspace(*bufferp)) bufferp++;

    // Skip blank lines and comments
    if (*bufferp == '#') continue;
    if (*bufferp == '\0') continue;

    // Get keyword
    char keyword[80];
    if (sscanf(bufferp, "%s", keyword) != 1) {
      RNFail("Syntax error on line %d in file %s", line_count, filename);
      return 0;
    }

    // Check keyword
    if (!strcmp(keyword, "v")) {
      // Read vertex coordinates
      double x, y, z;
      if (sscanf(bufferp, "%s%lf%lf%lf", keyword, &x, &y, &z) != 4) {
        RNFail("Syntax error on line %d in file %s", line_count, filename);
        return 0;
      }

      // Create vertex
      CreateVertex(R3Point(x, y, z));
    }
    else if (!strcmp(keyword, "f")) {
      // Read vertex indices
      char s1[128], s2[128], s3[128];
      if (sscanf(bufferp, "%s%s%s%s", keyword, s1, s2, s3) != 4) {
        RNFail("Syntax error on line %d in file %s", line_count, filename);
        return 0;
      }

      // Parse vertex indices
      int i1, i2, i3;
      char *p1 = strchr(s1, '/'); if (p1) *p1 = 0; i1 = atoi(s1);
      char *p2 = strchr(s2, '/'); if (p2) *p2 = 0; i2 = atoi(s2);
      char *p3 = strchr(s3, '/'); if (p3) *p3 = 0; i3 = atoi(s3);

      // Get vertices
      R3MeshVertex *v1 = vertices.Kth(i1-1);
      R3MeshVertex *v2 = vertices.Kth(i2-1);
      R3MeshVertex *v3 = vertices.Kth(i3-1);

      // Check vertices
      if ((v1 == v2) || (v2 == v3) || (v1 == v3)) continue;

      // Create face
      if (!CreateFace(v1, v2, v3)) {
        // Must have been degeneracy (e.g., three faces sharing an edge), create new vertices
        // R3MeshVertex *v1a = CreateVertex(VertexPosition(v1));
        // R3MeshVertex *v2a = CreateVertex(VertexPosition(v2));
        // R3MeshVertex *v3a = CreateVertex(VertexPosition(v3));
        // CreateFace(v1a, v2a, v3a);
      }

      // Increment triangle counter
      triangle_count++;
    }
  }

  // Close file
  fclose(fp);

  // Return number of faces created
  return triangle_count;
}



int R3Mesh::
ReadOffFile(const char *filename)
{
  // Open file
  FILE *fp;
  if (!(fp = fopen(filename, "r"))) {
    fprintf(stderr, "Unable to open file %s\n", filename);
    return 0;
  }

  // Read file
  int nverts = 0;
  int nfaces = 0;
  int nedges = 0;
  int line_count = 0;
  int vertex_count = 0;
  int face_count = 0;
  char buffer[1024];
  char header[64];
  while (fgets(buffer, 1023, fp)) {
    // Increment line counter
    line_count++;

    // Skip white space
    char *bufferp = buffer;
    while (isspace(*bufferp)) bufferp++;

    // Skip blank lines and comments
    if (*bufferp == '#') continue;
    if (*bufferp == '\0') continue;

    // Check section
    if (nverts == 0) {
      // Read header keyword
      if (strstr(bufferp, "OFF")) {
        // Check if counts are on first line
        int tmp;
        if (sscanf(bufferp, "%s%d%d%d", header, &tmp, &nfaces, &nedges) == 4) {
          nverts = tmp;
        }
      }
      else {
        // Read counts from second line
        if ((sscanf(bufferp, "%d%d%d", &nverts, &nfaces, &nedges) != 3) || (nverts == 0)) {
          RNFail("Syntax error reading header on line %d in file %s\n", line_count, filename);
          fclose(fp);
          return 0;
        }
      }
    }
    else if (vertex_count < nverts) {
      // Read vertex coordinates
      double x, y, z;
      if (sscanf(bufferp, "%lf%lf%lf", &x, &y, &z) != 3) {
        RNFail("Syntax error with vertex coordinates on line %d in file %s\n", line_count, filename);
        fclose(fp);
        return 0;
      }

      // Create vertex
      CreateVertex(R3Point(x, y, z));

      // Increment counter
      vertex_count++;
    }
    else if (face_count < nfaces) {
      // Read number of vertices in face 
      int face_nverts = 0;
      bufferp = strtok(bufferp, " \t");
      if (bufferp) face_nverts = atoi(bufferp);
      else {
        RNFail("Syntax error with face on line %d in file %s\n", line_count, filename);
        fclose(fp);
        return 0;
      }

      // Read vertex indices for face
      R3MeshVertex *v1 = NULL;
      R3MeshVertex *v2 = NULL;
      R3MeshVertex *v3 = NULL;
      for (int i = 0; i < face_nverts; i++) {
        bufferp = strtok(NULL, " \t");
        if (bufferp) {
          R3MeshVertex *v = Vertex(atoi(bufferp));
          if (!v1) v1 = v;
          else v3 = v;
        }
        else {
          RNFail("Syntax error with face on line %d in file %s\n", line_count, filename);
          fclose(fp);
          return 0;
        }

        // Create triangle
        if (v1 && v2 && v3 && (v1 != v2) && (v2 != v3) && (v1 != v3)) {
          if (!CreateFace(v1, v2, v3)) {
            // Must have been degeneracy (e.g., three faces sharing an edge), create new vertices
            // R3MeshVertex *v1a = CreateVertex(VertexPosition(v1));
            // R3MeshVertex *v2a = CreateVertex(VertexPosition(v2));
            // R3MeshVertex *v3a = CreateVertex(VertexPosition(v3));
            // CreateFace(v1a, v2a, v3a);  
          }
        }

        // Move to next triangle
        v2 = v3;
      }

      // Increment counter
      face_count++;
    }
    else {
      // Should never get here
      RNFail("Found extra text starting at line %d in file %s\n", line_count, filename);
      break;
    }
  }

  // Close file
  fclose(fp);

  // Return number of faces read
  return NFaces();
}



int R3Mesh::
ReadRayFile(const char *filename)
{
  // Open file
  FILE *fp;
  if (!(fp = fopen(filename, "r"))) {
    RNFail("Unable to open file %s", filename);
    return 0;
  }

  // Read body
  char cmd[128];
  int triangle_count = 0;
  int command_number = 1;
  while (fscanf(fp, "%s", cmd) == 1) {
    if (!strcmp(cmd, "#vertex")) {
      // Read data
      double px, py, pz;
      double nx, ny, nz;
      double ts, tt;
      if (fscanf(fp, "%lf%lf%lf%lf%lf%lf%lf%lf", &px, &py, &pz, &nx, &ny, &nz, &ts, &tt) != 8) {
        RNFail("Unable to read vertex at command %d in file %s", command_number, filename);
        return 0;
      }

      // Create vertex
      R3Point point(px, py, pz);
      R3Vector normal(nx, ny, nz);
      if (normal.IsZero()) CreateVertex(point);
      else CreateVertex(point, normal);
    }
    else if (!strcmp(cmd, "#shape_triangle")) {
      // Read data
      int m;
      int i1, i2, i3;
      if (fscanf(fp, "%d%d%d%d", &m, &i1, &i2, &i3) != 4) {
        RNFail("Unable to read triangle at command %d in file %s", command_number, filename);
        return 0;
      }

      // Get vertices
      R3MeshVertex *v1 = vertices.Kth(i1);
      R3MeshVertex *v2 = vertices.Kth(i2);
      R3MeshVertex *v3 = vertices.Kth(i3);

      // Check vertices
      if ((v1 == v2) || (v2 == v3) || (v1 == v3)) continue;

      // Create face
      R3MeshFace *face = CreateFace(v1, v2, v3);
      if (!face) {
        // Must have been degeneracy (e.g., three faces sharing an edge), create new vertices
        // R3MeshVertex *v1a = CreateVertex(VertexPosition(v1));
        // R3MeshVertex *v2a = CreateVertex(VertexPosition(v2));
        // R3MeshVertex *v3a = CreateVertex(VertexPosition(v3));
        // face = CreateFace(v1a, v2a, v3a);
      }

      // Set face material
      if (face) SetFaceMaterial(face, m);
      if (face) SetFaceSegment(face, m);

      // Increment triangle counter
      triangle_count++;
    }
	
    // Increment command number
    command_number++;
  }

  // Close file
  fclose(fp);

  // Return number of faces created
  return triangle_count;
}



int R3Mesh::
ReadPlyFile(const char *filename)
{
  FILE *fp;
  int i,j;
  PlyFile *ply;
  int nelems;
  PlyProperty **plist;
  char **elist;
  int file_type;
  int nprops;
  int num_elems;
  char *elem_name;
  float version;

  typedef struct PlyVertex {
    float x, y, z;
    float nx, ny, nz;
  } PlyVertex;

  typedef struct PlyFace {
    unsigned char nverts;
    int *verts;
    int material;
    int segment;
  } PlyFace;

  // List of property information for a vertex 
  static PlyProperty vert_props[] = { 
    {"x", PLY_FLOAT, PLY_FLOAT, offsetof(PlyVertex,x), 0, 0, 0, 0},
    {"y", PLY_FLOAT, PLY_FLOAT, offsetof(PlyVertex,y), 0, 0, 0, 0},
    {"z", PLY_FLOAT, PLY_FLOAT, offsetof(PlyVertex,z), 0, 0, 0, 0},
    {"nx", PLY_FLOAT, PLY_FLOAT, offsetof(PlyVertex,nx), 0, 0, 0, 0},
    {"ny", PLY_FLOAT, PLY_FLOAT, offsetof(PlyVertex,ny), 0, 0, 0, 0},
    {"nz", PLY_FLOAT, PLY_FLOAT, offsetof(PlyVertex,nz), 0, 0, 0, 0}
  };

  // List of property information for a vertex 
  static PlyProperty face_props[] = { 
    {"vertex_indices", PLY_INT, PLY_INT, offsetof(PlyFace,verts), 1, PLY_UCHAR, PLY_UCHAR, offsetof(PlyFace,nverts)},
    {"material_id", PLY_INT, PLY_INT, offsetof(PlyFace,material), 0, 0, 0, 0},
    {"segment_id", PLY_INT, PLY_INT, offsetof(PlyFace,segment), 0, 0, 0, 0}
  };

  // Open file 
  fp = fopen(filename, "rb");
  if (!fp) {
    RNFail("Unable to open file: %s", filename);
    return 0;
  }

  // Read PLY header
  ply = ply_read (fp, &nelems, &elist);
  if (!ply) {
    RNFail("Unable to read ply file: %s", filename);
    fclose(fp);
    return 0;
  }
  
  // Get header info
  ply_get_info (ply, &version, &file_type);

  // Read all elements
  for (i = 0; i < nelems; i++) {
    // Get the description of the element 
    elem_name = elist[i];
    plist = ply_get_element_description (ply, elem_name, &num_elems, &nprops);

    // Check element type
    if (equal_strings ("vertex", elem_name)) {
      // Allocate block of vertices
      vertex_block = new R3MeshVertex [num_elems];

      // Resize array of vertices
      vertices.Resize(num_elems);

      // set up for getting vertex elements 
      RNBoolean has_normals = 0;
      for (j = 0; j < nprops; j++) {
	if (equal_strings("x", plist[j]->name)) ply_get_property (ply, elem_name, &vert_props[0]);
	else if (equal_strings("y", plist[j]->name)) ply_get_property (ply, elem_name, &vert_props[1]);
	else if (equal_strings("z", plist[j]->name)) ply_get_property (ply, elem_name, &vert_props[2]);
	else if (equal_strings("nx", plist[j]->name)) ply_get_property (ply, elem_name, &vert_props[3]); 
	else if (equal_strings("ny", plist[j]->name)) ply_get_property (ply, elem_name, &vert_props[4]); 
	else if (equal_strings("nz", plist[j]->name)) ply_get_property (ply, elem_name, &vert_props[5]);
	if (equal_strings("nx", plist[j]->name)) has_normals = 1;
      }

      // grab all the vertex elements 
      for (j = 0; j < num_elems; j++) {
        // Read vertex into local struct
        PlyVertex plyvertex;
        ply_get_element(ply, (void *) &plyvertex);

        // Create mesh vertex
        R3Point position(plyvertex.x, plyvertex.y, plyvertex.z);
        R3MeshVertex *v = CreateVertex(position, &vertex_block[j]);
        if (has_normals) {
          R3Vector normal(plyvertex.nx, plyvertex.ny, plyvertex.nz);
          SetVertexNormal(v, normal);
        }
      }
    }
    else if (equal_strings ("face", elem_name)) {
      // Resize array of faces
      faces.Resize(num_elems);

      // set up for getting face elements 
      for (j = 0; j < nprops; j++) {
	if (equal_strings("vertex_indices", plist[j]->name)) ply_get_property (ply, elem_name, &face_props[0]);
	else if (equal_strings("material_id", plist[j]->name)) ply_get_property (ply, elem_name, &face_props[1]);
	else if (equal_strings("segment_id", plist[j]->name)) ply_get_property (ply, elem_name, &face_props[2]);
      }

      // grab all the face elements 
      for (j = 0; j < num_elems; j++) {
        // Read face into local struct
        PlyFace plyface;
        plyface.nverts = 0;
        plyface.verts = NULL;
        plyface.material = -1;
        plyface.segment = 0;
        ply_get_element(ply, (void *) &plyface);

        // Create mesh face(s)
        R3MeshVertex *v1 = vertices[plyface.verts[0]];
        for (int k = 2; k < plyface.nverts; k++) {
          // Get vertices
          R3MeshVertex *v2 = vertices[plyface.verts[k-1]];
          R3MeshVertex *v3 = vertices[plyface.verts[k]];

          // Check plyface
          assert(plyface.verts[0] >= 0);
          assert(plyface.verts[k-1] >= 0);
          assert(plyface.verts[k] >= 0);
          assert(plyface.verts[0] < vertices.NEntries());
          assert(plyface.verts[k-1] < vertices.NEntries());
          assert(plyface.verts[k] < vertices.NEntries());

          // Check vertices
          if ((v1 == v2) || (v2 == v3) || (v1 == v3)) continue;

          // Create face
          R3MeshFace *f = CreateFace(v1, v2, v3);
#if 0
          if (!f) {
            // Must have been degeneracy (e.g., three faces sharing an edge), create new vertices
            // Note: these vertices are allocated separately, and so they will not be deleted (memory leak)
            // R3MeshVertex *v1a = CreateVertex(VertexPosition(v1));
            // R3MeshVertex *v2a = CreateVertex(VertexPosition(v2));
            // R3MeshVertex *v3a = CreateVertex(VertexPosition(v3));
            // f = CreateFace(v1a, v2a, v3a);
          } 
#endif
          // Set material/segment
          if (f) SetFaceMaterial(f, plyface.material);
          if (f) SetFaceSegment(f, plyface.segment);
        }

        // Free face data allocated by ply ??? THIS MESSES UP WHEN OTHER DATA (SEGMENTS) ARE PRESENT ???
        if (plyface.verts) free(plyface.verts);
      }
    }
    else {
      ply_get_other_element (ply, elem_name, num_elems);
    }
  }

  // Close the file 
  ply_close (ply);

  // Return number of faces created
  return faces.NEntries();
}



int R3Mesh::
ReadCattFile(const char *filename)
{
  // Open file
  FILE *fp;
  if (!(fp = fopen(filename, "r"))) {
    RNFail("Unable to open file %s", filename);
    return 0;
  }

  // Read body
  char buffer[1024];
  int line_count = 0;
  RNBoolean corners = FALSE;
  RNBoolean planes = FALSE;
  while (fgets(buffer, 1023, fp)) {
    // Increment line counter
    line_count++;

    // Skip white space
    char *bufferp = buffer;
    while (isspace(*bufferp)) bufferp++;

    // Skip blank lines
    if (*bufferp == '\0') continue;

    // Get keyword
    char keyword[80];
    if (sscanf(bufferp, "%s", keyword) != 1) {
      RNFail("Syntax error on line %d in file %s", line_count, filename);
      return 0;
    }

    // Check keyword
    if (keyword[0] == '%') {
      corners = planes = FALSE;
      if (!strcmp(keyword, "%CORNERS")) corners = TRUE;
      else if (!strcmp(keyword, "%PLANES")) planes = TRUE;
      else if (!strcmp(keyword, "%EOF")) break;
      continue;
    }

    // Read data
    if (corners) {
      // Read vertex coordinates
      int id;
      double x, y, z;
      if (sscanf(bufferp, "%d%lf%lf%lf", &id, &x, &y, &z) != 4) {
        RNFail("Syntax error on line %d in file %s", line_count, filename);
        return 0;
      }

      // Create vertex
      CreateVertex(R3Point(x, y, z));
    }
    else if (planes) {
      // Read plane header
      int id;
      char buffer1[256];
      char buffer2[256];
      if ((sscanf(bufferp, "%d%s%s", &id, buffer1, buffer2) != 3) ||
          (strcmp(buffer1, "/")) || (strcmp(buffer2, "/RIGID"))) {
        RNFail("Syntax error on line %d in file %s", line_count, filename);
        return 0;
      }

      // Read vertices
      RNArray<R3MeshVertex *> vertices;
      if (fgets(buffer, 1023, fp)) {
        line_count++;
        bufferp = strtok(buffer, "\t ");
        while (bufferp) {
          int id = atoi(bufferp);
          if ((id <= 0) || (id > NVertices())) {
            RNFail("Bogus vertex index on line %d in file %s", line_count, filename);
            return 0;
          }
          R3MeshVertex *v = Vertex(id-1);
          assert(v);
          vertices.Insert(v);
          bufferp = strtok(NULL, "\t ");
        }
      }

      // Create face(s)
      for (int i = 2; i < vertices.NEntries(); i++) {
        if (vertices[0] == vertices[i-1]) continue;
        if (vertices[i-1] == vertices[i]) continue;
        if (vertices[0] == vertices[i]) continue;
        if (!CreateFace(vertices[0], vertices[i-1], vertices[i])) {
          // Must have been degeneracy (e.g., three faces sharing an edge), create new vertices
          // R3MeshVertex *v1a = CreateVertex(VertexPosition(vertices[0]));
          // R3MeshVertex *v2a = CreateVertex(VertexPosition(vertices[i-1]));
          // R3MeshVertex *v3a = CreateVertex(VertexPosition(vertices[i-2]));
          // CreateFace(v1a, v2a, v3a);
        }
      }
    }
  }
    
  // Close file
  fclose(fp);

  // Return number of faces
  return NFaces();
}    



static int 
ReadIfsString(FILE *fp, char *buffer, int maxlength)
{
  // Read length
  unsigned int length;
  if (fread(&length, sizeof(unsigned int), 1, fp) != 1) {
    RNFail("Unable to read string length");
    return -1;
  }

  // Read characters
  if ((int) length > maxlength) length = maxlength;
  if (fread(buffer, sizeof(unsigned char), length, fp) != length) {
    RNFail("Unable to read string characters");
    return -1;
  }

  // Return length of string
  return length;
}



int R3Mesh::
ReadIfsFile(const char *filename)
{
  char buffer[1024];

  // Open file
  FILE *fp;
  if (!(fp = fopen(filename, "rb"))) {
    fprintf(stderr, "Unable to open file %s\n", filename);
    return 0;
  }

  // Read magic string
  if (ReadIfsString(fp, buffer, 1024) < 0) {
    RNFail("Unable to read header of %s", filename);
    return 0;
  }
  if (strcmp(buffer, "IFS")) {
    RNFail("Bad magic string in file header of %s", filename);
    return 0;
  }

  // Read version number
  float version;
  if (fread(&version, sizeof(float), 1, fp) != 1) {
    RNFail("Unable to read version of %s", filename);
    return 0;
  }
  if (version != 1.0) {
    RNFail("Bad version number in file header of %s", filename);
    return 0;
  }

  // Read model name
  if (ReadIfsString(fp, buffer, 1024) < 0) {
    RNFail("Unable to read model name of %s", filename);
    return 0;
  }

  // Read vertex header
  if (ReadIfsString(fp, buffer, 1024) < 0) {
    RNFail("Unable to read vertex header of %s", filename);
    return 0;
  }
  if (strcmp(buffer, "VERTICES")) {
    RNFail("Bad vertex header in %s", filename);
    return 0;
  }

  // Read number of vertices
  unsigned int nverts;
  if (fread(&nverts, sizeof(unsigned int), 1, fp) != 1) {
    RNFail("Unable to read number of vertices in %s", filename);
    return 0;
  }

  // Allocate block of vertices
  vertex_block = new R3MeshVertex [nverts];
  
  // Resize array of vertices
  vertices.Resize(nverts);

  // Read vertices
  for (unsigned int i = 0; i < nverts; i++) {
    float p[3];
    if (fread(p, sizeof(float), 3, fp) != 3) {
      RNFail("Unable to read vertex %d in %s", i, filename);
      return 0;
    }

    // Create mesh vertex
    if (!CreateVertex(R3Point(p[0], p[1], p[2]), &vertex_block[i])) {
      RNFail("Unable to create vertex %d in %s", i, filename);
      return 0;
    }
  }

  // Read triangle header
  if (ReadIfsString(fp, buffer, 1024) < 0) {
    RNFail("Unable to read vertex header of %s", filename);
    return 0;
  }
  if (strcmp(buffer, "TRIANGLES")) {
    RNFail("Bad triangle header in %s", filename);
    return 0;
  }

  // Read number of faces
  unsigned int nfaces;
  if (fread(&nfaces, sizeof(unsigned int), 1, fp) != 1) {
    RNFail("Unable to read number of faces in %s", filename);
    return 0;
  }

  // Allocate block of faces
  face_block = new R3MeshFace [nfaces];

  // Resize array of faces
  faces.Resize(nfaces);

  // Read triangles
  for (unsigned int i = 0; i < nfaces; i++) {
    int v[3];
    if (fread(v, sizeof(unsigned int), 3, fp) != 3) {
      RNFail("Unable to read vertex index in triangle %d of %s", i, filename);
      return 0;
    }

    // Get vertices
    R3MeshVertex *v0 = vertices[v[0]];
    R3MeshVertex *v1 = vertices[v[1]];
    R3MeshVertex *v2 = vertices[v[2]];

    // Check vertices
    if ((v0 == v1) || (v1 == v2) || (v0 == v2)) continue;

    // Create mesh face
    if (!CreateFace(v0, v1, v2, &face_block[i])) {
      // Must have been degeneracy (e.g., three faces sharing an edge), create new vertices
      // R3MeshVertex *v0a = CreateVertex(VertexPosition(v0));
      // R3MeshVertex *v1a = CreateVertex(VertexPosition(v1));
      // R3MeshVertex *v2a = CreateVertex(VertexPosition(v2));
      // CreateFace(v0a, v1a, v2a);
    }
  }

  // Close file
  fclose(fp);

  // Return number of faces read
  return NFaces();
}



int R3Mesh::
ReadSTLFile(const char *filename)
{
  // Open file
  FILE *fp;
  if (!(fp = fopen(filename, "r"))) {
    RNFail("Unable to open file %s", filename);
    return 0;
  }

  // Read body
  int line_number = 0;
  char buffer[1024], cmd[1024];
  RNArray<R3MeshVertex *> vertices;
  while (fgets(buffer, 1024, fp)) {
    line_number++;
    if (sscanf(buffer, "%s", cmd) != 1) continue;
    if (!strcmp(cmd, "vertex")) {
      RNCoord x, y, z;
      if (sscanf(buffer, "%s%lf%lf%lf", cmd, &x, &y, &z) != 4) {
        RNFail("Error in vertex of STL file %s on line %d", filename, line_number);
        return 0;
      }

      // Make vertex
      const R3Point position(x, y, z);
      R3MeshVertex *vertex = CreateVertex(position);
      vertices.Insert(vertex);
    }
    else if (!strcmp(cmd, "outer")) {
      // Just checking
      assert(vertices.IsEmpty());
    }
    else if (!strcmp(cmd, "endloop")) {
      // Create face(s)
      for (int i = 2; i < vertices.NEntries(); i++) {
        if (vertices[0] == vertices[i-1]) continue;
        if (vertices[i-1] == vertices[i]) continue;
        if (vertices[0] == vertices[i]) continue;
        if (!CreateFace(vertices[0], vertices[i-1], vertices[i])) {
          // Must have been degeneracy (e.g., three faces sharing an edge), create new vertices
          // R3MeshVertex *v1a = CreateVertex(VertexPosition(vertices[0]));
          // R3MeshVertex *v2a = CreateVertex(VertexPosition(vertices[i-1]));
          // R3MeshVertex *v3a = CreateVertex(VertexPosition(vertices[i-2]));
          // CreateFace(v1a, v2a, v3a);
        }
        vertices.Empty();
      }
    }
  }

  // Close file
  fclose(fp);

  // Return number of faces created
  return NFaces();
}



int R3Mesh::
ReadVRMLFile(const char *filename)
{
  // Open file
  FILE *fp;
  if (!(fp = fopen(filename, "r"))) {
    fprintf(stderr, "Unable to open file %s\n", filename);
    return 0;
  }

  // Read file
  char buffer[1024];
  int line_count = 0;
  RNBoolean coordinate3_active = FALSE;
  RNBoolean coordinate3_point_active = FALSE;
  RNBoolean indexedfaceset_active = FALSE;
  RNBoolean indexedfaceset_coordindex_active = FALSE;
  RNArray<R3MeshVertex *> vertices;
  while (fgets(buffer, 1023, fp)) {
    // Increment line counter
    line_count++;

    // Skip white space
    char *bufferp = buffer;
    while (isspace(*bufferp)) bufferp++;

    // Skip blank lines and comments
    if (*bufferp == '#') continue;
    if (*bufferp == '\0') continue;

    // Get first token
    bufferp = strtok(bufferp, " ,");
    if (!bufferp) break;

    // Check node being parsed
    if (coordinate3_point_active) {
      if (*bufferp == ']') {
        coordinate3_point_active = FALSE;
      } 
      else {
        do {
          if (*bufferp && !isspace(*bufferp)) {
            // Read next coordinate
            static int coordinate_index = 0;
            static RNScalar coordinates[3];
            coordinates[coordinate_index] = atof(bufferp);
            coordinate_index++;

            // Create vertex if have three coordinates
            if (coordinate_index == 3) {
              R3Point position(coordinates[0], coordinates[1], coordinates[2]);
              R3MeshVertex *vertex = CreateVertex(position);
              vertices.Insert(vertex);
              coordinate_index = 0;
            }
          }
          bufferp = strtok(NULL, " ,");
        } while (bufferp);
      }
    }
    else if (indexedfaceset_coordindex_active) {
      if (*bufferp == ']') {
        indexedfaceset_active = FALSE;
        indexedfaceset_coordindex_active = FALSE;
      } 
      else {
        do {
          // Read next coordinate index
          if (*bufferp && !isspace(*bufferp)) {
            static RNArray<R3MeshVertex *> face_vertices;
            int vertex_index = atoi(bufferp);
            if (vertex_index >= 0) {
              R3MeshVertex *vertex = vertices[vertex_index];
              face_vertices.Insert(vertex);
            }
            else {
              // Create face(s)
              R3MeshVertex *v1 = face_vertices[0];
              for (int k = 2; k < face_vertices.NEntries(); k++) {
                // Get vertices
                R3MeshVertex *v2 = face_vertices[k-1];
                R3MeshVertex *v3 = face_vertices[k];

                // Check vertices
                if ((v1 == v2) || (v2 == v3) || (v1 == v3)) continue;
 
                // Create face
                if (!CreateFace(v1, v2, v3)) {
                  // Must have been degeneracy (e.g., three faces sharing an edge), create new vertices
                  // Note: these vertices are allocated separately, and so they will not be deleted (memory leak)
                  // R3MeshVertex *v1a = CreateVertex(VertexPosition(v1));
                  // R3MeshVertex *v2a = CreateVertex(VertexPosition(v2));
                  // R3MeshVertex *v3a = CreateVertex(VertexPosition(v3));
                  // CreateFace(v1a, v2a, v3a);
                }
              }
              face_vertices.Empty();
            }
          }
          bufferp = strtok(NULL, " ,");
        } while (bufferp);
      }
    }
    else {
      if (!strcmp(bufferp, "Coordinate3")) coordinate3_active = TRUE;
      else if (!strcmp(bufferp, "IndexedFaceSet")) indexedfaceset_active = TRUE;
      else if ((coordinate3_active) && !strcmp(bufferp, "point")) coordinate3_point_active = TRUE;
      else if ((indexedfaceset_active) && !strcmp(bufferp, "coordIndex")) indexedfaceset_coordindex_active = TRUE;
    }
  }

  // Close file
  fclose(fp);

  // Return number of faces read
  return NFaces();
}



int R3Mesh::
WriteFile(const char *filename)
{
  // Parse input filename extension
  const char *extension;
  if (!(extension = strrchr(filename, '.'))) {
    printf("Filename %s has no extension (e.g., .ply)", filename);
    return 0;
  }

  // Write file of appropriate type
  if (!strncmp(extension, ".ray", 4)) 
    return WriteRayFile(filename);
  else if (!strncmp(extension, ".ply", 4)) 
    return WritePlyFile(filename);
  else if (!strncmp(extension, ".obj", 4)) 
    return WriteObjFile(filename);
  else if (!strncmp(extension, ".off", 4)) 
    return WriteOffFile(filename);
  else if (!strncmp(extension, ".cat", 4)) 
    return WriteCattFile(filename);
  else if (!strncmp(extension, ".ifs", 4)) 
    return WriteIfsFile(filename);
  else if (!strncmp(extension, ".stl", 4)) 
    return WriteSTLFile(filename);
  else {
    RNFail("Unable to write file %s (unrecognized extension: %s)", filename, extension);
    return 0;
  }
}



int R3Mesh::
WriteRayFile(const char *filename)
{
  // Open file
  FILE *fp;
  if (!(fp = fopen(filename, "w"))) {
    RNFail("Unable to open file %s", filename);
    return 0;
  }

  // Write vertices
  for (int i = 0; i < NVertices(); i++) {
    R3MeshVertex *vertex = Vertex(i);
    const R3Point& p = VertexPosition(vertex);
    const R3Vector& n = VertexNormal(vertex);
    fprintf(fp, "#vertex %g %g %g %g %g %g 0 0\n", p.X(), p.Y(), p.Z(), n.X(), n.Y(), n.Z());
  }

  // Write Faces
  for (int i = 0; i < NFaces(); i++) {
    R3MeshFace *face = Face(i);
    R3MeshVertex *v0 = VertexOnFace(face, 0);
    R3MeshVertex *v1 = VertexOnFace(face, 1);
    R3MeshVertex *v2 = VertexOnFace(face, 2);
    int m = FaceMaterial(face);
    fprintf(fp, "#shape_triangle %d %d %d %d\n", m, v0->id, v1->id, v2->id);
  }

  // Close file
  fclose(fp);

  // Return number of faces written
  return NFaces();
}



int R3Mesh::
WritePlyFile(const char *filename)
{
  typedef struct PlyVertex {
    float x, y, z;
  } PlyVertex;

  typedef struct PlyFace {
    unsigned char nverts;
    int *verts;
    int material;
    int segment;
  } PlyFace;

  // Element names
  char *elem_names[] = { "vertex", "face" };

  // List of property information for a vertex 
  static PlyProperty vert_props[] = { 
    {"x", PLY_FLOAT, PLY_FLOAT, offsetof(PlyVertex,x), 0, 0, 0, 0},
    {"y", PLY_FLOAT, PLY_FLOAT, offsetof(PlyVertex,y), 0, 0, 0, 0},
    {"z", PLY_FLOAT, PLY_FLOAT, offsetof(PlyVertex,z), 0, 0, 0, 0},
  };

  // List of property information for a vertex 
  static PlyProperty face_props[] = { 
    {"vertex_indices", PLY_INT, PLY_INT, offsetof(PlyFace,verts), 1, PLY_UCHAR, PLY_UCHAR, offsetof(PlyFace,nverts)},
    {"material_id", PLY_INT, PLY_INT, offsetof(PlyFace,segment), 0, 0, 0, 0},
    {"segment_id", PLY_INT, PLY_INT, offsetof(PlyFace,segment), 0, 0, 0, 0}
  };

  // Open ply file
  float version;
  PlyFile *ply = ply_open_for_writing((char *) filename, 2, elem_names, PLY_ASCII, &version);
  if (!ply) return -1;

  // Describe vertex properties
  ply_element_count(ply, "vertex", NVertices());
  ply_describe_property(ply, "vertex", &vert_props[0]);
  ply_describe_property(ply, "vertex", &vert_props[1]);
  ply_describe_property(ply, "vertex", &vert_props[2]);

  // Describe face properties
  ply_element_count(ply, "face", NFaces());
  ply_describe_property(ply, "face", &face_props[0]);
  ply_describe_property(ply, "face", &face_props[1]);
  ply_describe_property(ply, "face", &face_props[2]);

  // Complete header
  ply_header_complete(ply);

  // Write vertices
  ply_put_element_setup(ply, "vertex");
  for (int i = 0; i < NVertices(); i++) {
    R3MeshVertex *v = Vertex(i);
    const R3Point& p = VertexPosition(v);
    PlyVertex ply_vertex;
    ply_vertex.x = p.X();
    ply_vertex.y = p.Y();
    ply_vertex.z = p.Z();
    ply_put_element(ply, (void *) &ply_vertex);
  }

  // Write faces
  ply_put_element_setup(ply, "face");
  for (int i = 0; i < NFaces(); i++) {
    R3MeshFace *f = Face(i);
    static int verts[3];
    static PlyFace ply_face = { 3, verts, 0 };
    ply_face.verts[0] = VertexID(VertexOnFace(f, 0));
    ply_face.verts[1] = VertexID(VertexOnFace(f, 1));
    ply_face.verts[2] = VertexID(VertexOnFace(f, 2));
    ply_face.material = FaceMaterial(f);
    ply_face.segment = FaceSegment(f);
    ply_put_element(ply, (void *) &ply_face);
  }

  // Close the file 
  ply_close(ply);

  // Return number of faces written
  return NFaces();
}



int R3Mesh::
WriteObjFile(const char *filename)
{
  // Open file
  FILE *fp;
  if (!(fp = fopen(filename, "w"))) {
    RNFail("Unable to open file %s", filename);
    return 0;
  }

  // Write vertices
  for (int i = 0; i < NVertices(); i++) {
    R3MeshVertex *vertex = Vertex(i);
    const R3Point& p = VertexPosition(vertex);
    fprintf(fp, "v %g %g %g\n", p.X(), p.Y(), p.Z());
  }

  // Write Faces
  for (int i = 0; i < NFaces(); i++) {
    R3MeshFace *face = Face(i);
    R3MeshVertex *v0 = VertexOnFace(face, 0);
    R3MeshVertex *v1 = VertexOnFace(face, 1);
    R3MeshVertex *v2 = VertexOnFace(face, 2);
    fprintf(fp, "f %d %d %d\n", v0->id + 1, v1->id + 1, v2->id + 1);
  }

  // Close file
  fclose(fp);

  // Return number of faces written
  return NFaces();
}



int R3Mesh::
WriteOffFile(const char *filename)
{
  // Open file
  FILE *fp;
  if (!(fp = fopen(filename, "w"))) {
    RNFail("Unable to open file %s", filename);
    return 0;
  }

  // Write header
  fprintf(fp, "OFF\n");
  fprintf(fp, "%d %d %d\n", NVertices(), NFaces(), NEdges());

  // Write vertices
  for (int i = 0; i < NVertices(); i++) {
    R3MeshVertex *vertex = Vertex(i);
    const R3Point& p = VertexPosition(vertex);
    fprintf(fp, "%g %g %g\n", p.X(), p.Y(), p.Z());
  }

  // Write Faces
  for (int i = 0; i < NFaces(); i++) {
    R3MeshFace *face = Face(i);
    R3MeshVertex *v0 = VertexOnFace(face, 0);
    R3MeshVertex *v1 = VertexOnFace(face, 1);
    R3MeshVertex *v2 = VertexOnFace(face, 2);
    fprintf(fp, "3 %d %d %d\n", v0->id, v1->id, v2->id);
  }

  // Close file
  fclose(fp);

  // Return number of faces written
  return NFaces();
}



int R3Mesh::
WriteCattFile(const char *filename)
{
  // Open file
  FILE *fp;
  if (!(fp = fopen(filename, "w"))) {
    RNFail("Unable to open file %s", filename);
    return 0;
  }

  // Write vertex header
  fprintf(fp, "%%CORNERS\n\n");

  // Write vertices
  for (int i = 0; i < NVertices(); i++) {
    R3MeshVertex *vertex = Vertex(i);
    int id = VertexID(vertex);
    const R3Point& p = VertexPosition(vertex);
    fprintf(fp, "%d %g %g %g\n", id+1, p.X(), p.Y(), p.Z());
  }

  // Write face header
  fprintf(fp, "\n%%PLANES\n\n");

  // Write Faces
  for (int i = 0; i < NFaces(); i++) {
    R3MeshFace *face = Face(i);
    R3MeshVertex *v0 = VertexOnFace(face, 0);
    R3MeshVertex *v1 = VertexOnFace(face, 1);
    R3MeshVertex *v2 = VertexOnFace(face, 2);
    fprintf(fp, "%d / /RIGID\n%d %d %d\n\n", i, VertexID(v0) + 1, VertexID(v1) + 1, VertexID(v2) + 1);
  }

  // Write trailer
  fprintf(fp, "%%EOF\n");

  // Close file
  fclose(fp);

  // Return number of faces written
  return NFaces();
}



static int 
WriteIfsString(FILE *fp, char *buffer)
{
  // Write length
  unsigned int length = strlen(buffer) + 1;
  if (fwrite(&length, sizeof(unsigned int), 1, fp) != 1) {
    RNFail("Unable to write string length");
    return -1;
  }

  // Write characters
  if (fwrite(buffer, sizeof(unsigned char), length, fp) != length) {
    RNFail("Unable to write string characters");
    return -1;
  }

  // Return length of string
  return length;
}



int R3Mesh::
WriteIfsFile(const char *filename)
{
  float version = 1.0;
  unsigned int nverts = NVertices();
  unsigned int nfaces = NFaces();

  // Open file
  FILE *fp;
  if (!(fp = fopen(filename, "wb"))) {
    RNFail("Unable to open file %s", filename);
    return 0;
  }

  // Write header
  WriteIfsString(fp, "IFS");
  fwrite(&version, sizeof(float), 1, fp);
  WriteIfsString(fp, "filname");

  // Write vertices
  WriteIfsString(fp, "VERTICES");
  fwrite(&nverts, sizeof(unsigned int), 1, fp);
  for (unsigned int i = 0; i < nverts; i++) {
    R3MeshVertex *vertex = Vertex(i);
    const R3Point& position = VertexPosition(vertex);
    float p[3];
    p[0] = position.X();
    p[1] = position.Y();
    p[2] = position.Z();
    fwrite(&p, sizeof(float), 3, fp);
  }

  // Write faces
  WriteIfsString(fp, "TRIANGLES");
  fwrite(&nfaces, sizeof(unsigned int), 1, fp);
  for (int i = 0; i < NFaces(); i++) {
    R3MeshFace *face = Face(i);
    R3MeshVertex *v0 = VertexOnFace(face, 0);
    R3MeshVertex *v1 = VertexOnFace(face, 1);
    R3MeshVertex *v2 = VertexOnFace(face, 2);
    unsigned int v[3];
    v[0] = v0->id;
    v[1] = v1->id;
    v[2] = v2->id;
    fwrite(&v, sizeof(unsigned int), 3, fp);
  }

  // Close file
  fclose(fp);

  // Return number of faces written
  return NFaces();
}



int R3Mesh::
WriteSTLFile(const char *filename)
{
  // Open file
  FILE *fp;
  if (!(fp = fopen(filename, "w"))) {
    RNFail("Unable to open file %s", filename);
    return 0;
  }

  // Write header
  fprintf(fp, "solid %s\n", filename);

  // Write Faces
  for (int i = 0; i < NFaces(); i++) {
    R3MeshFace *face = Face(i);
    const R3Vector& n = FaceNormal(face);
    fprintf(fp, "facet normal %g %g %g\n", n[0], n[1], n[2]);
    fprintf(fp, "  outer loop\n");
    for (int j = 0; j < 3; j++) {
      R3MeshVertex *vertex = VertexOnFace(face, j);
      const R3Point& p = VertexPosition(vertex);
      fprintf(fp, "   vertex %g %g %g\n", p[0], p[1], p[2]);
    }
    fprintf(fp, "  endloop\n");
    fprintf(fp, "endfacet\n");
  }

  // Write trailer
  fprintf(fp, "endsolid\n");

  // Close file
  fclose(fp);

  // Return number of faces written
  return NFaces();
}



////////////////////////////////////////////////////////////////////////
// USEFUL DEBUG FUNCTIONS
////////////////////////////////////////////////////////////////////////

RNBoolean R3Mesh::
IsValid(R3MeshVertex *v) const
{
#ifndef NDEBUG
  // Check if vertex is on mesh
  assert(IsVertexOnMesh(v));

  // Check each vertex-edge and vertex-face relation
  for (int j = 0; j < VertexValence(v); j++) {
    R3MeshEdge *e = EdgeOnVertex(v, j);
    assert(IsVertexOnEdge(v, e));
    assert((!e->face[0]) || IsVertexOnFace(v, e->face[0]));
    assert((!e->face[1]) || IsVertexOnFace(v, e->face[1]));
  }
#endif

  // Return OK status
  return TRUE;
}



RNBoolean R3Mesh::
IsValid(R3MeshEdge *e) const
{
#ifndef NDEBUG
  // Check if edge is on mesh
  assert(IsEdgeOnMesh(e));

  // Check vertices
  assert(e->vertex[0]);
  assert(e->vertex[1]);
  assert(e->vertex[0] != e->vertex[1]);

  // Check each edge-vertex relation
  for (int j = 0; j < 2; j++) {
    R3MeshVertex *v = e->vertex[j];
    assert(v && v->edges.FindEntry(e));
  }

  // Check each edge-face relation
  for (int j = 0; j < 2; j++) {
    R3MeshFace *f = e->face[j];
    assert(!f || (f->edge[0] == e) || (f->edge[1] == e) || (f->edge[2] == e));
  }
#endif

  // Return OK status
  return TRUE;
}



RNBoolean R3Mesh::
IsValid(R3MeshFace *f) const
{
#ifndef NDEBUG
  // Check if face is on mesh
  assert(IsFaceOnMesh(f));

  // Check vertices
  assert(f->vertex[0]);
  assert(f->vertex[1]);
  assert(f->vertex[1]);
  assert(f->vertex[0] != f->vertex[1]);
  assert(f->vertex[1] != f->vertex[2]);
  assert(f->vertex[0] != f->vertex[2]);

  // Check edges
  assert(f->edge[0]);
  assert(f->edge[1]);
  assert(f->edge[1]);
  assert(f->edge[0] != f->edge[1]);
  assert(f->edge[1] != f->edge[2]);
  assert(f->edge[0] != f->edge[2]);

  // Check each face-vertex and face-edge relation
  for (int j = 0; j < 3; j++) {
    R3MeshVertex *v = f->vertex[j];
    R3MeshEdge *e = f->edge[j];
    assert(v && ((e->vertex[0] == v) || (e->vertex[1] == v)));
    assert(e && ((e->face[0] == f) || (e->face[1] == f)));
    assert(v == VertexOnFace(f, e, RN_CW));
    assert(e == EdgeOnFace(f, v, RN_CCW));
  }
#endif

  // Return OK status
  return TRUE;
}



RNBoolean R3Mesh::
IsValid(void) const
{
#ifndef NDEBUG
  // Check each vertex, edge, and face
  for (int i = 0; i < NVertices(); i++) assert(IsValid(Vertex(i)));
  for (int i = 0; i < NEdges(); i++) assert(IsValid(Edge(i)));
  for (int i = 0; i < NFaces(); i++) assert(IsValid(Face(i)));
#endif

  // Return success
  return TRUE;
}



////////////////////////////////////////////////////////////////////////
// INTERNAL UPDATE FUNCTIONS
////////////////////////////////////////////////////////////////////////

void R3Mesh::
UpdateVertexNormal(R3MeshVertex *v) const
{
  // Average face normals
  v->normal = R3zero_vector;
  for (int i = 0; i < v->edges.NEntries(); i++) {
    R3MeshEdge *e = v->edges[i];
    if (e->vertex[0] == v) {
      if (e->face[0]) 
        v->normal += FaceNormal(e->face[0]);
    }
    else {
      if (e->face[1]) 
        v->normal += FaceNormal(e->face[1]);
    }
  }
  v->normal.Normalize();

  // Update flags
  v->flags.Add(R3_MESH_VERTEX_NORMAL_UPTODATE);
}



void R3Mesh::
UpdateEdgeLength(R3MeshEdge *e) const
{
  // Reset length
  e->length = R3Distance(e->vertex[0]->position, e->vertex[1]->position);

  // Update flags
  e->flags.Add(R3_MESH_EDGE_LENGTH_UPTODATE);
}



void R3Mesh::
UpdateFacePlane(R3MeshFace *f) const
{
  // Reset plane 
  f->plane = R3Plane(f->vertex[0]->position, f->vertex[1]->position, f->vertex[2]->position);

  // Update flags
  f->flags.Add(R3_MESH_FACE_PLANE_UPTODATE);
}



void R3Mesh::
UpdateFaceBBox(R3MeshFace *f) const
{
  // Update face bbox
  f->bbox = R3null_box;
  f->bbox.Union(f->vertex[0]->position);
  f->bbox.Union(f->vertex[1]->position);
  f->bbox.Union(f->vertex[2]->position);

  // Update flags
  f->flags.Add(R3_MESH_FACE_BBOX_UPTODATE);
}



void R3Mesh::
UpdateFaceRefs(R3MeshFace *f,
               R3MeshVertex *v1, R3MeshVertex *v2, R3MeshVertex *v3,
               R3MeshEdge *e1, R3MeshEdge *e2, R3MeshEdge *e3)
{
  // Update face-vertex relations
  f->vertex[0] = v1;
  f->vertex[1] = v2;
  f->vertex[2] = v3;

  // Update face-edge relations
  f->edge[0] = e1;
  f->edge[1] = e2;
  f->edge[2] = e3;

  // Update edge-face relations
  if (e1->vertex[0] == v1) e1->face[0] = f;
  else { assert(e1->vertex[1] == v1); e1->face[1] = f; }
  if (e2->vertex[0] == v2) e2->face[0] = f;
  else { assert(e2->vertex[1] == v2); e2->face[1] = f; }
  if (e3->vertex[0] == v3) e3->face[0] = f;
  else { assert(e3->vertex[1] == v3); e3->face[1] = f; }

  // Invalidate face
  f->flags.Remove(R3_MESH_FACE_PLANE_UPTODATE | R3_MESH_FACE_BBOX_UPTODATE);
}
 
   

////////////////////////////////////////////////////////////////////////
// CONSTRUCTORS FOR VERTEX, EDGE, FACE
////////////////////////////////////////////////////////////////////////

R3MeshVertex::
R3MeshVertex(void) 
  : position(0.0, 0.0, 0.0),
    normal(0.0, 0.0, 0.0),
    id(-1),
    flags(0),
    value(0.0),
    mark(0),
    data(NULL)
{
}



R3MeshEdge::
R3MeshEdge(void) 
  : length(0),
    id(-1),
    flags(0),
    value(0.0),
    mark(0),
    data(NULL)
{
  // Initialize edge fields
  vertex[0] = vertex[1] = NULL;
  face[0] = face[1] = NULL;
}



R3MeshFace::
R3MeshFace(void) 
  : plane(0.0, 0.0, 0.0, 0.0),
    bbox(1.0, 1.0, 1.0, -1.0, -1.0, -1.0),
    material(-1),
    segment(0),
    id(-1),
    flags(0),
    value(0.0),
    mark(0),
    data(NULL)
{
  // Initialize face fields
  vertex[0] = vertex[1] = vertex[2] = NULL;
  edge[0] = edge[1] = edge[2] = NULL;
}





