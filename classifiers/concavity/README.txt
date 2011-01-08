ConCavity v0.1 -- 12/04/09 -- Last Update: 11/05/10
Copyright (c) 2009  John A. Capra and Thomas Funkhouser.

Thank you for downloading ConCavity.  The ConCavity algorithm is
described in:

Predicting Protein Ligand Binding Sites by Combining Evolutionary
Sequence Conservation and 3D Structure Capra JA, Laskowski RA,
Thornton JM, Singh M, and Funkhouser TA.  PLoS Comput Biol 5(12).

If you use this program, please cite the paper.

More information about the project and precomputed predictions for
nearly all structures in the PQS (PDB) can be found at the supporting
web site: http://compbio.cs.princeton.edu/concavity/

The program is free software distributed under the GNU Public License
(GPL) (see COPYING).


--- Revision History ---

12/15/10
- Fixed string conversion bug under GCC 4.4.

11/05/10
- Added pocket number data to -print_pdb_grid output.
- Updated README.txt.

12/04/09
- Fixed Mac OS freeglut compilation error.


--- Installation --- 

The root directory contains all code for the ConCavity program.  There
are several subdirectories:

    pkgs - source and include files for all packages (software
        libraries used by ConCavity).
    apps - source files for concavity and related programs. 
    lib - archive library (.lib) files.
    bin - executable files.
    scripts - make files. 
    examples - example data and result files

If you are using Mac OS X, linux, or cygwin and have gcc installed,
you should be able to compile the code by typing "make clean; make" in
this directory.  The scripts file has the basic Makefiles which could
be edited for other operating systems and compilers.

After compiling the code, concavity should be in the appropriate
subdirectory of bin/.  concavity is the main program for predicting
binding sites.  You can either add this directory to your PATH or move
concavity to a directory in your PATH.


--- Quick Start ---

concavity takes as input a PDB format protein structure and
(optionally) files that characterize the evolutionary sequence
conservation of the chains in the structure file.  A sample PQS
structure file (1G6C.pdb) can be found in the examples/ directory.
Conservation files for this structure are in the
examples/conservation_data/ directory.

The simplest way to predict binding sites is to type (in the examples/
directory):

$concavity -conservation conservation_data/1G6C 1G6C.pdb test1

This will run concavity with default values (equivalent to ConCavity_L
in the paper) on the structure 1G6C.pdb and consider the conservation
values found in conservation_data/.  This set of predictions will be
called "test1".  This produces the following default result files:

- residue ligand binding predictions for each chain:
1G6C_A_test1.scores  1G6C_B_test1.scores  1G6C_C_test1.scores
1G6C_D_test1.scores

- residue ligand binding predictions in a PDB format file (residue
scores placed in the temp. factor field): 1G6C_test1_residue.pdb

- pocket prediction locations in a DX format file: 1G6C_test1.dx

- pymol script to visualize the predictions:  1G6C_test1.pml

To visualize the predictions in PyMol (it if is installed on your
system), load the script by typing "pymol 1G6C_test1.pml" at the
prompt or by loading it through the pymol interface.

The PDB and DX files can be input into other molecular viewers if
preferred.  Several additional output formats are available; see
below. Note that the residue numbering in the .scores files may not
match that of the PDB file.


--- More Usage Examples ---

concavity has many features.  We only describe the basic options
needed to predict binding sites using the methods described in the
paper.  A complete manual is being written, and you can always wade
through the code.  Most options are listed at the top of concavity.C.

The ConCavity approach proceeds in three conceptual steps: grid
creation, pocket extraction, and residue mapping (see Methods in
paper). First, the structural and evolutionary properties of the
protein are used to create a regular 3D grid surrounding the protein
in which the score associated with each grid point represents an
estimated likelihood that it overlaps a bound ligand atom. Second,
groups of contiguous, high-scoring grid points are clustered to
extract pockets that adhere to given shape and size
constraints. Finally, every protein residue is scored with an estimate
of how likely it is to bind to a ligand based on its proximity to
extracted pockets

Each of the algorithms described for these steps is implemented in
concavity.  For example to score the structure 1G6C.pdb with
ConCavity_Pocketfinder, Search, and Blur, you'd type:

$concavity -conservation /conservation_data/1G6C -grid_method
pocketfinder -extraction_method search -res_map_method blur 1G6C.pdb
cc-pocketfinder_search_blur

The possible options for each method selection parameter:

-grid_method: ligsite, surfnet, pocketfinder, custom
-extraction_method: search, topn, custom
-res_map_method: blur, dist, dist-thresh, custom

Each of these algorithms is described in the text, and each has a
number of additional parameters that change their behavior.  The
"custom" option allows you to set the values of all parameters for
each step yourself.  The presets (e.g. ligsite, search, blur) may
override values you set on the command line, so use "custom" to have
complete control.  For a full list of these options, see the top of
concavity.C.

If the "-conservation" option is not given, then conservation
information is not considered.  Note that there are separate
conservation files for each protein chain in the structure, and the
input to the -conservation option is the prefix of these files.
Pre-computed conservation files available for almost the entire PQS on
the ConCavity web site.  If you'd like to compute sequence
conservation values for your own alignments, we recommend the JSD
algorithm: http://compbio.cs.princeton.edu/conservation/

There are also several output format options. Pocket
prediction grid values can be output in the following formats:

- DX format (using -print_grid_dx 1)
- PDB format (-print_grid_pdb 1)
- raw text (-print_grid_txt 1)

The residue predictions are output as a text file with a list of
residue positions and scores, and as a PDB file with the residue
scores mapped to the temp. factor field and pocket numbers to the
residue sequence field..

We primarily use PyMol and Chimera for visualization, but the range of
output formats means you should be able to import the data into most
structural analysis program.  Let us know if there are other output
formats you'd like to see.

Other options we commonly use are "-v" for verbose mode, "-spacing
<float>" to set the grid spacing, and "-resolution <int> <int> <int>"
to set the grid resolution.  


Please let us know if you have any questions, and check back soon for
updates.

- Tony Capra (tonyc@cs.princeton.edu)  12/15/10


