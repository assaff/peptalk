/******************************************************************************
 * pocket_extraction.C -  Copyright (c) 2009 Thomas Funkhouser and Tony Capra
 *
 *  This file implements several approaches for extracting coherent
 *  pockets from a 3D grid.
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
 *  
 *  -Tony Capra (tonyc@cs.princeton.edu)
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
 *
 *******************************************************************************/


#include "pocket_extraction.h"

enum {
  DONT_RANK_CAVITIES,
  RANK_CAVITIES_BY_SIZE,
  RANK_CAVITIES_BY_MAX_VALUE,
  RANK_CAVITIES_BY_MIN_VALUE,
  RANK_CAVITIES_BY_MEAN_VALUE,
  RANK_CAVITIES_BY_CONSERVATION
};


// pocket extraction variables
// defined in concavity.C by program options
extern char *pdb_name;
extern int print_verbose;

extern int max_grid_resolution;
extern RNLength grid_spacing;
extern R3Point *world_center;
extern RNScalar world_radius;
extern RNScalar world_border;

extern char *ligand_name;
extern RNScalar pocket_sigma1;
extern RNScalar pocket_sigma2;
extern RNScalar min_cavity_radius;
extern RNScalar min_cavity_volume;
extern RNScalar max_cavity_volume;
extern RNScalar max_total_volume;
extern RNScalar max_total_volume_as_fraction_of_ligand;
extern RNScalar max_total_volume_as_fraction_of_protein;
extern RNScalar min_protein_offset;
extern RNScalar max_protein_offset;
extern RNScalar ideal_protein_offset;
extern RNScalar interior_protein_sigma;
extern RNScalar exterior_protein_sigma;
extern RNScalar min_ligand_offset;
extern RNScalar max_ligand_offset;
extern RNScalar ideal_ligand_offset;
extern RNScalar interior_ligand_sigma;
extern RNScalar exterior_ligand_sigma;
extern int pocket_threshold_type; // 0=none, 1=absolute, 2=stddev, 3=percentile
extern RNScalar pocket_threshold;
extern int cavity_rank_method;
extern int normalization_type;
extern int max_cavities;



static int
NumConnectedComponents(const RNArray<PDBAtom *>& atoms)
{
  // Check atoms
  if (atoms.IsEmpty()) return 0;

  // Compute bounding box
  R3Box bbox(R3null_box);
  for (int i = 0; i < atoms.NEntries(); i++) {
    bbox.Union(atoms[i]->BBox());
  }

  // Create grid with atoms rasterized
  R3Grid grid(64, 64, 64);
  grid.SetWorldToGridTransformation(bbox);
  for (int i = 0; i < atoms.NEntries(); i++) {
    grid.RasterizeWorldSphere(atoms[i]->Position(), atoms[i]->Radius(), 1.0);
  }

  // Return number of connected components
  return grid.ConnectedComponents(0.5);
}


static RNScalar 
Volume(const RNArray<PDBAtom *>& atoms)
{
  // Check atoms
  if (atoms.IsEmpty()) return 0;

//  // Compute bounding box
//  R3Box bbox(R3null_box);
//  for (int i = 0; i < atoms.NEntries(); i++) {
//    bbox.Union(atoms[i]->BBox());
//  }
//
//  // Determine grid resolution
//  //RNLength spacing = 0.5;
//  RNLength spacing = grid_spacing;
//  //const int maxres = 256;
//  const int maxres = max_grid_resolution;
//
//  int xres = (int) (bbox.XLength() / spacing);
//  //int xres = (int) (bbox.XLength() / spacing + 1);
//  if (xres > maxres) {
//    spacing = bbox.XLength() / maxres;
//    xres = (int) (bbox.XLength() / spacing);
//  }
//  int yres = (int) (bbox.YLength() / spacing);
//  //int yres = (int) (bbox.YLength() / spacing + 1);
//  if (yres > maxres) {
//    spacing = bbox.YLength() / maxres;
//    yres = (int) (bbox.YLength() / spacing);
//  }
//  int zres = (int) (bbox.ZLength() / spacing);
//  //int zres = (int) (bbox.ZLength() / spacing + 1);
//  if (zres > maxres) {
//    spacing = bbox.ZLength() / maxres;
//    zres = (int) (bbox.ZLength() / spacing);
//  }


  // Compute world box
  R3Box bbox = PDBBox(atoms);
  R3Point world_corner1(bbox.Min() - R3ones_vector * world_border);
  R3Point world_corner2(bbox.Max() + R3ones_vector * world_border);
  R3Box world_box = R3Box(world_corner1, world_corner2);


  // Compute grid resolution
  int grid_resolution[3] = { 0, 0, 0 };
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

  // Create grid with atoms rasterized
  R3Grid grid(xres, yres, zres);
  grid.SetWorldToGridTransformation(world_box);
  for (int i = 0; i < atoms.NEntries(); i++) {
    grid.RasterizeWorldSphere(atoms[i]->Position(), atoms[i]->Radius(), 1.0);
  }

  //grid.WriteFile("lig_vol.grd");
  // Return volume
  return grid.Volume();
}


static RNScalar
Threshold(R3Grid *grid, int threshold_type, RNScalar threshold_value)
{
  // Initialize threshold
  RNScalar threshold = 0;

  // Threshold mask
  if (threshold_type == 1) {
    // Straight threshold
    threshold = threshold_value;
  }
  else if (threshold_type == 2) {
    // Compute statistics of non-zero entries
    int count = 0;
    RNScalar sum = 0;
    RNScalar mean = 0;
    RNScalar variance = 0;
    RNScalar stddev = 0;
    RNScalar minimum = FLT_MAX;
    for (int i = 0; i < grid->NEntries(); i++) {
      RNScalar value = grid->GridValue(i);
      if (value != 0) {
        if (value < minimum) minimum = value;
        sum += value;
        count++;
      }
    }
    if (count > 0) {
      mean = sum / (RNScalar) count;
      RNScalar ssd = 0;
      for (int i = 0; i < grid->NEntries(); i++) {
        RNScalar value = grid->GridValue(i);
        if (value != 0) {
          RNScalar residual = value - mean;
          ssd += residual * residual;
        }
      }
      variance = ssd / (RNScalar) count;
      stddev = sqrt(variance);
    }

    // Compute threshold
    threshold = threshold_value * stddev + mean;
  }
  else if (threshold_type == 3) {
    // Make array of all nonzero grid values
    int nvalues = 0;
    RNScalar *values = new RNScalar [ grid->NEntries() ];
    for (int i = 0; i < grid->NEntries(); i++) {
      RNScalar value = grid->GridValue(i);
      if (value != 0) values[nvalues++] = value;
    }

    // Sort array
    qsort(values, nvalues, sizeof(RNScalar), RNCompareScalars);

    // Determine threshold at given percentile
    int index = (int) (threshold_value * nvalues);
    if (index < 0) index = 0;
    if (index >= nvalues) index = nvalues-1;
    threshold = values[index];

    // Delete array of grid values
    delete [] values;
  }

  // Return threshold
  return threshold;
}



