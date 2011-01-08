/******************************************************************************
 * grid_creation.C -  Copyright (c) 2009 Thomas Funkhouser and Tony Capra
 *
 *  This file contains implements several approaches for creating
 *  ligand binding grids from a PDB structure.
 *  
 *  
 *  The details of the ConCavity algorithm are described in:
 *  
 *  Predicting Protein Ligand Binding Sites by Combining Evolutionary
 *  Sequence Conservation and 3D Structure Capra JA, Singh M, and
 *  Funkhouser TA.  Submitted.
 *  
 *  
 *  More information about the project can be found at the supporting web site:
 *  http://compbio.cs.princeton.edu/concavity/
 *  
 *  - Tony Capra (tonyc@cs.princeton.edu)
 *
 *
 * ----------------------------------------------------------------------
 *
 *  This file is part of ConCavity.
 *
 *  ConCavity is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  ConCavity is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with ConCavity.  If not, see <http://www.gnu.org/licenses/>.
 *
 *******************************************************************************/


#include "grid_creation.h"


// grid creation variables
// defined in concavity.C by program options
extern int print_verbose;

extern char *conservation_file;
extern char *conservation_type;

extern int grid_resolution[3];
extern int max_grid_resolution;
extern RNLength grid_spacing;
extern R3Point *world_center;
extern RNScalar world_radius;
extern RNScalar world_border;
extern RNScalar grid_threshold;


// Lennard-Jones parameters from AutoDock version 1.0 (H C N O S)
// http://www.scripps.edu/mb/olson/gmm/autodock/ad305/Using_AutoDock_305.20.html#32242

static RNScalar lennard_jones_c6[6][6] = {
  { 46.73839, 226.9102, 155.9833, 124.0492, PDB_UNKNOWN, 290.0756 }, // H
  { 226.9102, 1127.684, 783.3452, 633.7542, PDB_UNKNOWN, 1476.364 }, // C
  { 155.9833, 783.3452, 546.7653, 445.9175, PDB_UNKNOWN, 1036.932 }, // N
  { 124.0492, 633.7542, 445.9175, 368.6774, PDB_UNKNOWN, 854.6872 }, // O
  { PDB_UNKNOWN, PDB_UNKNOWN, PDB_UNKNOWN, PDB_UNKNOWN, PDB_UNKNOWN, PDB_UNKNOWN }, // P
  { 290.0756, 1476.364, 1036.932, 854.6872, PDB_UNKNOWN, 1982.756 } // S
};
 
static RNScalar lennard_jones_c12[6][6] = {
  { 1908.578, 88604.24, 39093.66, 38919.64, PDB_UNKNOWN, 126821.3 },
  { 88604.24, 1272653., 610155.1, 588883.8, PDB_UNKNOWN, 1569268. },
  { 39093.66, 610155.1, 266862.2, 249961.4, PDB_UNKNOWN, 721128.6 },
  { 38919.64, 588883.8, 249961.4, 230584.4, PDB_UNKNOWN, 675844.1 },
  { PDB_UNKNOWN, PDB_UNKNOWN, PDB_UNKNOWN, PDB_UNKNOWN, PDB_UNKNOWN, PDB_UNKNOWN }, // P
  { 126821.3, 1569268., 721128.6, 675844.1, PDB_UNKNOWN, 1813147. }
};
 

// *****************************************************************************


// *****************************************************************************
// LIGSITE CODE
// *****************************************************************************

