menu main on
axes location Off

# pull up the vasprun file
display resetview
mol new {/home/kryczko/git/VMDCODE/CHARGE!/vasprun.xml} type {xml} first 0 last -1 step 1 waitfor -1 

# declare the display settings for the water molecules
pbc unwrap -all
display depthcue off
color Display Background blue2
mol modstyle 0 0 VDW 0.200000 1200.0
mol addrep 0
mol modstyle 1 0 DynamicBonds 1.200000 0.0500000 1200.000000

# declare the number of frames
set nframes [molinfo top get numframes]

# for loop to display the corresponding chgcar file. Since they are printed out by vasp every 10 timesteps we must increment by 10.
for {set i 0} {$i < $nframes} {incr i 10} {
	
	
	# Declare a new variable that will increment by 1 from 1-number of frames	
	set j [expr $i/10]
	set n [expr $i/10 + 1]

	# for the files named chg00#
	if {$j < 10} {

	#open file
	set filename "/home/kryczko/git/VMDCODE/CHARGE!/chg[format "00%d" $j]"
	puts $filename

	# create a new representation
	mol new $filename type {CHGCAR} first 0 last -1 step 1 waitfor 1 volsets {0 }
	}
	
	# for the files named chg 0## (process same as above)
	if {($j >= 10)&&($j < 100)} {
        set filename chg[format "0%d" $j]
        puts $filename

        mol new "/home/kryczko/git/VMDCODE/CHARGE!/$filename" type {CHGCAR} first 0 last -1 step 1 waitfor 1 volsets {0 }
        }
	
	# for the files named chg### (process same as above)
	if {$j >= 100} {
	set filename chg[format "%d" $j]
        puts $filename

        mol representation Isosurface 0.5 0 0 2 1 1
        mol new "/home/kryczko/git/VMDCODE/CHARGE!/$filename" type {CHGCAR} first 0 last -1 step 1 waitfor 1 volsets {0 }
	
	}
	# Now we need to display the new chgcar 3D data and take a picture.

	# Display settings for chg file
	mol representation Isosurface 0.5 0 0 2 1 1
	mol modstyle 0 $n Isosurface 0.500000 0 0 0 1 1
	mol modmaterial 0 $n Transparent
	mol modcolor 0 $n ColorID 15

	# update display and render
	animate goto $i
	display update

	mol delete [expr $n]

}