static void
RankCavities(PDBFile *file, R3Grid *grid, int method) 
{
  // Start statistics
  RNTime start_time;
  start_time.Read();

  // Get model from PDB file
  if (file->NModels() == 0) return;
  PDBModel *model = file->Model(0);

  // Compute cavities
  int *cavity_size = new int [ grid->NEntries() ];
  int *cavity_grid = new int [ grid->NEntries() ];
  int ncavities = grid->ConnectedComponents(1.0E-20, grid->NEntries(), NULL, cavity_size, cavity_grid);

  // Check if there are any cavities
  if (ncavities == 0) {
    delete [] cavity_size;
    delete [] cavity_grid;
    return;
  }

  // Compute cavity properties
  RNScalar *cavity_properties = new RNScalar [ ncavities ];
  for (int i = 0; i < ncavities; i++) cavity_properties[i] = 0;
  if (method == RANK_CAVITIES_BY_SIZE) {
    for (int i = 0; i < ncavities; i++) {
      cavity_properties[i] = cavity_size[i];
    }
  }
  else if (method == RANK_CAVITIES_BY_MAX_VALUE) {
    for (int i = 0; i < ncavities; i++) {
      cavity_properties[i] = -FLT_MAX;
    }
    for (int i = 0; i < grid->NEntries(); i++) {
      int cavity = cavity_grid[i];
      if (cavity < 0) continue;
      RNScalar value = grid->GridValue(i);
      if (value > cavity_properties[cavity]) {
        cavity_properties[cavity] = value;
      }
    }
  }
  else if (method == RANK_CAVITIES_BY_MIN_VALUE) {
    for (int i = 0; i < ncavities; i++) {
      cavity_properties[i] = FLT_MAX;
    }
    for (int i = 0; i < grid->NEntries(); i++) {
      int cavity = cavity_grid[i];
      if (cavity < 0) continue;
      RNScalar value = grid->GridValue(i);
      if (value < cavity_properties[cavity]) {
        cavity_properties[cavity] = value;
      }
    }
  }
  else if (method == RANK_CAVITIES_BY_MEAN_VALUE) {
    for (int i = 0; i < grid->NEntries(); i++) {
      int cavity = cavity_grid[i];
      if (cavity < 0) continue;
      RNScalar value = grid->GridValue(i);
      cavity_properties[cavity] += value;
    }
    for (int i = 0; i < ncavities; i++) {
      if (cavity_size[i] == 0) continue;
      cavity_properties[i] /= cavity_size[i];
    }
  }
  else if (method == RANK_CAVITIES_BY_CONSERVATION) {
    for (int i = 0; i < ncavities; i++) {
      // Sum positions (to compute centroid)
      int cavity_count = 0;
      R3Point cavity_position = R3zero_point;
      for (int j = 0; j < grid->NEntries(); j++) {
        int cavity = cavity_grid[i];
        if (cavity != i) continue;
        int ix, iy, iz;
        grid->IndexToIndices(j, ix, iy, iz);
        R3Point position = grid->WorldPosition(ix, iy, iz);
        cavity_position += position;
        cavity_count++;
      }

      // Compute centroid
      if (cavity_count == 0) continue;
      cavity_position /= cavity_count;

      // Average conservation of residues within 8 Angstroms of cavity
      int conservation_count = 0;
      RNScalar conservation_sum = 0;
      for (int j = 0; j < model->NResidues(); j++) {
        PDBResidue *residue = model->Residue(j);
        R3Point residue_position = residue->Centroid();
        if (R3Distance(cavity_position, residue_position) < 8) {
          conservation_sum += residue->conservation;
          conservation_count++;
        }
      }

      // Assign cavity property 
      if (conservation_count > 0) {
        cavity_properties[i] = conservation_sum /= conservation_count;
      }
    }
  }

  // Compute cavity ranks
  int *cavity_ranks = new int [ ncavities ];
  for (int i = 0; i < ncavities; i++) {
    // Find next best cavity
    int best_cavity_index = -1;
    RNScalar best_cavity_property = -FLT_MAX;
    for (int j = 0; j < ncavities; j++) {
      if (cavity_properties[j] > best_cavity_property) {
        best_cavity_index = j;
        best_cavity_property = cavity_properties[j];
      }
    }

    // Check next best cavity
    if (best_cavity_index == -1) break;

    // Set cavity rank 
    cavity_ranks[best_cavity_index] = ncavities - i;

    // Mark cavity as done
    cavity_properties[best_cavity_index] = -FLT_MAX;
  }

  // Replace grid values
  for (int i = 0; i < grid->NEntries(); i++) {
    int cavity = cavity_grid[i];
    int rank = cavity_ranks[cavity];
    RNScalar value = (RNScalar) rank / (RNScalar) ncavities;
    grid->SetGridValue(i, value);
  }

  // Print statistics
  if (print_verbose) {
    printf("Ranked cavities .. \n");
    printf("  Time = %.2f seconds\n", start_time.Elapsed());
    printf("  # Cavities = %d\n", ncavities);
    printf("  Ranking Method = %d\n", method);
    printf("  Cardinality = %d\n", grid->Cardinality());
    printf("  Volume = %g\n", grid->Volume());
    RNInterval grid_range = grid->Range();
    printf("  Minimum = %g\n", grid_range.Min());
    printf("  Maximum = %g\n", grid_range.Max());
    printf("  L1Norm = %g\n", grid->L1Norm());
    printf("  L2Norm = %g\n", grid->L2Norm());
    fflush(stdout);
  }

  // Delete memory
  delete [] cavity_size;
  delete [] cavity_grid;
  delete [] cavity_properties;
  delete [] cavity_ranks;
}