R3Grid *
LigsiteGrid(PDBFile *file)
{
  // Start statistics
  RNTime start_time;
  start_time.Read();

  // Get array of atoms
  if (file->NModels() == 0) return NULL;
  PDBModel *model = file->Model(0);

  // Compute world box
  R3Box world_box;
  if (world_center || (world_radius != 0)) {
    // Compute world centroid
    R3Point world_centroid;
    if (world_center) world_centroid = *world_center;
    else world_centroid = PDBCentroid(model->atoms);

    // Compute world radius
    if (world_radius == 0) {
       world_radius = 3.0 * PDBAverageDistance(model->atoms, world_centroid);
    }

    // Compute world box
    R3Point world_corner1(world_centroid - R3ones_vector * world_radius);
    R3Point world_corner2(world_centroid + R3ones_vector * world_radius);
    world_box = R3Box(world_corner1, world_corner2);
  }
  else {
    // Compute world box
    const R3Box& bbox = model->BBox();
    R3Point world_corner1(bbox.Min() - R3ones_vector * world_border);
    R3Point world_corner2(bbox.Max() + R3ones_vector * world_border);
    world_box = R3Box(world_corner1, world_corner2);
  }

  // Compute grid resolution
  if (grid_spacing == 0) grid_spacing = 0.5;
  int xres = grid_resolution[0];
  if (xres == 0) {
    xres = (int) (world_box.XLength() / grid_spacing + 1);
    if (xres > max_grid_resolution) xres = max_grid_resolution;
  }
  int yres = grid_resolution[1];
  if (yres == 0) {
    yres = (int) (world_box.YLength() / grid_spacing + 1);
    if (yres > max_grid_resolution) yres = max_grid_resolution;
  }
  int zres = grid_resolution[2];
  if (zres == 0) {
    zres = (int) (world_box.ZLength() / grid_spacing + 1);
    if (zres > max_grid_resolution) zres = max_grid_resolution;
  }

  // Allocate grid
  R3Grid *grid = new R3Grid(xres, yres, zres, world_box);
  if (!grid) {
    fprintf(stderr, "Unable to allocate grid\n");
    exit(-1);
  }

  // Rasterize all atoms into interior grid
  R3Grid interior_grid(xres, yres, zres, world_box);
  for (int a = 0; a < model->NAtoms(); a++) {
    PDBAtom *atom = model->Atom(a);
    if (atom->IsHetAtom()) continue;
    interior_grid.RasterizeWorldSphere(atom->Position(), atom->Radius(), 1);
  }

  // Rasterize grid of average conservation
  R3Grid *conservation_grid = NULL;
  if (conservation_file) {
    conservation_grid = new R3Grid(xres, yres, zres, world_box);
    for (int a = 0; a < model->NAtoms(); a++) {
      PDBAtom *atom = model->Atom(a);
      if (atom->IsHetAtom()) continue;
      PDBResidue *residue = atom->Residue();
      RNScalar conservation = (residue) ? residue->conservation : 0;
      if ((conservation == PDB_UNKNOWN) || (conservation == 0)) conservation = 2 * RN_EPSILON;
      conservation_grid->RasterizeWorldSphere(atom->Position(), atom->Radius(), conservation);
    }
    conservation_grid->Divide(interior_grid);
  }

  // Allocate temporary storage
  int resolution = grid->XResolution();
  if (resolution < grid->YResolution()) resolution = grid->YResolution();
  if (resolution < grid->ZResolution()) resolution = grid->ZResolution();
  RNScalar *found1_buffer = new RNScalar [resolution];

  // Scan in three axial directions
  for (RNDimension dim = RN_X; dim <= RN_Z; dim++) {
    int index[3];
    RNDimension dim1 = (dim+1)%3;
    RNDimension dim2 = (dim+2)%3;
    for (index[dim2] = 0; index[dim2] < grid->Resolution(dim2); index[dim2]++) {
      for (index[dim1] = 0; index[dim1] < grid->Resolution(dim1); index[dim1]++) {
        RNScalar found1 = 0;
        for (index[dim] = 0; index[dim] < grid->Resolution(dim); index[dim]++) {
          RNBoolean interior = RNIsPositive(interior_grid.GridValue(index[0], index[1], index[2]));
          if (interior) found1 = (conservation_grid) ? conservation_grid->GridValue(index[0], index[1], index[2]) : 1;
          else found1_buffer[index[dim]] = found1;
        }
        RNScalar found2 = 0;
        for (index[dim] = grid->Resolution(dim)-1; index[dim] >= 0; index[dim]--) {
          RNBoolean interior = RNIsPositive(interior_grid.GridValue(index[0], index[1], index[2]));
          if (interior) found2 = (conservation_grid) ? conservation_grid->GridValue(index[0], index[1], index[2]) : 1;
          else if ((found2 > 0) && (found1_buffer[index[dim]] > 0)) {
	    //grid->AddGridValue(index[0], index[1], index[2], sqrt(found1_buffer[index[dim]] * found2));
	    //grid->AddGridValue(index[0], index[1], index[2], 0.5 * (found1_buffer[index[dim]] + found2));

	    if ((conservation_grid) && !strcmp(conservation_type, "geo_mean")){
	      grid->AddGridValue(index[0], index[1], index[2], sqrt(found1_buffer[index[dim]] * found2));
	    } else if ((conservation_grid) && !strcmp(conservation_type, "arith_mean")) {
	      grid->AddGridValue(index[0], index[1], index[2], 0.5 * (found1_buffer[index[dim]] + found2));
	    } else if ((conservation_grid) && !strcmp(conservation_type, "exp")){
	      grid->AddGridValue(index[0], index[1], index[2], pow(2.0, found1_buffer[index[dim]]) * pow(2.0, found2));
	    } else if ((conservation_grid) && !strcmp(conservation_type, "exp2")) {
	      grid->AddGridValue(index[0], index[1], index[2], pow(2.0, 2.0 * found1_buffer[index[dim]] - 1.0) * pow(2.0, 2.0 * found2 - 1.0));
	    } else {
	      grid->AddGridValue(index[0], index[1], index[2], 1);
	    }

          }
        }
      }
    }
  }

  // Scan in four diagonal directions 
  int step[3] = { 0, 0, 1 };
  int index[3] = { 0, 0, 0 };
  for (step[0] = -1; step[0] <= 1; step[0] += 2) {
    for (step[1] = -1; step[1] <= 1; step[1] += 2) {
      for (RNDimension dim = RN_X; dim <= RN_Z; dim++) {
        RNDimension dim1 = (dim+1)%3;
        RNDimension dim2 = (dim+2)%3;
        int start = (dim == RN_Z) ? 0 : 1;
        int stop1 = (dim == RN_Z) ? grid->Resolution(dim1)-1 : grid->Resolution(dim1)-2;
        int stop2 = (dim == RN_Z) ? grid->Resolution(dim2)-1 : grid->Resolution(dim2)-2;
        for (int i1 = start; i1 <= stop1; i1++) {
          for (int i2 = start; i2 <= stop2; i2++) {
            int i0 = (step[dim] > 0) ? 0 : grid->Resolution(dim)-1;
            index[dim] = i0;
            index[dim1] = i1; 
            index[dim2] = i2; 
            RNScalar found1 = 0;
            while (index[2] < grid->ZResolution()) {
              if (index[0] < 0) break;
              if (index[0] >= grid->XResolution()) break;
              if (index[1] < 0) break;
              if (index[1] >= grid->YResolution()) break;
              RNBoolean interior = RNIsPositive(interior_grid.GridValue(index[0], index[1], index[2]));
              if (interior) found1 =(conservation_grid) ? conservation_grid->GridValue(index[0], index[1], index[2]) : 1;
              else found1_buffer[index[2]] = found1;
              index[0] += step[0];
              index[1] += step[1];
              index[2] += step[2];
            }
            RNScalar found2 = 0;
            index[0] -= step[0];
            index[1] -= step[1];
            index[2] -= step[2];
            while (index[2] >= 0) {
              if (index[0] < 0) break;
              if (index[0] >= grid->XResolution()) break;
              if (index[1] < 0) break;
              if (index[1] >= grid->YResolution()) break;
              RNBoolean interior = RNIsPositive(interior_grid.GridValue(index[0], index[1], index[2]));
              if (interior) found2 = (conservation_grid) ? conservation_grid->GridValue(index[0], index[1], index[2]) : 1;
              else if ((found2 > 0) && (found1_buffer[index[2]] > 0)) {
		//grid->AddGridValue(index[0], index[1], index[2], sqrt(found1_buffer[index[2]] * found2));
		//grid->AddGridValue(index[0], index[1], index[2], 0.5 * (found1_buffer[index[2]] + found2));

		if ((conservation_grid) && !strcmp(conservation_type, "geo_mean")){
		  grid->AddGridValue(index[0], index[1], index[2], sqrt(found1_buffer[index[2]] * found2));
		} else if ((conservation_grid) && !strcmp(conservation_type, "arith_mean")) {
		  grid->AddGridValue(index[0], index[1], index[2], 0.5 * (found1_buffer[index[2]] + found2));
		} else if ((conservation_grid) && !strcmp(conservation_type, "exp")){
		  grid->AddGridValue(index[0], index[1], index[2], pow(2.0, found1_buffer[index[2]]) * pow(2.0, found2));
		} else if ((conservation_grid) && !strcmp(conservation_type, "exp2")) {
		  grid->AddGridValue(index[0], index[1], index[2], pow(2.0, 2.0 * found1_buffer[index[2]] - 1.0) * pow(2.0, 2.0 * found2 - 1.0));
		} else {
		  grid->AddGridValue(index[0], index[1], index[2], 1);
		}

              }
              index[0] -= step[0];
              index[1] -= step[1];
              index[2] -= step[2];
            }
          }
        }
      }
    }
  }

  // Delete temporary buffer
  delete [] found1_buffer;

  // Print statistics
  if (print_verbose) {
    printf("Created Ligsite grid ...\n");
    printf("  Time = %.2f seconds\n", start_time.Elapsed());
    printf("  Resolution = %d %d %d\n", grid->XResolution(), grid->YResolution(), grid->ZResolution());
    printf("  Spacing = %g\n", grid->GridToWorldScaleFactor());
    printf("  Cardinality = %d\n", grid->Cardinality());
    printf("  Volume = %g\n", grid->Volume());
    RNInterval grid_range = grid->Range();
    printf("  Minimum = %g\n", grid_range.Min());
    printf("  Maximum = %g\n", grid_range.Max());
    printf("  L1Norm = %g\n", grid->L1Norm());
    printf("  L2Norm = %g\n", grid->L2Norm());
    fflush(stdout);
  }

  // Return grid
  return grid;
}


