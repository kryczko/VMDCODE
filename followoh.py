# follow the OH group(s) in a water simulation

from VMD import graphics, molecule
from AtomSel import AtomSel

def pbc_round(distance):
    i = int(distance)
    
    if (abs(distance - i) >= 0.5):
        if (distance > 0):
            i += 1
	if (distance < 0):
	    i -= 1
    return i


def follow():
    # number of frames
    nframes = molecule.numframes(0)
    
    xlat = 12.42
    ylat = 12.42
    zlat = 12.42

    for eachframe in range(1, nframes):

	# create an array of indices for the O and H toms
        O = AtomSel('name O')
        H = AtomSel('name H')

	# get the coordinates for every atom in each frame
        ox, oy, oz = O.get('x', 'y', 'z')
        hx, hy, hz = H.get('x', 'y', 'z')

        for everyoatom in O:
	    count = 0
            for everyhatom in H:
                         
		dx = ox[everyoatom] - hx[everyhatom - 64]
		dy = oy[everyoatom] - hy[everyhatom - 64]
		dz = oz[everyoatom] - hz[everyhatom - 64]

		dx -= xlat*pbc_round(dx/xlat)
		dy -= ylat*pbc_round(dy/ylat)
		dz -= zlat*pbc_round(dz/zlat)

		distance = (dx**2 + dy**2 + dz**2)**(0.5)

		if (distance <= 1.15):
		    count += 1
  	    
      	    if (count == 1):
		print everyatom, ":  ", count, " hydrogen" 

if __name__=="__main__":
        follow() 