static void
Blur(R3Grid *grid, RNScalar sigma)
{
  // Check sigma
  if (sigma == 0) return;

  // Start statistics
  RNTime start_time;
  start_time.Read();

  // Blur the grid
  grid->Blur(sigma * grid->WorldToGridScaleFactor());

  // Print statistics
  if (print_verbose) {
    printf("Blurred grid .. \n");
    printf("  Time = %.2f seconds\n", start_time.Elapsed());
    printf("  Sigma = %g\n", sigma);
    printf("  Cardinality = %d\n", grid->Cardinality());
    printf("  Volume = %g\n", grid->Volume());
    RNInterval grid_range = grid->Range();
    printf("  Minimum = %g\n", grid_range.Min());
    printf("  Maximum = %g\n", grid_range.Max());
    printf("  L1Norm = %g\n", grid->L1Norm());
    printf("  L2Norm = %g\n", grid->L2Norm());
    fflush(stdout);
  }
}



static void
Normalize(R3Grid *grid, int normalization_type)
{
  // Check normalization type
  if (normalization_type == 0) return; 

  // Start statistics
  RNTime start_time;
  start_time.Read();

  // Compute statistics of non-zero entries
  int count = 0;
  RNScalar sum = 0;
  RNScalar mean = 0;
  RNScalar variance = 0;
  RNScalar stddev = 0;
  RNScalar minimum = FLT_MAX;
  for (int i = 0; i < grid->NEntries(); i++) {
    RNScalar value = grid->GridValue(i);
    if (value != 0) {
      if (value < minimum) minimum = value;
      sum += value;
      count++;
    }
  }
  if (count > 0) {
    mean = sum / (RNScalar) count;
    RNScalar ssd = 0;
    for (int i = 0; i < grid->NEntries(); i++) {
      RNScalar value = grid->GridValue(i);
      if (value != 0) {
        RNScalar residual = value - mean;
        ssd += residual * residual;
      }
    }
    variance = ssd / (RNScalar) count;
    stddev = sqrt(variance);
  }

  // Normalize the grid
  if (normalization_type == 1) {
    // Divide by L1Norm
    RNScalar l1norm = grid->L1Norm();
    if (l1norm > 0) grid->Divide(l1norm);
  }
  else if (normalization_type == 2) {
    // Scale by L2 norm
    if (mean != 0) grid->Normalize();
  }
  else if (normalization_type == 3) {
    // Shift mean to zero, and scale by stddev 
    if (mean != 0) grid->Subtract(mean);
    if (stddev != 0) grid->Divide(stddev);
  }
  else if (normalization_type == 4) {
    // Make everything positive starting at zero and scale by mean
    RNScalar scale = mean - minimum;
    if (scale != 0) {
      for (int i = 0; i < grid->NEntries(); i++) {
        RNScalar value = grid->GridValue(i);
        if (value != 0) {
          grid->SetGridValue(i, (value - minimum) / scale);
        }
      }
    }
  }

  // Print statistics
  if (print_verbose) {
    printf("Normalized grid .. \n");
    printf("  Time = %.2f seconds\n", start_time.Elapsed());
    printf("  Normalization type = %d\n", normalization_type);
    printf("  Mean = %g\n", mean);
    printf("  Variance = %g\n", variance);
    printf("  Standard deviation = %g\n", stddev);
    printf("  Cardinality = %d\n", grid->Cardinality());
    printf("  Volume = %g\n", grid->Volume());
    RNInterval grid_range = grid->Range();
    printf("  Minimum = %g\n", grid_range.Min());
    printf("  Maximum = %g\n", grid_range.Max());
    printf("  L1Norm = %g\n", grid->L1Norm());
    printf("  L2Norm = %g\n", grid->L2Norm());
    fflush(stdout);
  }
}



static void
MaskToSphere(R3Grid *mask, const R3Point *world_center, RNScalar world_radius)
{
  // Start statistics
  RNTime start_time;
  start_time.Read();

  // Compute world centroid
  R3Point world_centroid;
  if (world_center) world_centroid = *world_center;
  else world_centroid = mask->WorldBox().Centroid();

  // Create spherical mask
  R3Grid sphere_mask(mask->XResolution(), mask->YResolution(), mask->ZResolution());
  sphere_mask.SetWorldToGridTransformation(mask->WorldToGridTransformation());
  sphere_mask.RasterizeWorldSphere(world_centroid, world_radius, 1);

  // Blur spherical mask
  sphere_mask.Blur(0.1 * world_radius * sphere_mask.WorldToGridScaleFactor());

  // Apply mask
  mask->Multiply(sphere_mask);

  // Print statistics
  if (print_verbose) {
    printf("Masked to sphere ...\n");
    printf("  Time = %.2f seconds\n", start_time.Elapsed());
    printf("  World center =  %g %g %g\n", world_centroid[0], world_centroid[1], world_centroid[2]);
    printf("  World radius = %g\n", world_radius); 
    printf("  Cardinality = %d\n", mask->Cardinality());
    printf("  Volume = %g\n", mask->Volume());
    RNInterval grid_range = mask->Range();
    printf("  Minimum = %g\n", grid_range.Min());
    printf("  Maximum = %g\n", grid_range.Max());
    printf("  L1Norm = %g\n", mask->L1Norm());
    printf("  L2Norm = %g\n", mask->L2Norm());
    fflush(stdout);
  }
}