// #############################################################################
// SURFNET CODE
// #############################################################################

static R3Grid *
CreateDistanceGrid(PDBFile *file, const R3Box& world_box, int xres, int yres, int zres)
{
  // Start statistics
  RNTime start_time;
  start_time.Read();

  // Get model from PDB file
  if (file->NModels() == 0) return NULL;
  PDBModel *model = file->Model(0);

  // Allocate grid
  R3Grid *grid = new R3Grid(xres, yres, zres);
  if (!grid) {
    fprintf(stderr, "Unable to allocate grid\n");
    exit(-1);
  }

  // Set transform 
  grid->SetWorldToGridTransformation(world_box);

  // Rasterize atom IDs
  for (int i = 0; i < model->NAtoms(); i++) {
    PDBAtom *atom = model->Atom(i);
    if (atom->IsHetAtom()) continue;
    R3Point grid_position = grid->GridPosition(atom->Position());
    int x = (int) (grid_position[0] + 0.5);
    if ((x < 0) || (x >= grid->XResolution())) continue;
    int y = (int) (grid_position[1] + 0.5);
    if ((y < 0) || (y >= grid->YResolution())) continue;
    int z = (int) (grid_position[2] + 0.5);
    if ((z < 0) || (z >= grid->ZResolution())) continue;
    grid->SetGridValue(x, y, z, i + 1.5);
  }

  // Compute atom voronoi regions
  grid->Voronoi();

  // Compute exact distances to closest atoms for every grid cell
  for (int k = 0; k < grid->ZResolution(); k++) {
    for (int j = 0; j < grid->YResolution(); j++) {
      for (int i = 0; i < grid->XResolution(); i++) {
        R3Point world_position = grid->WorldPosition(i, j, k);
        RNScalar grid_value = grid->GridValue(i, j, k);
        int closest_atom_id = (int) (grid_value - 1.0);
        assert((closest_atom_id >= 0) && (closest_atom_id < model->NAtoms()));
        PDBAtom *closest_atom = model->Atom(closest_atom_id);
        RNLength closest_atom_distance = R3Distance(world_position, closest_atom->Position()) - closest_atom->Radius();
        grid->SetGridValue(i, j, k, closest_atom_distance);
      }
    }
  }

  // Print statistics
  if (print_verbose) {
    printf("Created distance grid ...\n");
    printf("  Time = %.2f seconds\n", start_time.Elapsed());
    printf("  Resolution = %d %d %d\n", grid->XResolution(), grid->YResolution(), grid->ZResolution());
    printf("  Spacing = %g\n", grid->GridToWorldScaleFactor());
    printf("  Cardinality = %d\n", grid->Cardinality());
    printf("  Volume = %g\n", grid->Volume());
    RNInterval grid_range = grid->Range();
    printf("  Minimum = %g\n", grid_range.Min());
    printf("  Maximum = %g\n", grid_range.Max());
    printf("  L1Norm = %g\n", grid->L1Norm());
    printf("  L2Norm = %g\n", grid->L2Norm());
    fflush(stdout);
  }

  // Return grid
  return grid;
}



