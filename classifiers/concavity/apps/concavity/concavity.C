/******************************************************************************
 * concavity.C -  Copyright (c) 2009 Thomas Funkhouser and John A. Capra
 *
 *  This program implements ConCavity, a set of algorithms for
 *  identifying ligand binding sites in protein 3D structures. 
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
 *  Basic Usage:
 *  concavity [options] pdb_file output_name
 *  
 *  for example:
 *  concavity -conservation conservation_data/1G6C 1G6C.pdb test1
 *  
 *  See README.txt and the code for more information.
 *
 *
 *  - Tony Capra (tonyc@cs.princeton.edu)
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


#include "R3Shapes/R3Shapes.h"
#include "PDB/PDB.h"

#include "grid_creation.h"
#include "pocket_extraction.h"

// Program variables

char *pdb_name = NULL;
char *output_basename = NULL;

int print_verbose = 0;

int print_grid_raw = 0;
int print_grid_dx = 1;
int print_grid_pdb = 0;
int print_grid_txt = 0;

int pymol_script = 1;
int pymol_pocket_script = 0;
int pymol_residue_script = 0;
int pymol_image_res = 1200; 

// grid creation variables
static char *grid_method = "ligsite"; 
// valid options: ligsite, surfnet, pocketfinder, or custom

char *conservation_file = NULL;
char *conservation_type = NULL; // one of: geo_mean, arith_mean, exp, exp2
char *conservation_file_source = "jsd"; // used in constructing file name


int grid_resolution[3] = { 0, 0, 0 };
int max_grid_resolution = 256;
RNLength grid_spacing = 1;
R3Point *world_center = NULL;
RNScalar world_radius = 0;
RNScalar world_border = 0;
RNScalar grid_threshold = 0;


// Pocket Extraction variables
static char *extraction_method = "search";
// valid options: search, topn, custom

char *ligand_name = NULL;
RNScalar pocket_sigma1 = 0;
RNScalar pocket_sigma2 = 0;
RNScalar min_cavity_radius = 0;
RNScalar min_cavity_volume = 0;
RNScalar max_cavity_volume = 0;
RNScalar max_total_volume = 0;
RNScalar max_total_volume_as_fraction_of_ligand = 0;
RNScalar max_total_volume_as_fraction_of_protein = 0;
RNScalar min_protein_offset = -RN_INFINITY;
RNScalar max_protein_offset = RN_INFINITY;
RNScalar ideal_protein_offset = 1.5;
RNScalar interior_protein_sigma = 0;
RNScalar exterior_protein_sigma = 0;
RNScalar min_ligand_offset = -RN_INFINITY;
RNScalar max_ligand_offset = RN_INFINITY;
RNScalar ideal_ligand_offset = 1.5;
RNScalar interior_ligand_sigma = 0;
RNScalar exterior_ligand_sigma = 0;
int pocket_threshold_type = 0; // 0=none, 1=absolute, 2=stddev, 3=percentile
RNScalar pocket_threshold = 0;
int cavity_rank_method = 0;
int normalization_type = 0;
int max_cavities = 0;


// Residue Mapping variables
static char *res_map_method = "blur";
// valid options: blur, dist, dist-thresh, custom

static RNLength max_distance = 0;
static RNLength res_map_sigma = 4;
int values_from_world = 1;  // 0 = set residue values from grid vals
			    // (only applies to dist res map methods)


//******************************************************************************


static PDBFile *
ReadPDB(char *filename)
{
  // Start statistics
  RNTime start_time;
  start_time.Read();

  // Allocate PDBFile
  PDBFile *file = new PDBFile(filename);
  if (!file) {
    RNFail("Unable to allocate PDB file for %s", filename);
    return NULL;
  }

  // Read PDB file
  if (!file->ReadFile(filename)) return 0;

  // Print statistics
  if (print_verbose) {
    printf("Read PDB file ...\n");
    printf("  Time = %.2f seconds\n", start_time.Elapsed());
    for (int i =0; i < file->NModels(); i++) {
      PDBModel *model = file->Model(i);
      printf("  Model %s ...\n", model->Name());
      printf("  # Chains = %d\n", model->NChains());
      printf("  # Residues = %d\n", model->NResidues());
      printf("  # Atoms = %d\n", model->NAtoms());
    }
    fflush(stdout);
  }

  // Return success
  return file;
}



static int
ReadJsdFiles(PDBFile *file, char *jsd_basename, char *conservation_file_source)
{
  // Check number of models
  if (file->NModels() < 1) {
    fprintf(stderr, "File must have at least one model to read conservation scores: %s.\n", jsd_basename);
    return 0;
  }

  // Start statistics
  RNTime start_time;
  start_time.Read();

  // Read conservation files
  int nresidues = file->ReadJsdFiles(jsd_basename, conservation_file_source);

  // Print statistics
  if (print_verbose && (nresidues > 0)) {
    printf("Read jsd files ...\n");
    printf("  Time = %.2f seconds\n", start_time.Elapsed());
    printf(" # Residues = %d\n", nresidues);
    fflush(stdout);
  } 

  if (!(nresidues > 0)) { 
    printf("ERROR: Could not read conservation files ...\n");
    return 0;
  }

  // Return success
  return 1;
}





static int 
WriteGrid(R3Grid *grid, const char *grid_name, const char *grid_format)
{
  // Start statistics
  RNTime start_time;
  start_time.Read();

  int status = 0;
  // Write grid
  if (!strcmp(grid_format, "grd")){
    status = grid->WriteFile(grid_name);
  }
  else if (!strcmp(grid_format, "dx")){
    status = grid->WriteGridDXFile(grid_name);
  }
  else if (!strcmp(grid_format, "pdb")){
    status = grid->WriteGridPDBFile(grid_name);
  }
  else if (!strcmp(grid_format, "txt")){
    FILE *fp = fopen(grid_name, "w");
    status = grid->WriteText(fp);
  }

  // Print statistics
  if (print_verbose) {
    printf("Wrote grid ...\n");
    printf("  Time = %.2f seconds\n", start_time.Elapsed());
    printf("  # Bytes = %d\n", (int) (status * sizeof(RNScalar)));
    fflush(stdout);
  }

  // Return status
  return status;
}


static int 
WriteResidueScores(PDBFile *file, R3Grid *grid, RNLength max_distance, RNLength sigma, bool mask_values, char *basename, char *preamble)
{
  // Start statistics
  RNTime start_time;
  start_time.Read();

  // Get model
  if (file->NModels() == 0) return 0;
  PDBModel *model = file->Model(0);

  // Blur grid
  if (sigma > 0) {
    grid->Blur(sigma * grid->WorldToGridScaleFactor());
  }
  else if (max_distance > 0) {
  // or consider residues within max_distance

    if (mask_values){     // assign grid values to residues
      RNScalar max_grid_distance = max_distance * grid->WorldToGridScaleFactor();
      RNScalar threshold = max_grid_distance * max_grid_distance;
      R3Grid dgrid(*grid);
      grid->Voronoi(&dgrid);
      dgrid.Threshold(threshold, 1, 0);
      grid->Mask(dgrid);

    } else {       // give thresholded scores to residues
      RNScalar max_grid_distance = max_distance * grid->WorldToGridScaleFactor();
      RNScalar threshold = max_grid_distance * max_grid_distance;
      grid->SquaredDistanceTransform();
      grid->Threshold(threshold, 1, 0);
    }
  }


  char pdb_id[1024];
  // note that .pdb has already been removed
  const char *s = strrchr(file->Name(), '/');
  (s) ? strcpy(pdb_id, s + 1) : strcpy(pdb_id, file->Name());

  // Write a JSD file for each chain
  for (int i = 0; i < model->NChains(); i++) {
    PDBChain *chain = model->Chain(i);

    // Count residues
    int nresidues = 0;
    for (int j = 0; j < chain->NResidues(); j++) {
      PDBResidue *residue = chain->Residue(j);
      PDBAminoAcid *aminoacid = residue->AminoAcid();

      //if (residue->HasHetAtoms()) continue;

      if (residue->HasHetAtoms()) {
	// set all HETATM tempFactors to zero for consistency
	for (int k = 0; k < residue->NAtoms(); k++) {
	  PDBAtom *atom = residue->Atom(k);
	  if (atom->IsHetAtom()) atom->tempFactor = 0.0;
	}

	continue;
      }

      if (!aminoacid) continue;
      nresidues++;
    }

    // Check if protein has any residues
    if (nresidues == 0) continue;

    // Set filename
    char filename[1024];
    const char *chain_name = (strcmp(chain->Name(), " ")) ? chain->Name() : "A";

    sprintf(filename, "%s_%s_%s.scores", pdb_id, chain_name, basename);

    // Open output file for chain
    FILE *fp = fopen(filename, "w");
    if (!fp) {
      fprintf(stderr, "Unable to open output score file: %s\n", filename);
      return 0;
    }

    fprintf(fp, "# %s\n", filename);
    fprintf(fp, "# %s\n\n", preamble);


    // Write residues to file
    for (int j = 0; j < chain->NResidues(); j++) {
      PDBResidue *residue = chain->Residue(j);
      
      if (residue->HasHetAtoms()) continue;

      // Get amino acid letter
      PDBAminoAcid *aminoacid = residue->AminoAcid();
      if (!aminoacid) continue;

      // // Compute "conservation" at centroid
      // R3Point residue_centroid = residue->Centroid();
      // RNScalar conservation = grid->WorldValue(residue_centroid);

      // Compute "conservation" as max at atom
      RNScalar conservation = 0;
      for (int k = 0; k < residue->NAtoms(); k++) {
        PDBAtom *atom = residue->Atom(k);

	RNScalar value = -1E6;
	if (values_from_world){
	  value = grid->WorldValue(atom->Position());
	} else {
	  R3Point grid_position = grid->GridPosition(atom->Position());
	  int ix = (int) (grid_position.X() + 0.5);
	  int iy = (int) (grid_position.Y() + 0.5);
	  int iz = (int) (grid_position.Z() + 0.5);
	  value = grid->GridValue(ix, iy, iz);
	}

        if (value > conservation) conservation = value;
      }

      // Write residue to file
      //fprintf(fp, "%d %c %g 0/0\n", j+1, aminoacid->Letter(), conservation);
      fprintf(fp, "%d %c %g\n", j+1, aminoacid->Letter(), conservation);


      // put score in each atom's TempFactor field for printing
      // *_residue.pdb file
      for (int k = 0; k < residue->NAtoms(); k++) {
	PDBAtom *atom = residue->Atom(k);

	atom->tempFactor = conservation;
      }

    }

    // Close JSD file for chain
    fclose(fp);
  }


  // Write pdb file with score in Temp Factor field of each atom.
  char res_pred_filename[1024];
  sprintf(res_pred_filename, "%s_%s_residue.pdb", pdb_id, basename);
  
  file->WriteFile(res_pred_filename);
  

  // Print statistics
  if (print_verbose) {
    printf("Wrote residues score files from grid ...\n");
    printf("  Time = %.2f seconds\n", start_time.Elapsed());
    printf("  # Chains = %d\n", model->NChains());
    printf("  # Residues = %d\n", model->NResidues());
    printf("  Max distance = %g\n", max_distance);
    printf("  Sigma = %g\n", sigma);
    printf("  Grid:\n");
    printf("    Resolution = %d %d %d\n", grid->XResolution(), grid->YResolution(), grid->ZResolution());
    printf("    Spacing = %g\n", grid->GridToWorldScaleFactor());
    printf("    Cardinality = %d\n", grid->Cardinality());
    printf("    Volume = %g\n", grid->Volume());
    RNInterval grid_range = grid->Range();
    printf("    Minimum = %g\n", grid_range.Min());
    printf("    Maximum = %g\n", grid_range.Max());
    printf("    L1Norm = %g\n", grid->L1Norm());
    printf("    L2Norm = %g\n", grid->L2Norm());
    fflush(stdout);
  }

  // Return OK status
  return 1;
}




static int 
ParseArgs(int argc, char **argv)
{
  // Check number of arguments
  if (argc < 3) {
    printf("Usage: concavity [options] pdbfile output_name\n");
    exit(0);
  }

  // Parse arguments
  argc--; argv++;
  while (argc > 0) {
    if ((*argv)[0] == '-') {

      if (!strcmp(*argv, "-v")) { 
        print_verbose = 1; 
      }
      else if (!strcmp(*argv, "-print_grid_raw")) { 
	argc--; argv++; print_grid_raw = atoi(*argv);
      }
      else if (!strcmp(*argv, "-print_grid_dx")) { 
	argc--; argv++; print_grid_dx = atoi(*argv);
      }
      else if (!strcmp(*argv, "-print_grid_pdb")) { 
	argc--; argv++; print_grid_pdb = atoi(*argv);
      }
      else if (!strcmp(*argv, "-print_grid_txt")) { 
	argc--; argv++; print_grid_txt = atoi(*argv);
      }
      else if (!strcmp(*argv, "-pymol_script")) { 
	argc--; argv++; pymol_script = atoi(*argv);
      }
      else if (!strcmp(*argv, "-pymol_pocket_script")) { 
	argc--; argv++; pymol_pocket_script = atoi(*argv);
      }
      else if (!strcmp(*argv, "-pymol_residue_script")) { 
	argc--; argv++; pymol_residue_script = atoi(*argv);
      }
      else if (!strcmp(*argv, "-pymol_image_res")) { 
	argc--; argv++; pymol_image_res = atoi(*argv);
      }

      // Grid Creation Options

      else if (!strcmp(*argv, "-grid_method")){
	argc--; argv++; grid_method = *argv;
      }
      else if (!strcmp(*argv, "-grid_threshold")) { 
        argc--; argv++; grid_threshold = atof(*argv); 
      }
      else if (!strcmp(*argv, "-conservation")) {
        argc--; argv++; conservation_file = *argv;
      }
      else if (!strcmp(*argv, "-conservation_file_source")) {
        argc--; argv++; conservation_file_source = *argv;
      }
      else if (!strcmp(*argv, "-conservation_type")) { 
        argc--; argv++;	conservation_type = *argv; 
      }

      // Pocket Extraction options

      else if (!strcmp(*argv, "-extraction_method")){
	argc--; argv++; extraction_method = *argv;
      }
      else if (!strcmp(*argv, "-ligand")) { 
	argc--; argv++; ligand_name = *argv; 
      }
      else if (!strcmp(*argv, "-normalize")) {
        argc--; argv++; normalization_type = atoi(*argv); 
      }
      else if (!strcmp(*argv, "-pocket_sigma1")) { 
	argc--; argv++; pocket_sigma1 = atof(*argv); 
      }
      else if (!strcmp(*argv, "-pocket_sigma2")) { 
	argc--; argv++; pocket_sigma2 = atof(*argv); 
      }
      else if (!strcmp(*argv, "-min_protein_offset")) { 
	argc--; argv++; min_protein_offset = atof(*argv); 
      }
      else if (!strcmp(*argv, "-max_protein_offset")) { 
	argc--; argv++; max_protein_offset = atof(*argv); 
      }
      else if (!strcmp(*argv, "-min_ligand_offset")) { 
	argc--; argv++; min_ligand_offset = atof(*argv); 
      }
      else if (!strcmp(*argv, "-max_ligand_offset")) { 
	argc--; argv++; max_ligand_offset = atof(*argv); 
      }
      else if (!strcmp(*argv, "-max_cavities")) { 
	argc--; argv++; max_cavities = atoi(*argv); 
      }
      else if (!strcmp(*argv, "-cavity_rank_method")) { 
	argc--; argv++; cavity_rank_method = atoi(*argv); 
      }
      else if (!strcmp(*argv, "-pocket_threshold_type")) { 
	argc--; argv++; pocket_threshold_type = atoi(*argv); 
      }
      else if (!strcmp(*argv, "-pocket_threshold")) { 
	argc--; argv++; pocket_threshold = atof(*argv); 
      }
      else if (!strcmp(*argv, "-min_cavity_radius")) { 
        argc--; argv++; min_cavity_radius = atof(*argv); 
      }
      else if (!strcmp(*argv, "-min_cavity_volume")) { 
        argc--; argv++; min_cavity_volume = atof(*argv); 
      }
      else if (!strcmp(*argv, "-max_cavity_volume")) { 
        argc--; argv++; max_cavity_volume = atof(*argv); 
      }
      else if (!strcmp(*argv, "-max_total_volume")) { 
        argc--; argv++; max_total_volume = atof(*argv); 
      }
      else if (!strcmp(*argv, "-max_total_volume_as_fraction_of_ligand")) {
        argc--; argv++; max_total_volume_as_fraction_of_ligand = atof(*argv); 
      }
      else if (!strcmp(*argv, "-max_total_volume_as_fraction_of_protein")) { 
        argc--; argv++; max_total_volume_as_fraction_of_protein = atof(*argv); 
      }

      // Residue Mapping options
      else if (!strcmp(*argv, "-res_map_method")){
	argc--; argv++; res_map_method = *argv;
      }
      else if (!strcmp(*argv, "-res_map_sigma")) {
        argc--; argv++; res_map_sigma = atof(*argv); 
      }
      else if (!strcmp(*argv, "-max_distance")) { 
        argc--; argv++; max_distance = atof(*argv); 
      }
      else if (!strcmp(*argv, "-values_from_world")) { 
        argc--; argv++; values_from_world = atoi(*argv); 
      }


      // Generic options:

      else if (!strcmp(*argv, "-radius")) { 
        argc--; argv++; world_radius = atof(*argv); 
      }
      else if (!strcmp(*argv, "-center")) { 
        world_center = new R3Point();
        argc--; argv++; (*world_center)[0] = atof(*argv); 
        argc--; argv++; (*world_center)[1] = atof(*argv); 
        argc--; argv++; (*world_center)[2] = atof(*argv); 
      }
      else if (!strcmp(*argv, "-resolution")) { 
        argc--; argv++; grid_resolution[0] = atoi(*argv); 
        argc--; argv++; grid_resolution[1] = atoi(*argv); 
        argc--; argv++; grid_resolution[2] = atoi(*argv); 
      }
      else if (!strcmp(*argv, "-max_resolution")) { 
        argc--; argv++; max_grid_resolution = atoi(*argv); 
      }
      else if (!strcmp(*argv, "-spacing")) { 
        argc--; argv++; grid_spacing = atof(*argv); 
      }
      else if (!strcmp(*argv, "-border")) { 
        argc--; argv++; world_border = atof(*argv); 
      }
      else { 
        fprintf(stderr, "Invalid program argument: %s\n", *argv); 
        return 0;
      }
    }
    else {
      if (!pdb_name) pdb_name = *argv;
      else if (!output_basename) output_basename = *argv;
      else { 
        fprintf(stderr, "Invalid program argument: %s\n", *argv); 
        return 0;
      }
    }
    argv++; argc--;
  }

  // Check pdb filename
  if (!pdb_name) {
    fprintf(stderr, "You did not specify a pdb file.\n");
    return 0;
  }

  // Check output filename
  if (!output_basename) {
    fprintf(stderr, "You did not specify an output name.\n");
    return 0;
  }

  // Check grid resolution
  if ((grid_resolution[0] < 0) || (grid_resolution[1] < 0) || (grid_resolution[2] < 0)) {
    fprintf(stderr, "Invalid grid resolution: %d %d %d\n", grid_resolution[0], grid_resolution[1], grid_resolution[2]);
    return 0;
  }

  // Return OK status 
  return 1;
}



int 
main(int argc, char **argv)
{

  // Save command issued to preamble string
  char command_issued[2048] = "concavity ";
  int num_args = argc;
  char **args = argv;
  num_args--; args++;
  while (num_args > 0) {
    strcat(command_issued, *args);
    strcat(command_issued, " ");
    num_args--; args++;
  }

  // Parse program arguments
  if (!ParseArgs(argc, argv)) exit(-1);

  // Read PDB file
  PDBFile *pdb_file = ReadPDB(pdb_name);
  if (!pdb_file) exit(-1);

  // Get pdb_id
  char pdb_id[1024];
  char *s = strrchr(pdb_name, '/');
  (s) ? strcpy(pdb_id, s + 1) : strcpy(pdb_id, pdb_name);
  pdb_id[strlen(pdb_id) - 4] = '\0';


  // Read conservation files
  if (conservation_file) {
    int status = ReadJsdFiles(pdb_file, conservation_file, conservation_file_source);
    if (!status) exit(-1);
  }

  // Create grid 
  R3Grid *grid = NULL;

  if (!strcmp(grid_method, "ligsite")){
    // set default conservation integration type
    if (conservation_file && !conservation_type){ conservation_type = "arith_mean"; }

    grid = LigsiteGrid(pdb_file);
  }
  else if (!strcmp(grid_method, "pocketfinder")){
    if (conservation_file && !conservation_type){ conservation_type = "arith_mean"; }

    grid = PocketfinderGrid(pdb_file);
  }
  else if (!strcmp(grid_method, "surfnet")){
    if (conservation_file && !conservation_type){ conservation_type = "exp2"; }

    grid = SurfnetGrid(pdb_file);
  }
  if (!grid) exit(-1);

  
  // Extract pockets from grid.

  // Find protein atoms
  RNArray<PDBAtom *> *protein_atoms = FindProteinAtoms(pdb_file);
  if (!protein_atoms) exit(-1);

  // Find ligand atoms
  RNArray<PDBAtom *> *ligand_atoms = FindLigandAtoms(pdb_file, ligand_name);
  if (!ligand_atoms) exit(-1);

  // Prepare extraction mask parameters
  //    unless they have been explicitly changed, we set to default for method
  if (!strcmp(extraction_method, "search")){

    if (min_protein_offset == -RN_INFINITY){ min_protein_offset = 0; }
    if (max_protein_offset == RN_INFINITY){ max_protein_offset = 5; }
    if (min_ligand_offset == -RN_INFINITY){ min_ligand_offset = -1.0E6; }
    if (max_ligand_offset == RN_INFINITY){ max_ligand_offset = 1.0E6; }
    if (min_cavity_radius == 0){ min_cavity_radius = 1; }
    if (min_cavity_volume == 0){ min_cavity_volume = 100; }
    if (max_total_volume_as_fraction_of_protein == 0){ max_total_volume_as_fraction_of_protein = 0.02; }

    if (!strcmp(grid_method, "pocketfinder")) {
      // as in An05
      if (pocket_sigma1 == 0) { pocket_sigma1 = 2.6; }
    }
    else if (!strcmp(grid_method, "ligsite")) {
      // search for score threshold doesn't work well on integer valued grid
      if (pocket_sigma1 == 0) { pocket_sigma1 = 1; }
    }

  }
  else if (!strcmp(extraction_method, "topn")){

    // default to top3 if n not spec
    if (max_cavities == 0) { max_cavities = 3; }

    if (min_protein_offset == -RN_INFINITY){ min_protein_offset = -1.0E6; }
    if (max_protein_offset == RN_INFINITY){ max_protein_offset = 1.0E6; }
    if (min_ligand_offset == -RN_INFINITY){ min_ligand_offset = -1.0E6; }
    if (max_ligand_offset == RN_INFINITY){ max_ligand_offset = 1.0E6; }
    
    //if (min_cavity_radius == 0){ min_cavity_radius = 1.4; }  // makes ligsite more like ligsiteCS

    if (!strcmp(grid_method, "ligsite")) {
      if (pocket_threshold == 0){ pocket_threshold = 5.5; }
      if (pocket_threshold_type == 0){ pocket_threshold_type = 1; }
    } else {
      // if theshold not specified, use 3 std dev.
      if (pocket_threshold == 0){ pocket_threshold = 3.0; }
      if (pocket_threshold_type == 0){ pocket_threshold_type = 2; }

      // or could take top 10 percent or whatever else seems reasonable
      //if (pocket_threshold == 0){ pocket_threshold = .9; }
      //if (pocket_threshold_type == 0){ pocket_threshold_type = 3; }

    }

  }    
  else if (!strcmp(extraction_method, "custom")){
    // entirely user specified parameters
  }


  // Extract pockets
  R3Grid *pocket_grid;
  if (strcmp(extraction_method, "none")) {
    pocket_grid = ExtractPockets(pdb_file, grid, protein_atoms, ligand_atoms);
  } else {
    pocket_grid = grid;
  }
  if (!pocket_grid) exit(-1);


  // Write grid 
  //   we print before the residue mapping because it may change the grid
  if (print_grid_raw || print_grid_dx || print_grid_pdb || print_grid_txt) {
    char grid_outfile[1024];

    if (print_grid_raw){
      sprintf(grid_outfile, "%s_%s.grd", pdb_id, output_basename);
      int status = WriteGrid(pocket_grid, grid_outfile, "grd");
      if (!status) exit(-1);
    }
    if (print_grid_dx){
      sprintf(grid_outfile, "%s_%s.dx", pdb_id, output_basename);
      int status = WriteGrid(pocket_grid, grid_outfile, "dx");
      if (!status) exit(-1);
    }
    if (print_grid_pdb){
      sprintf(grid_outfile, "%s_%s_pocket.pdb", pdb_id, output_basename);
      int status = WriteGrid(pocket_grid, grid_outfile, "pdb");
      if (!status) exit(-1);
    }
    if (print_grid_txt){
      sprintf(grid_outfile, "%s_%s.grdtxt", pdb_id, output_basename);
      int status = WriteGrid(pocket_grid, grid_outfile, "txt");
      if (!status) exit(-1);
    }


  }


  // Residue Mapping

  //     The parameters set here override the command line because
  //     they determine the code run in WriteResidueScores.
  bool mask_values = true;
  if (!strcmp(res_map_method, "blur")){
    max_distance = 0;  // make sure
  }
  else if (!strcmp(res_map_method, "dist")){
    if (max_distance == 0) { max_distance = 5; }
    mask_values = true;

    res_map_sigma = 0;
  }
  else if (!strcmp(res_map_method, "dist-thresh")){
    if (max_distance == 0) { max_distance = 5; }
    mask_values = false;

    res_map_sigma = 0;
  }
  else if (!strcmp(res_map_method, "custom")){

  }


  // Compute residue scores and write files
  //   - score files for each chain
  //   - a pdb file with the scores in the temp. factor field
  if (strcmp(res_map_method, "none")){
    int status = WriteResidueScores(pdb_file, pocket_grid, max_distance, res_map_sigma, mask_values, output_basename, command_issued);
    if (!status) exit(-1);
  }


  // write pymol visualization script(s)
  if (pymol_script){

    char pymol_script_name[256];
    sprintf(pymol_script_name, "%s_%s.pml", pdb_id, output_basename);

    FILE *py_fp = fopen(pymol_script_name, "w");
    if (!py_fp) {
      fprintf(stderr, "Unable to write pymol script file: %s\n", pymol_script_name);
      return 0;
    }

    // for users
    fprintf(py_fp, "load %s_%s_residue.pdb\n\nbg white\nset ray_shadow=0\nset depth_cue=0\nset ray_trace_fog=0\n\nhide everything\nremove resn hoh\n\nselect backbone, name c+n+o+ca and !het\ndeselect\n\nselect prot, !het\ndeselect\n\ncmd.spectrum('b', 'blue_white_red', selection='prot')\n\ncolor yellow, het\nshow sticks, het\nshow spheres, backbone\n\nload %s_%s.dx, grid_map\nisomesh grid_mesh, grid_map, 0.0\ncolor green, grid_mesh\n\norient\nzoom grid_mesh\n\n#ray %d, %d\n#png %s_%s.png\n", pdb_id, output_basename, pdb_id, output_basename, pymol_image_res, pymol_image_res, pdb_id, output_basename);

    fclose(py_fp);

  }

  if (pymol_pocket_script){

    char pymol_pocket_script_name[256];
    sprintf(pymol_pocket_script_name, "%s_%s_pocket.pml", pdb_id, output_basename);

    FILE *py_fp = fopen(pymol_pocket_script_name, "w");
    if (!py_fp) {
      fprintf(stderr, "Unable to write pymol script file: %s\n", pymol_pocket_script_name);
      return 0;
    }

    fprintf(py_fp, "load %s_%s_residue.pdb\n\nbg white\nset ray_shadow=0\nset depth_cue=0\nset ray_trace_fog=0\n\nhide everything\nremove resn hoh\n\nselect prot, !het\ndeselect\n\ncolor blue, prot\nshow cartoon, prot\n\nset stick_width, .5\ncolor yellow, het\nshow sticks, het\n\nload %s_%s.dx, grid_map\nset mesh_width, .5\nisomesh grid_mesh, grid_map, 0.0\ncolor red, grid_mesh\n\norient prot\nzoom prot\n\nray %d, %d\npng %s_%s_pocket.png\nray 300, 300\npng %s_%s_pocket_thumb.png\n", pdb_id, output_basename, pdb_id, output_basename, pymol_image_res, pymol_image_res, pdb_id, output_basename, pdb_id, output_basename);

    fclose(py_fp);

  }

  if (pymol_residue_script){

    char pymol_residue_script_name[256];
    sprintf(pymol_residue_script_name, "%s_%s_residue.pml", pdb_id, output_basename);

    FILE *py_fp = fopen(pymol_residue_script_name, "w");
    if (!py_fp) {
      fprintf(stderr, "Unable to write pymol script file: %s\n", pymol_residue_script_name);
      return 0;
    }

    fprintf(py_fp, "load %s_%s_residue.pdb\n\nbg white\nset ray_shadow=0\nset depth_cue=0\nset ray_trace_fog=0\n\nhide everything\nremove resn hoh\n\nselect backbone, name c+n+o+ca and !het\ndeselect\n\nselect prot, !het\ndeselect\n\ncmd.spectrum('b', 'blue_white_red', selection='prot')\nshow spheres, backbone\n\nset stick_width, .5\ncolor yellow, het\nshow sticks, het\norient prot\nzoom prot\n\nray %d, %d\npng %s_%s_residue.png\nray 300, 300\npng %s_%s_residue_thumb.png\n", pdb_id, output_basename, pymol_image_res, pymol_image_res, pdb_id, output_basename, pdb_id, output_basename);

    fclose(py_fp);

  }


  // Return success
  return 0;
}