static void
MaskToOffset(R3Grid *mask, const RNArray<PDBAtom *>& atoms,
  RNScalar min_offset, RNScalar max_offset, 
  RNScalar ideal_offset, RNScalar interior_sigma, RNScalar exterior_sigma)
{
  // Start statistics
  RNTime start_time;
  start_time.Read();

  // Create offset mask
  R3Grid offset_mask(mask->XResolution(), mask->YResolution(), mask->ZResolution());
  offset_mask.SetWorldToGridTransformation(mask->WorldToGridTransformation());
  for (int i = 0; i < atoms.NEntries(); i++) {
    PDBAtom *atom = atoms.Kth(i);
    R3Point grid_position = mask->GridPosition(atom->Position());
    int x = (int) (grid_position[0] + 0.5);
    if ((x < 0) || (x >= mask->XResolution())) continue;
    int y = (int) (grid_position[1] + 0.5);
    if ((y < 0) || (y >= mask->YResolution())) continue;
    int z = (int) (grid_position[2] + 0.5);
    if ((z < 0) || (z >= mask->ZResolution())) continue;
    offset_mask.SetGridValue(x, y, z, i + 0.5);
  }

  // Compute mask as Gaussian function of distance to closest atom minus offset
  offset_mask.Voronoi();
  for (int k = 0; k < offset_mask.ZResolution(); k++) {
    for (int j = 0; j < offset_mask.YResolution(); j++) {
      for (int i = 0; i < offset_mask.XResolution(); i++) {
        R3Point world_position = offset_mask.WorldPosition(i, j, k);
        int closest_atom_id = (int) offset_mask.GridValue(i, j, k);
        PDBAtom *closest_atom = atoms.Kth(closest_atom_id);
        RNLength closest_atom_distance = R3Distance(world_position, closest_atom->Position()) - closest_atom->Radius();
        if ((min_offset > -RN_INFINITY) && (closest_atom_distance < min_offset)) {
          // Too close
          offset_mask.SetGridValue(i, j, k, 0.0);
        }
        else if ((max_offset < RN_INFINITY) && (closest_atom_distance > max_offset)) {
          // Too far
          offset_mask.SetGridValue(i, j, k, 0.0);
        }
        else {
          // Within range - apply gaussian falloff from ideal offset
          RNLength distance = closest_atom_distance - ideal_offset;
          RNLength distance_squared = distance * distance;
          if ((distance < 0) && (interior_sigma > 0)) {
            // Use interior sigma
            RNScalar denom = -2.0 * interior_sigma * interior_sigma;
            RNScalar value = exp( distance_squared / denom );
            offset_mask.SetGridValue(i, j, k, value);
          }
          else if ((distance >= 0) && (exterior_sigma > 0)) {
            // Use exterior sigma
            RNScalar denom = -2.0 * exterior_sigma * exterior_sigma;
            RNScalar value = exp( distance_squared / denom );
            offset_mask.SetGridValue(i, j, k, value);
          }
          else {
            // Apply step function 
            offset_mask.SetGridValue(i, j, k, 1.0);
          }
        }
      }
    }
  }

  // Apply mask
  mask->Multiply(offset_mask);

  // Print statistics
  if (print_verbose) {
    printf("Masked to offset from %d atoms ... \n", atoms.NEntries());
    printf("  Time = %.2f seconds\n", start_time.Elapsed());
    printf("  Min offset = %g\n", min_offset);
    printf("  Max offset = %g\n", max_offset);
    printf("  Ideal offset = %g\n", ideal_offset);
    printf("  Interior sigma = %g\n", interior_sigma);
    printf("  Exterior sigma = %g\n", exterior_sigma);
    printf("  Cardinality = %d\n", mask->Cardinality());
    printf("  Volume = %g\n", mask->Volume());
    RNInterval grid_range = mask->Range();
    printf("  Minimum = %g\n", grid_range.Min());
    printf("  Maximum = %g\n", grid_range.Max());
    printf("  L1Norm = %g\n", mask->L1Norm());
    printf("  L2Norm = %g\n", mask->L2Norm());
    fflush(stdout);
  }
}



static void
MaskToCavityRadius(R3Grid *mask, RNScalar min_cavity_radius)
{
  // Start statistics
  RNTime start_time;
  start_time.Read();

  // Create mask
  R3Grid breadth_mask(*mask);

  // Make all non-zero values one
  for (int i = 0; i < breadth_mask.NEntries(); i++) {
    if (breadth_mask.GridValue(i) != 0) breadth_mask.SetGridValue(i, 1);
  }

  // Erode and then dilate
  // Should convert to grid distance !!!
  breadth_mask.Erode(min_cavity_radius);  
  breadth_mask.Dilate(min_cavity_radius);  

  // Apply mask
  mask->Mask(breadth_mask);

  // Print statistics
  if (print_verbose) {
    printf("Masked to cavity radius .. \n");
    printf("  Time = %.2f seconds\n", start_time.Elapsed());
    printf("  Min cavity radius = %g\n", min_cavity_radius);
    printf("  Cardinality = %d\n", mask->Cardinality());
    printf("  Volume = %g\n", mask->Volume());
    RNInterval grid_range = mask->Range();
    printf("  Minimum = %g\n", grid_range.Min());
    printf("  Maximum = %g\n", grid_range.Max());
    printf("  L1Norm = %g\n", mask->L1Norm());
    printf("  L2Norm = %g\n", mask->L2Norm());
    fflush(stdout);
  }
}



static void
MaskToCavityVolume(R3Grid *mask, RNScalar min_cavity_volume)
{
  // Start statistics
  RNTime start_time;
  start_time.Read();

  // Create mask
  R3Grid cavity_mask(*mask);

  // Make all non-zero values one
  for (int i = 0; i < cavity_mask.NEntries(); i++) {
    if (cavity_mask.GridValue(i) != 0) cavity_mask.SetGridValue(i, 1);
  }

  // Keep only cavities large enough to hold a certain volume
  RNScalar world_grid_cell_volume = cavity_mask.GridToWorldScaleFactor();
  world_grid_cell_volume = world_grid_cell_volume * world_grid_cell_volume * world_grid_cell_volume;
  int min_cavity_size = (int) (min_cavity_volume / world_grid_cell_volume);
  int max_cavities = cavity_mask.NEntries();
  int *cavity_size = new int [ max_cavities ];
  int *cavity_grid = new int [ cavity_mask.NEntries() ];
  int ncavities = cavity_mask.ConnectedComponents(0.5, max_cavities, NULL, cavity_size, cavity_grid);
  RNScalar *mask_valuesp = (RNScalar *) cavity_mask.GridValues();
  for (int i = 0; i < cavity_mask.NEntries(); i++) {
    int cavity = cavity_grid[i];
    assert(cavity < ncavities);
    if (cavity < 0) { *mask_valuesp = 0; }
    else if (cavity_size[cavity] < min_cavity_size) { *mask_valuesp = 0; }
    else *mask_valuesp = 1;
    mask_valuesp++;
  }
  delete [] cavity_size;
  delete [] cavity_grid;

  // Apply mask
  mask->Mask(cavity_mask);

  // Print statistics
  if (print_verbose) {
    printf("Masked to cavity volume .. \n");
    printf("  Time = %.2f seconds\n", start_time.Elapsed());
    printf("  Min cavity volume = %g\n", min_cavity_volume);
    printf("  # Cavities = %d\n", ncavities);
    printf("  Cardinality = %d\n", mask->Cardinality());
    printf("  Volume = %g\n", mask->Volume());
    RNInterval grid_range = mask->Range();
    printf("  Minimum = %g\n", grid_range.Min());
    printf("  Maximum = %g\n", grid_range.Max());
    printf("  L1Norm = %g\n", mask->L1Norm());
    printf("  L2Norm = %g\n", mask->L2Norm());
    fflush(stdout);
  }
}



