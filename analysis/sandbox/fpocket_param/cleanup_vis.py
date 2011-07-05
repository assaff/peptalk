import pymol
from pymol import util, cmd

pymol.finish_launching()


def cleanup(id):
    cmd.do('''orient''')
    cmd.do('''show_as cartoon, ????.*''')
    cmd.do('''show_as cartoon, %s.*''' %id)
    cmd.show("sticks","((byres (%s.peptide))&(!(n;c,o,h|(n. n&!r. pro))))" %id)
    cmd.do('''show_as spheres, pocket*castp''')
    cmd.do('''show_as sticks, cross*''')
    cmd.do('''alter pocket*vert, vdw=vdw+1.4''')
    cmd.do('''show_as mesh, pocket*vert''')
    cmd.do('''show_as spheres, pocket*atm''')
    util.color_objs("(all)",_self=cmd)
    cmd.do('''disable pocket*''')
    cmd.do('''enable pocket0_vert''')
    cmd.do('''enable pocket1_vert''')
    cmd.do('''enable pocket2_vert''')

cmd.extend('cleanup',cleanup)