static R3Grid *
CreateSurfnetGrid(PDBFile *file, R3Grid *distance_grid)
{
  // Start statistics
  RNTime start_time;
  start_time.Read();

  // Get model from PDB file
  if (file->NModels() == 0) return NULL;
  PDBModel *model = file->Model(0);

  // Allocate grid
  R3Grid *grid = new R3Grid(distance_grid->XResolution(), distance_grid->YResolution(), distance_grid->ZResolution());
  if (!grid) {
    fprintf(stderr, "Unable to allocate grid\n");
    exit(-1);
  }

  // Set transform 
  grid->SetWorldToGridTransformation(distance_grid->WorldToGridTransformation());

  // Rasterize sphere at midpoint between every pair of atoms
  int natoms = 0;
  int npairs = 0;
  for (int i = 0; i < model->NAtoms(); i++) {
    // Get atom1
    PDBAtom *atom1 = model->Atom(i);
    PDBResidue *residue1 = atom1->Residue();
    if (!residue1) continue;
    if (atom1->IsHetAtom()) continue;
    if (atom1->accessible_surface_area == 0) continue;
    RNScalar radius1 = atom1->Radius();
    for (int j = i+1; j < model->NAtoms(); j++) {
      // Get atom2
      PDBAtom *atom2 = model->Atom(j);
      PDBResidue *residue2 = atom2->Residue();
      if (!residue2) continue;
      if (atom2->IsHetAtom()) continue;
      if (atom2->accessible_surface_area == 0) continue;
      RNScalar radius2 = atom2->Radius();

      // Compute weight
      /*RNScalar weight = 1;
      if (residue1->conservation != PDB_UNKNOWN) {
	weight *= sqrt(residue1->conservation * residue2->conservation);
	//weight *= (residue1->conservation * residue1->conservation);
	//weight *= pow(2.0, 2.0 * residue1->conservation - 1.0);
      }
      if (residue2->conservation != PDB_UNKNOWN){
	weight *= 1;
	//weight *= (residue2->conservation * residue2->conservation);  
	//weight *= pow(2.0, 2.0 * residue2->conservation - 1.0);
	}*/

      RNScalar weight = 1;
      if ((residue1->conservation != PDB_UNKNOWN) && (residue2->conservation != PDB_UNKNOWN)) {

	if (!strcmp(conservation_type, "geo_mean")){
	  weight *= sqrt(residue1->conservation * residue2->conservation);

	} else if (!strcmp(conservation_type, "arith_mean")) {
	  weight *= ( 0.5 * (residue1->conservation + residue2->conservation) );

	} else if (!strcmp(conservation_type, "exp")){
	  weight *= pow(2.0, residue1->conservation);
	  weight *= pow(2.0, residue2->conservation);

	} else if (!strcmp(conservation_type, "exp2")) {
	  weight *= pow(2.0, 2.0 * residue1->conservation - 1.0);
	  weight *= pow(2.0, 2.0 * residue2->conservation - 1.0);

	}

      }


      // Compute sphere between the atoms
      R3Point center = 0.5 * (atom1->position + atom2->position);
      RNLength span_length = R3Distance(atom1->position, atom2->position) - radius1 - radius2;
      if (span_length  > 10) continue;
      RNScalar distance = distance_grid->WorldValue(center);
      if (distance < 1.5) continue;
      if (distance > 4) distance = 4;
      grid->RasterizeWorldSphere(center, distance, weight);
      npairs++;
    }
    natoms++;
  }

  // Print statistics
  if (print_verbose) {
    printf("Created surfnet grid ...\n");
    printf("  Time = %.2f seconds\n", start_time.Elapsed());
    printf("  Resolution = %d %d %d\n", grid->XResolution(), grid->YResolution(), grid->ZResolution());
    printf("  Spacing = %g\n", grid->GridToWorldScaleFactor());
    printf("  Cardinality = %d\n", grid->Cardinality());
    printf("  Volume = %g\n", grid->Volume());
    RNInterval grid_range = grid->Range();
    printf("  Minimum = %g\n", grid_range.Min());
    printf("  Maximum = %g\n", grid_range.Max());
    printf("  L1Norm = %g\n", grid->L1Norm());
    printf("  L2Norm = %g\n", grid->L2Norm());
    printf("  # Atoms = %d\n", natoms);
    printf("  # Pairs = %d\n", npairs);
    fflush(stdout);
  }

  // Return grid
  return grid;
}