static void 
MaskToLargestCavities(R3Grid *mask, int max_cavities)
{
  // Start statistics
  RNTime start_time;
  start_time.Read();

  // Create mask
  R3Grid cavity_mask(*mask);

  // Make all non-zero values one
  for (int i = 0; i < cavity_mask.NEntries(); i++) {
    if (cavity_mask.GridValue(i) != 0) cavity_mask.SetGridValue(i, 1);
  }

  // Allocate arrays to store cavity information
  int *cavity_sizes = new int [ cavity_mask.NEntries() ];
  int *cavity_ids = new int [ cavity_mask.NEntries() ];
  assert(cavity_sizes && cavity_ids);

  // Find connected cavities 
  int ncavities = cavity_mask.ConnectedComponents(0.5, cavity_mask.NEntries(), NULL, cavity_sizes, cavity_ids);
  assert(ncavities <= cavity_mask.NEntries());

  // Check number of connected cavities
  if (ncavities < max_cavities) return;

  // Check number of cavities
  if (max_cavities == 1) {
    // Find maximum connected cavity
    int biggest_cavity_id = -1;
    int biggest_cavity_size = -1;
    for (int j = 0; j < ncavities; j++) {
      if (cavity_sizes[j] > biggest_cavity_size) {
        biggest_cavity_size = cavity_sizes[j];
        biggest_cavity_id = j;
      }
    }

    // Assign '0' to values not in biggest cavity at threshold
    if (biggest_cavity_id >= 0) {
      int *cavity_idsp = cavity_ids;
      RNScalar *grid_valuesp = (RNScalar *) cavity_mask.GridValues();
      for (int j = 0; j < cavity_mask.NEntries(); j++) {
        if (*cavity_idsp != biggest_cavity_id) *grid_valuesp = 0;
        cavity_idsp++;
        grid_valuesp++;
      }
    }
  } 
  else {
    // Allocate arrays to store biggest cavity information
    int *biggest_cavity_ids = new int [ max_cavities ];
    int *biggest_cavity_sizes = new int [ max_cavities ];
    assert(biggest_cavity_ids && biggest_cavity_sizes);
    int biggest_cavity_count = 0;

    // Build sorted arrays of biggest cavity information
    for (int j = 0; j < ncavities; j++) { 
      int biggest_cavity_index = 0;
      while (biggest_cavity_index < biggest_cavity_count) {
        if (cavity_sizes[j] > biggest_cavity_sizes[biggest_cavity_index]) break;
        biggest_cavity_index++;
      }
      for (int k = biggest_cavity_count; k > biggest_cavity_index; k--) {
        biggest_cavity_ids[k] = biggest_cavity_ids[k-1];
        biggest_cavity_sizes[k] = biggest_cavity_sizes[k-1];
      }
      if (biggest_cavity_index < max_cavities) {
        biggest_cavity_ids[biggest_cavity_index] = j;
        biggest_cavity_sizes[biggest_cavity_index] = cavity_sizes[j];
      }
      if (biggest_cavity_count < max_cavities) {
        biggest_cavity_count++;
      }
    }

    // Assign '0' to values not in biggest cavities
    if (biggest_cavity_count >= 0) {
      int *cavity_idsp = cavity_ids;
      RNScalar *grid_valuesp = (RNScalar *) cavity_mask.GridValues();
      for (int j = 0; j < cavity_mask.NEntries(); j++) {
        int cavity_id = *cavity_idsp;
        int found = 0;
        for (int k = 0; k < biggest_cavity_count; k++) {
          if (biggest_cavity_ids[k] == cavity_id) {
            found = 1;
            break;
          }
        }
        if (!found) *grid_valuesp = 0;
        cavity_idsp++;
        grid_valuesp++;
      }
    }

    // Delete arrays to store biggest cavity information
    delete [] biggest_cavity_sizes;
    delete [] biggest_cavity_ids;
  }

  // Delete arrays to store connected cavity information
  delete [] cavity_sizes;
  delete [] cavity_ids;

  // Apply mask
  mask->Mask(cavity_mask);

  // Print statistics
  if (print_verbose) {
    printf("Masked to largest cavities only .. \n");
    printf("  Time = %.2f seconds\n", start_time.Elapsed());
    printf("  # Input cavities = %d\n", ncavities);
    printf("  # Output cavities = %d\n", (ncavities < max_cavities) ? ncavities : max_cavities);
    printf("  Cardinality = %d\n", mask->Cardinality());
    printf("  Volume = %g\n", mask->Volume());
    RNInterval grid_range = mask->Range();
    printf("  Minimum = %g\n", grid_range.Min());
    printf("  Maximum = %g\n", grid_range.Max());
    printf("  L1Norm = %g\n", mask->L1Norm());
    printf("  L2Norm = %g\n", mask->L2Norm());
    fflush(stdout);
  }
}



static void
MaskToThreshold(R3Grid *mask, int threshold_type, RNScalar threshold_value)
{
  // Start statistics
  RNTime start_time;
  start_time.Read();

  // Check threshold type
  if (threshold_type == 0) return;

  // Determine threshold
  RNScalar threshold = Threshold(mask, threshold_type, threshold_value);

  // Apply threshold
  mask->Threshold(threshold, 0, R3_GRID_KEEP_VALUE);

  // Print statistics
  if (print_verbose) {
    printf("Masked to threshold .. \n");
    printf("  Time = %.2f seconds\n", start_time.Elapsed());
    printf("  Threshold type = %d\n", threshold_type);
    printf("  Threshold value = %g\n", threshold_value);
    printf("  Threshold absolute = %g\n", threshold);
    printf("  Cardinality = %d\n", mask->Cardinality());
    printf("  Volume = %g\n", mask->Volume());
    RNInterval grid_range = mask->Range();
    printf("  Minimum = %g\n", grid_range.Min());
    printf("  Maximum = %g\n", grid_range.Max());
    printf("  L1Norm = %g\n", mask->L1Norm());
    printf("  L2Norm = %g\n", mask->L2Norm());
    fflush(stdout);
  }
}



