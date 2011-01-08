/******************************************************************************
 * pocket_extraction.h -  Copyright (c) 2009 Thomas Funkhouser and Tony Capra
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
 *
 *******************************************************************************/

#ifndef _POCKET_EXTRACTION_H_

#include "R3Shapes/R3Shapes.h"
#include "PDB/PDB.h"


// public pocket_extraction functions
RNArray<PDBAtom *> * FindProteinAtoms(PDBFile *file);
RNArray<PDBAtom *> * FindLigandAtoms(PDBFile *file, const char *ligand_name);
R3Grid * ExtractPockets(PDBFile *file, R3Grid *grid, const RNArray<PDBAtom *> *protein_atoms, const RNArray<PDBAtom *> *ligand_atoms);



#define _POCKET_EXTRACTION_H_
#endif // _POCKET_EXTRACTION_H_