R3Grid *
SurfnetGrid(PDBFile *file)
{
  // Get array of atoms
  if (file->NModels() == 0) return NULL;
  PDBModel *model = file->Model(0);

  // Compute world box
  R3Box world_box;
  if (world_center || (world_radius != 0)) {
    // Compute world centroid
    R3Point world_centroid;
    if (world_center) world_centroid = *world_center;
    else world_centroid = PDBCentroid(model->atoms);

    // Compute world radius
    if (world_radius == 0) {
       world_radius = 3.0 * PDBAverageDistance(model->atoms, world_centroid);
    }

    // Compute world box
    R3Point world_corner1(world_centroid - R3ones_vector * world_radius);
    R3Point world_corner2(world_centroid + R3ones_vector * world_radius);
    world_box = R3Box(world_corner1, world_corner2);
  }
  else {
    // Compute world box
    const R3Box& bbox = model->BBox();
    R3Point world_corner1(bbox.Min() - R3ones_vector * world_border);
    R3Point world_corner2(bbox.Max() + R3ones_vector * world_border);
    world_box = R3Box(world_corner1, world_corner2);
  }

  // Compute grid resolution
  if (grid_spacing == 0) grid_spacing = 0.5;
  int xres = grid_resolution[0];
  if (xres == 0) {
    xres = (int) (world_box.XLength() / grid_spacing + 1);
    if (xres > max_grid_resolution) xres = max_grid_resolution;
  }
  int yres = grid_resolution[1];
  if (yres == 0) {
    yres = (int) (world_box.YLength() / grid_spacing + 1);
    if (yres > max_grid_resolution) yres = max_grid_resolution;
  }
  int zres = grid_resolution[2];
  if (zres == 0) {
    zres = (int) (world_box.ZLength() / grid_spacing + 1);
    if (zres > max_grid_resolution) zres = max_grid_resolution;
  }

  // Create distance grid
  R3Grid *distance_grid = CreateDistanceGrid(file, world_box, xres, yres, zres);
  if (!distance_grid) return NULL;

  // Create surfnetgrid
  R3Grid *grid = CreateSurfnetGrid(file, distance_grid);
  if (!grid) return NULL;

  // Threshold
  if (grid_threshold > 0) grid->Threshold(grid_threshold, 0, 1);

  // Delete distance grid
  delete distance_grid;

  // Return grid
  return grid;
}