static void 
MaskToTotalVolume(R3Grid *mask, RNScalar max_total_volume, 
                  RNScalar min_cavity_radius, RNScalar min_cavity_volume, int max_cavities)
{
  // Start statistics
  RNTime start_time;
  start_time.Read();

  // Turn off print_verbose because call other functions from here
  RNBoolean saved_print_verbose = print_verbose;
  print_verbose = FALSE;
  //if (print_debug) printf("MASKING TO TOTAL VOLUME:\n");

  // Determine ranges
  RNInterval threshold_range = mask->Range();
  RNInterval volume_range(0, mask->Volume()); 

  // Check ranges
  if (threshold_range.IsEmpty()) return;
  if (volume_range.IsEmpty()) return;
  if (max_total_volume <= volume_range.Min()) return;
  if (max_total_volume >= volume_range.Max()) return;

  // Create copy of mask so that can modify/test iteratively
  R3Grid mask_copy(*mask);

  // Binary search for threshold that provides target volume
  for (int i = 0; i < 100; i++) {
    // Compute new guess for threshold
    // RNScalar t = (max_total_volume - volume_range.Min()) / (volume_range.Max() - volume_range.Min());
    // RNScalar threshold = threshold_range.Max() - t * (threshold_range.Max() - threshold_range.Min());
    RNScalar threshold = threshold_range.Mid();

    // Make fresh copy of mask
    const RNScalar *mask_valuesp = mask->GridValues();
    RNScalar *mask_copy_valuesp = (RNScalar *) mask_copy.GridValues();
    for (int j = 0; j < mask->NEntries(); j++) {
      *mask_copy_valuesp++ = *mask_valuesp++;
    }

    // Threshold copy of mask
    mask_copy.Threshold(threshold, 0, R3_GRID_KEEP_VALUE);

    // Mask by cavity radius
    if (min_cavity_radius > 0) {
      MaskToCavityRadius(&mask_copy, min_cavity_radius);
    }

    // Mask by cavity volume
    if (min_cavity_volume > 0) {
      MaskToCavityVolume(&mask_copy, min_cavity_volume);
    }

    // Mask to largest cavities only
    if (max_cavities > 0) {
      MaskToLargestCavities(&mask_copy, max_cavities);
    }

    // Determine volume of non-zero entries
    RNScalar volume = mask_copy.Volume();
    //printf("%d  Volume = %g\n",i, mask_copy.Volume());

    // Adjust ranges according to volume
    if (RNIsGreater(volume, max_total_volume, 1)) {
      threshold_range.SetMin(threshold);
      volume_range.SetMax(volume);
    }
    else if (RNIsLess(volume, max_total_volume, 1)) {
      threshold_range.SetMax(threshold);
      volume_range.SetMin(volume);
    }
    else {
      // Found target volume!
      break;
    }
  }

  // Restore previous print_verbose status
  print_verbose = saved_print_verbose;

  // Copy thresholded mask
  *mask = mask_copy;      

  // Print statistics
  if (print_verbose) {
    printf("Masked to total volume .. \n");
    printf("  Time = %.2f seconds\n", start_time.Elapsed());
    printf("  Max total volume = %g\n", max_total_volume);
    printf("  Minimum cavity radius = %g\n", min_cavity_radius);
    printf("  Minimum cavity volume = %g\n", min_cavity_volume);
    printf("  Max cavities = %d\n", max_cavities);
    printf("  Grid treshold = %g\n", threshold_range.Mid());
    printf("  Cardinality = %d\n", mask->Cardinality());
    printf("  Volume = %g\n", mask->Volume());
    RNInterval grid_range = mask->Range();
    printf("  Minimum = %g\n", grid_range.Min());
    printf("  Maximum = %g\n", grid_range.Max());
    printf("  L1Norm = %g\n", mask->L1Norm());
    printf("  L2Norm = %g\n", mask->L2Norm());
    fflush(stdout);
  }
}



