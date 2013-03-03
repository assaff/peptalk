
import subprocess, os
import tempfile
import prody
import pandas as pd

NACCESS_BINARY = '/home/assaff/tools/naccess2.1.1/naccess'

rsa_colnames = [
            'RES', 'Resname', 'Chain', 'Resnum', 
            'All-atoms-abs', 'All-atoms-rel', 
            'Total-Side-abs', 'Total-Side-rel', 
            'Main-Chain-abs', 'Main-Chain-rel', 
            'Non-polar-abs', 'Non-polar-rel', 
            'All-polar-abs', 'All-polar-rel',
            ]

def read_naccess_rsa(rsa_filename):
    rsa_table = pd.read_csv(rsa_filename, 
                       sep=None, 
                       index_col=[2,3,1], 
                       skipinitialspace=True, 
                       skiprows=4, 
                       header=None, 
                       skipfooter=4, 
                       names=rsa_colnames, 
                       delimiter=' ')
    colname_endswith_abs = lambda colname: colname.endswith('abs')
    
    rsa_table = rsa_table.ix[:,1:] # remove the RES column
    
    # select only columns of absolute SASA
    #rsa_table = rsa_table.select(colname_endswith_abs, axis=1)
    
    return rsa_table

def read_naccess_asa(asa_filename):
    '''
    Reads per-atom ASA values from ``asa_filename``.
    Returns a pandas.Series object containing the data.
    '''
    
    # asa file is a PDB file with ASA values as 
    # occupancy and VDW radii as B-factor
    atoms = prody.parsePDB(asa_filename).protein
    atoms_asa = atoms.getOccupancies()
    atoms_asa_series = pd.Series(data=atoms_asa, name='per_atom_asa')
    return atoms_asa_series

def getResidueSasa(atoms, return_atom_asa=False):
    protein_atoms = atoms.protein
    assert protein_atoms.getHierView().numChains() == 1
    
    pdb_file = tempfile.NamedTemporaryFile(prefix='tmp_naccess_', suffix='.pdb', delete=False)
    
    pdb_filename = pdb_file.name
    prody.writePDB(pdb_filename, protein_atoms)
    pdb_file.close()
    
    prefix, ext = os.path.splitext(pdb_filename)
    #print prefix, ext
    rsa_filename = '{}.rsa'.format(prefix)
    asa_filename = '{}.asa'.format(prefix)
    
    # run naccess on the temporary PDB file, with $CWD set to 
    # the PDB file's directory. This is because naccess dumps
    # all the output files in $CWD, and they aren't necessary
    # after parsing.
    subprocess.Popen(
                    [NACCESS_BINARY, pdb_filename, ], 
                    cwd=os.path.dirname(pdb_filename), 
                        ).communicate()
    
    # read the resulting .rsa file into a table
    rsa_table = read_naccess_rsa(rsa_filename)
    atom_asa = read_naccess_asa(asa_filename)
    
    assert len(atom_asa) == len(protein_atoms), '{} != {}'.format(len(atom_asa), len(protein_atoms))
    
    if return_atom_asa:
        return rsa_table, atom_asa
    return rsa_table