// *****************************************************************************
// POCKETFINDER CODE
// *****************************************************************************

R3Grid *
PocketfinderGrid(PDBFile *file)
{
  // Start statistics
  RNTime start_time;
  start_time.Read();

  // Get array of atoms
  if (file->NModels() == 0) return NULL;
  PDBModel *model = file->Model(0);

  // Compute world box
  R3Box world_box;
  if (world_center || (world_radius != 0)) {
    // Compute world centroid
    R3Point world_centroid;
    if (world_center) world_centroid = *world_center;
    else world_centroid = PDBCentroid(model->atoms);

    // Compute world radius
    if (world_radius == 0) {
       world_radius = 3.0 * PDBAverageDistance(model->atoms, world_centroid);
    }

    // Compute world box
    R3Point world_corner1(world_centroid - R3ones_vector * world_radius);
    R3Point world_corner2(world_centroid + R3ones_vector * world_radius);
    world_box = R3Box(world_corner1, world_corner2);
  }
  else {
    // Compute world box
    const R3Box& bbox = model->BBox();
    R3Point world_corner1(bbox.Min() - R3ones_vector * world_border);
    R3Point world_corner2(bbox.Max() + R3ones_vector * world_border);
    world_box = R3Box(world_corner1, world_corner2);
  }

  // Compute grid resolution
  if (grid_spacing == 0) grid_spacing = 0.5;
  int xres = grid_resolution[0];
  if (xres == 0) {
    xres = (int) (world_box.XLength() / grid_spacing + 1);
    if (xres > max_grid_resolution) xres = max_grid_resolution;
  }
  int yres = grid_resolution[1];
  if (yres == 0) {
    yres = (int) (world_box.YLength() / grid_spacing + 1);
    if (yres > max_grid_resolution) yres = max_grid_resolution;
  }
  int zres = grid_resolution[2];
  if (zres == 0) {
    zres = (int) (world_box.ZLength() / grid_spacing + 1);
    if (zres > max_grid_resolution) zres = max_grid_resolution;
  }

  // Allocate grid
  R3Grid *grid = new R3Grid(xres, yres, zres);
  if (!grid) {
    fprintf(stderr, "Unable to allocate grid\n");
    exit(-1);
  }

  // Set transform 
  grid->SetWorldToGridTransformation(world_box);

  // Compute van der Waals force field using Lennard-Jones potential
  for (int a = 0; a < model->NAtoms(); a++) {
    // Get atom
    PDBAtom *atom = model->Atom(a);
    if (atom->IsHetAtom()) continue;

    // Get residue
    PDBResidue *residue = atom->Residue();
    if (!residue) continue;

    // Get atom element index
    PDBElement *element = atom->Element();
    if (!element) continue;
    int element_index = element - &PDBelements[0];
    assert(element_index >= 0);
    if (element_index > 5) continue;

    // Determine splat amplitude
    RNScalar amplitude = 1;
    if (residue->conservation != PDB_UNKNOWN) {
      RNScalar conservation_factor; 
      conservation_factor = residue->conservation;
      //conservation_factor = pow(2.0, 2.0 * residue->conservation - 1.0);
      //amplitude *= conservation_factor;

      if (!strcmp(conservation_type, "geo_mean")){
	amplitude *= conservation_factor;

      } else if (!strcmp(conservation_type, "arith_mean")) {
	amplitude *= conservation_factor;

      } else if (!strcmp(conservation_type, "exp")){
	amplitude *= pow(2.0, conservation_factor);

      } else if (!strcmp(conservation_type, "exp2")) {
	amplitude *= pow(2.0, 2.0 * conservation_factor - 1.0);

      }

    }

    // Get atom's constants for Lennard-Jones potential (assume other atom is carbon)
    RNScalar c6 = lennard_jones_c6[PDB_C_ELEMENT][element_index];
    RNScalar c12 = lennard_jones_c12[PDB_C_ELEMENT][element_index];
    if ((c6 == PDB_UNKNOWN) || (c12 == PDB_UNKNOWN)) continue;

    // Get grid extent for atom
    const RNLength world_extent = 10;
    const RNLength world_extent2 = world_extent * world_extent;
    const R3Point& world_position = atom->Position();
    RNLength grid_extent = world_extent * grid->WorldToGridScaleFactor();
    R3Point grid_position = grid->GridPosition(world_position);
    int grid_xlo = (int) (grid_position.X() - grid_extent);
    int grid_ylo = (int) (grid_position.Y() - grid_extent);
    int grid_zlo = (int) (grid_position.Z() - grid_extent);
    int grid_xhi = (int)  ceil(grid_position.X() + grid_extent);
    int grid_yhi = (int)  ceil(grid_position.Y() + grid_extent);
    int grid_zhi = (int)  ceil(grid_position.Z() + grid_extent);
    grid_xlo = (grid_xlo < 0) ? 0 : ((grid_xlo >= grid->XResolution()) ? grid->XResolution()-1 : grid_xlo);
    grid_xhi = (grid_xhi < 0) ? 0 : ((grid_xhi >= grid->XResolution()) ? grid->XResolution()-1 : grid_xhi);
    grid_ylo = (grid_ylo < 0) ? 0 : ((grid_ylo >= grid->YResolution()) ? grid->YResolution()-1 : grid_ylo);
    grid_yhi = (grid_yhi < 0) ? 0 : ((grid_yhi >= grid->YResolution()) ? grid->YResolution()-1 : grid_yhi);
    grid_zlo = (grid_zlo < 0) ? 0 : ((grid_zlo >= grid->ZResolution()) ? grid->ZResolution()-1 : grid_zlo);
    grid_zhi = (grid_zhi < 0) ? 0 : ((grid_zhi >= grid->ZResolution()) ? grid->ZResolution()-1 : grid_zhi);
    RNLength grid_to_world_scale_factor2 = grid->GridToWorldScaleFactor() * grid->GridToWorldScaleFactor();

    // Add Lennard-Jones potential for atom
    for (int k = grid_zlo; k <= grid_zhi; k++) {
      RNScalar grid_zdistance = grid_position.Z() - k;
      RNScalar grid_zdistance2 = grid_zdistance * grid_zdistance;
      for (int j = grid_ylo; j <= grid_yhi; j++) {
        RNScalar grid_ydistance = grid_position.Y() - j;
        RNScalar grid_ydistance2 = grid_ydistance * grid_ydistance;
        for (int i = grid_xlo; i <= grid_xhi; i++) {
          RNScalar grid_xdistance = grid_position.X() - i;
          RNScalar grid_xdistance2 = grid_xdistance * grid_xdistance;
          RNLength grid_distance2 = grid_xdistance2 + grid_ydistance2 + grid_zdistance2;
          RNLength world_distance2 = grid_distance2 * grid_to_world_scale_factor2;
          if (world_distance2 > world_extent2) continue;
          RNLength r6 = world_distance2 * world_distance2 * world_distance2;
          RNLength r12 = r6 * r6;
          RNScalar value = (c12/r12) - (c6/r6);
          value = -value; // Make positive values better
          value *= amplitude; // Scale contributions
          grid->AddGridValue(i, j, k, value);
        }
      }
    }
  }

  // Threshold grid to keep only attractive regions ([An05], page 6)
  // (0.25 is max value observed with current lennard-jones constants)
  RNScalar threshold = 0.8 * 0.25;
  grid->Threshold(threshold, threshold, R3_GRID_KEEP_VALUE);

  // Blur grid
  //  RNScalar grid_scale_sigma = 2.6 * grid->WorldToGridScaleFactor();
  //  grid->Blur(grid_scale_sigma);

#if 0
  // Contour to keep only the highest values ([An05], page 6 and 7)
  RNScalar tao = 4.6;
  RNScalar mean = grid->Mean();
  RNScalar variance = grid->Variance();
  RNScalar rmsd = sqrt(variance);
  RNScalar threshold = mean + tao * rmsd;
  RNInterval grid_range = grid->Range();
  printf("  Minimum = %g\n", grid_range.Min());
  printf("  Maximum = %g\n", grid_range.Max());
  printf("  Mean = %g\n", mean);
  printf("  Variance = %g\n", variance);
  printf("  Rmsd = %g\n", rmsd);
  printf("  Threshold = %g\n", threshold);
  printf("  Cardinality (before contour) = %d\n", grid->Cardinality());
  grid->Threshold(threshold, 0, R3_GRID_KEEP_VALUE);
  printf("  Cardinality (after contour) = %d\n", grid->Cardinality());
#endif

#if 0
  // Keep only cavities of more than 100 angstroms^3
  RNScalar min_cavity_volume = 100;
  RNScalar world_grid_cell_volume = grid->GridToWorldScaleFactor();
  world_grid_cell_volume = world_grid_cell_volume * world_grid_cell_volume * world_grid_cell_volume;
  int min_cavity_size = (int) (min_cavity_volume / world_grid_cell_volume);
  int max_cavities = grid->NEntries();
  int *cavity_size = new int [ max_cavities ];
  int *cavity_grid = new int [ grid->NEntries() ];
  int ncavities = grid->ConnectedComponents(1.0E-20, max_cavities, NULL, cavity_size, cavity_grid);
  if (ncavities > 0) {
    RNScalar *grid_valuesp = (RNScalar *) grid->GridValues();
    for (int i = 0; i < grid->NEntries(); i++) {
      int cavity = cavity_grid[i];
      assert(cavity < ncavities);
      if (cavity < 0) { *grid_valuesp = 0; }
      else if (cavity_size[cavity] < min_cavity_size) { *grid_valuesp = 0; }
      grid_valuesp++;
    }
  }
  delete [] cavity_size;
  delete [] cavity_grid;
#endif

  // Print statistics
  if (print_verbose) {
    printf("Created Pocketfinder grid ...\n");
    printf("  Time = %.2f seconds\n", start_time.Elapsed());
    printf("  Resolution = %d %d %d\n", grid->XResolution(), grid->YResolution(), grid->ZResolution());
    printf("  Spacing = %g\n", grid->GridToWorldScaleFactor());
    printf("  Cardinality = %d\n", grid->Cardinality());
    printf("  Volume = %g\n", grid->Volume());
    RNInterval grid_range = grid->Range();
    printf("  Minimum = %g\n", grid_range.Min());
    printf("  Maximum = %g\n", grid_range.Max());
    printf("  L1Norm = %g\n", grid->L1Norm());
    printf("  L2Norm = %g\n", grid->L2Norm());
    fflush(stdout);
  }

  // Return grid
  return grid;
}