static void
MaskToCavities(R3Grid *mask, int threshold_type, RNScalar threshold_value,
  RNScalar min_cavity_volume, RNScalar max_cavity_volume, int max_cavities)
{
  // Start statistics
  RNTime start_time;
  start_time.Read();

  // Compute target cavity size
  int min_cavity_size = 0;
  int max_cavity_size = 0;
  if ((max_cavity_volume > 0) || (max_cavity_volume > 0)) {
    RNScalar world_grid_cell_volume = mask->GridToWorldScaleFactor();
    world_grid_cell_volume = world_grid_cell_volume * world_grid_cell_volume * world_grid_cell_volume;
    min_cavity_size = (int) (min_cavity_volume / world_grid_cell_volume);
    max_cavity_size = (int) (max_cavity_volume / world_grid_cell_volume);
  }

  // Create mask
  R3Grid cavity_mask(mask->XResolution(), mask->YResolution(), mask->ZResolution());
  cavity_mask.SetWorldToGridTransformation(mask->WorldToGridTransformation());

  // Create marks
  int *cavity_marks = new int [ cavity_mask.NEntries() ];
  assert(cavity_marks);
  for (int i = 0; i < cavity_mask.NEntries(); i++) {
    cavity_marks[i] = 0;
  }

  // Fill cavities
  int ncavities = 0;
  if (max_cavities == 0) max_cavities = INT_MAX;
  for (int i = 0; i < max_cavities; i++) {
    // Find best local maximum 
    int max_index = -1;
    RNScalar max_value = -FLT_MAX;
    for (int j = 0; j < mask->NEntries(); j++) {
      // Check mark
      if (cavity_marks[j] != 0) continue;
                                             
      // Check value
      RNScalar value = mask->GridValue(j);
      if (value == 0) continue;
      if  (value <= max_value) continue;

      // Check if local maximum
      int x, y, z;
      mask->IndexToIndices(j, x, y, z);
      if ((x > 0) && (value < mask->GridValue(x-1,y,z))) continue;
      if ((x < mask->XResolution()-1) && (value < mask->GridValue(x+1,y,z))) continue;
      if ((y > 0) && (value < mask->GridValue(x,y-1,z))) continue;
      if ((y < mask->YResolution()-1) && (value < mask->GridValue(x,y+1,z))) continue;
      if ((z > 0) && (value < mask->GridValue(x,y,z-1))) continue;
      if ((z < mask->ZResolution()-1) && (value < mask->GridValue(x,y,z+1))) continue;

      // Remember best seed
      max_value = value;
      max_index = j;
    }

    // Check if found maximum value
    if (max_index < 0) break;

    // Flood fill marking all grid entries 6-connected to max index
    int cavity_size = 0;
    RNHeap<const RNScalar *> heap(0, -1, FALSE);
    const RNScalar *grid_values = mask->GridValues();
    cavity_marks[max_index] = 1;
    heap.Push(&grid_values[max_index]);
    while (!heap.IsEmpty()) {
      // Pop top of heap
      const RNScalar *c = heap.Pop();

      // Get index
      int index = c - grid_values;
      assert(index >= 0);
      assert(index < cavity_mask.NEntries());
      assert(mask->GridValue(index) != 0);

      // Update cavity mask
      cavity_mask.SetGridValue(index, mask->GridValue(index));

      // Add neighbors to heap
      int x, y, z, neighbor;
      cavity_mask.IndexToIndices(index, x, y, z);
      if (x > 0) {
        cavity_mask.IndicesToIndex(x-1, y, z, neighbor);
        if ((cavity_marks[neighbor] == 0) && 
            (mask->GridValue(neighbor) != 0)) {
          heap.Push(&grid_values[neighbor]);
          cavity_marks[neighbor] = i+1;
        }
      }
      if (x < cavity_mask.XResolution()-1) {
        cavity_mask.IndicesToIndex(x+1, y, z, neighbor);
        if ((cavity_marks[neighbor] == 0) && 
            (mask->GridValue(neighbor) != 0)) {
          heap.Push(&grid_values[neighbor]);
          cavity_marks[neighbor] = i+1;
        }
      }
      if (y > 0) {
        cavity_mask.IndicesToIndex(x, y-1, z, neighbor);
        if ((cavity_marks[neighbor] == 0) && 
            (mask->GridValue(neighbor) != 0)) {
          heap.Push(&grid_values[neighbor]);
          cavity_marks[neighbor] = i+1;
        }
      }
      if (y < cavity_mask.YResolution()-1) {
        cavity_mask.IndicesToIndex(x, y+1, z, neighbor);
        if ((cavity_marks[neighbor] == 0) && 
            (mask->GridValue(neighbor) != 0)) { 
          heap.Push(&grid_values[neighbor]);
          cavity_marks[neighbor] = i+1;
        }
      }
      if (z > 0) {
        cavity_mask.IndicesToIndex(x, y, z-1, neighbor);
        if ((cavity_marks[neighbor] == 0) && 
            (mask->GridValue(neighbor) != 0)) {
          heap.Push(&grid_values[neighbor]);
          cavity_marks[neighbor] = i+1;
        }
      }
      if (z < cavity_mask.ZResolution()-1) {
        cavity_mask.IndicesToIndex(x, y, z+1, neighbor);
        if ((cavity_marks[neighbor] == 0) && 
            (mask->GridValue(neighbor) != 0)) {
          heap.Push(&grid_values[neighbor]);
          cavity_marks[neighbor] = i+1;
        }
      }

      // Update and check cavity size;
      cavity_size++;
      if (cavity_size > max_cavity_size) break; 
    }

    // Check if cavity was large enough
    if ((min_cavity_size > 0) && (cavity_size < min_cavity_size)) {
      // Zero out all cavity_mask entries from this cavity
      for (int j = 0; j < cavity_mask.NEntries(); j++) {
        if (cavity_marks[j] == i+1) cavity_mask.SetGridValue(j, 0);
      }
    }
    else {
      // Increment number of cavities
      ncavities++;
    }
  }

  // Apply mask
  mask->Mask(cavity_mask);

  // Print statistics
  if (print_verbose) {
    printf("Masked to cavity value .. \n");
    printf("  Time = %.2f seconds\n", start_time.Elapsed());
    printf("  Min cavity volume = %g\n", min_cavity_volume);
    printf("  Max cavity volume = %g\n", max_cavity_volume);
    printf("  Max cavities = %d\n", max_cavities);
    printf("  # Cavities = %d\n", ncavities);
    printf("  Cardinality = %d\n", mask->Cardinality());
    printf("  Volume = %g\n", mask->Volume());
    RNInterval grid_range = mask->Range();
    printf("  Minimum = %g\n", grid_range.Min());
    printf("  Maximum = %g\n", grid_range.Max());
    printf("  L1Norm = %g\n", mask->L1Norm());
    printf("  L2Norm = %g\n", mask->L2Norm());
    fflush(stdout);
  }
}







RNArray<PDBAtom *> *
FindProteinAtoms(PDBFile *file)
{
  // Start statistics
  RNTime start_time;
  start_time.Read();

  // Get model from PDB file
  if (file->NModels() == 0) return 0;
  PDBModel *model = file->Model(0);

  // Allocate array of atoms
  RNArray<PDBAtom *> *protein_atoms = new RNArray<PDBAtom *>();
  if (!protein_atoms) {
    fprintf(stderr, "Unable to allocate array of protein atoms.\n");
    return NULL;
  }

  // Add all hetatoms to array
  for (int i = 0; i < model->NResidues(); i++) {
    PDBResidue *residue = model->Residue(i);
    PDBAminoAcid *aminoacid = residue->AminoAcid();
    if (!aminoacid) continue;
    for (int j = 0; j < residue->NAtoms(); j++) {
      PDBAtom *atom = residue->Atom(j);
      if (atom->IsHetAtom()) continue;
      protein_atoms->Insert(atom);
    }
  }

  // Print statistics
  if (print_verbose) {
    printf("Found protein atoms ...\n");
    printf("  Time = %.2f seconds\n", start_time.Elapsed());
    printf("  # Atoms = %d\n", protein_atoms->NEntries());
    printf("  Volume = %g\n", Volume(*protein_atoms));
    fflush(stdout);
  }

  // Return protein atoms
  return protein_atoms;
}



RNArray<PDBAtom *> *
FindLigandAtoms(PDBFile *file, const char *ligand_name)
{
  // Start statistics
  RNTime start_time;
  start_time.Read();
  int residue_count = 0;

  // Get model from PDB file
  if (file->NModels() == 0) return 0;
  PDBModel *model = file->Model(0);

  // Allocate array of atoms
  RNArray<PDBAtom *> *ligand_atoms = new RNArray<PDBAtom *>();
  if (!ligand_atoms) {
    fprintf(stderr, "Unable to allocate array of ligand atoms.\n");
    return NULL;
  }

  // Check ligand name
  if (ligand_name) {
    // Find ligand
    PDBResidue *ligand = file->FindResidue(ligand_name);
    if (!ligand) {
      fprintf(stderr, "Unable to find ligand %s in %s\n", ligand_name, pdb_name); 
      return NULL;
    }

    // Add atoms of ligand to array
    residue_count = 1;
    for (int j = 0; j < ligand->NAtoms(); j++) {
      PDBAtom *atom = ligand->Atom(j);
      ligand_atoms->Insert(atom);
    }
  }
  else {
    // Add all hetatoms to array
    for (int i = 0; i < model->NResidues(); i++) {
      PDBResidue *residue = model->Residue(i);
      RNBoolean found = FALSE;
      for (int j = 0; j < residue->NAtoms(); j++) {
        PDBAtom *atom = residue->Atom(j);
        if (!atom->IsHetAtom()) continue;
        ligand_atoms->Insert(atom);
        found = TRUE;
      }
      if (found) residue_count++;
    }
  }

  // Print statistics
  if (print_verbose) {
    printf("Found ligand atoms ...\n");
    printf("  Time = %.2f seconds\n", start_time.Elapsed());
    printf("  # Ligands = %d\n", residue_count);
    printf("  # Atoms = %d\n", ligand_atoms->NEntries());
    printf("  Volume = %g\n", Volume(*ligand_atoms));
    fflush(stdout);
  }

  // Return ligand atoms
  return ligand_atoms;
}



R3Grid * 
ExtractPockets(PDBFile *file, R3Grid *grid, const RNArray<PDBAtom *> *protein_atoms, const RNArray<PDBAtom *> *ligand_atoms)
{
  // Determine number of cavities
  if (max_cavities < 0) max_cavities = NumConnectedComponents(*ligand_atoms);

  // Determine max_total_volume as fraction of ligand or protein
  if ((max_total_volume_as_fraction_of_ligand > 0) && (max_total_volume_as_fraction_of_ligand < RN_INFINITY)) {
    max_total_volume = max_total_volume_as_fraction_of_ligand * Volume(*ligand_atoms);
  }
  else if ((max_total_volume_as_fraction_of_protein > 0) && (max_total_volume_as_fraction_of_protein < RN_INFINITY)) {
    max_total_volume = max_total_volume_as_fraction_of_protein * Volume(*protein_atoms);
  }

  // Allocate mask
  R3Grid *mask = new R3Grid(*grid);
  if (!mask) {
    fprintf(stderr, "Unable to allocate mask\n");
    exit(-1);
  }

  // Blur 
  if (pocket_sigma1 > 0) {
    Blur(mask, pocket_sigma1);
  }

  // Mask to spherical region
  if (world_radius > 0) {
    MaskToSphere(mask, world_center, world_radius);
  }

  // Mask to offset from protein
  if (protein_atoms && 
      ((min_protein_offset > -RN_INFINITY) || (max_protein_offset < RN_INFINITY) || 
       ((interior_protein_sigma > 0) && (exterior_protein_sigma > 0)))) {
    MaskToOffset(mask, *protein_atoms, min_protein_offset, max_protein_offset, 
      ideal_protein_offset, interior_protein_sigma, exterior_protein_sigma);
  }

  // Mask to offset from ligand
  if (ligand_atoms && 
      ((min_ligand_offset > -RN_INFINITY) || (max_ligand_offset < RN_INFINITY) || 
       ((interior_ligand_sigma > 0) && (exterior_ligand_sigma > 0)))) {
    MaskToOffset(mask, *ligand_atoms, min_ligand_offset, max_ligand_offset, 
      ideal_ligand_offset, interior_ligand_sigma, exterior_ligand_sigma);
  }

  // Mask to threshold
  if (pocket_threshold_type != 0) {
    MaskToThreshold(mask, pocket_threshold_type, pocket_threshold);
  }

  // MaskToTotalVolume executes MaskToCavityRadius, MaskToCavityVolume, and MaskToLargestCavities
  if ((max_total_volume > 0) && (max_total_volume < RN_INFINITY)) {
    // Mask by total volume
    MaskToTotalVolume(mask, max_total_volume, min_cavity_radius, min_cavity_volume, max_cavities);
  }
  else if ((max_cavity_volume > 0) && (max_cavity_volume < RN_INFINITY)) {
    // Mask by cavity radius
    if (min_cavity_radius > 0) {
      MaskToCavityRadius(mask, min_cavity_radius);
    }

    // Mask by cavity analysis
    MaskToCavities(mask, pocket_threshold_type, pocket_threshold, min_cavity_volume, max_cavity_volume, max_cavities);
  }
  else {
    // Mask by cavity radius
    if (min_cavity_radius > 0) {
      MaskToCavityRadius(mask, min_cavity_radius);
    }

    // Mask by cavity volume
    if (min_cavity_volume > 0) {
      MaskToCavityVolume(mask, min_cavity_volume);
    }

    // Mask to largest cavity only
    if (max_cavities > 0) {
      MaskToLargestCavities(mask, max_cavities);
    }
  }

  // Replace values in grid by ranks
  if (cavity_rank_method > 0) {
    RankCavities(file, mask, cavity_rank_method);
  }

  // Blur 
  if (pocket_sigma2 > 0) {
    Blur(mask, pocket_sigma2);
  }

  // Normalize
  if (normalization_type > 0) {
    Normalize(mask, normalization_type);
  }

  // Fix mask, if empty now
  if (mask->Cardinality() == 0) {
    // Find maximum value in original grid
    int max_index = -1;
    RNScalar max_value = -RN_INFINITY;
    for (int i = 0; i < grid->NEntries(); i++) {
      RNScalar value = grid->GridValue(i);
      if (value > max_value) {
        max_value = value;
        max_index = i;
      }
    }

    // Set single point at maximum value in original grid
    if (max_index >= 0) mask->SetGridValue(max_index, max_value);
  }

  // Return mask
  return mask;
}
