menu main on
axes location Off

# pull up the vasprun file
display resetview
mol new {/home/kryczko/git/VMDCODE/CHARGE!/vasprun.xml} type {xml} first 0 last -1 step 1 waitfor -1 

pbc unwrap -all
mol modstyle 0 0 VDW 0.200000 1200.0
mol addrep 0
mol modstyle 1 0 DynamicBonds 1.200000 0.0500000 1200.000000

set nframes [molinfo top get numframes]
puts $nframes
for {set i 0} {$i < $nframes} {incr i 10} {
	animate goto $i
	display update
	set j [expr $i/10]
	
	if {$j < 10} {
	set filename "/home/kryczko/git/VMDCODE/CHARGE!/chg[format "00%d" $j]"
	puts $filename
	display resetview
	mol representation Isosurface 0.5 0 0 2 1 1 
	mol new $filename type {CHGCAR} first 0 last -1 step 1 waitfor 1 volsets {0 }
	if {$j > 1} {
	mol delete [expr $j - 1]
	}
	}

	if {($j >= 10)&&($j < 100)} {
        set filename chg[format "0%d" $j]
        puts $filename

	display resetview
        mol representation Isosurface 0.5 0 0 2 1 1
        mol new "/home/kryczko/git/VMDCODE/CHARGE!/$filename" type {CHGCAR} first 0 last -1 step 1 waitfor 1 volsets {0 }
        
	mol delete [expr $j - 1]
	}
	

	if {$j >= 100} {
	set filename chg[format "%d" $j]
        puts $filename


	display resetview
        mol representation Isosurface 0.5 0 0 2 1 1
        mol new "/home/kryczko/git/VMDCODE/CHARGE!/$filename" type {CHGCAR} first 0 last -1 step 1 waitfor 1 volsets {0 }
	
	mol delete [expr $j - 1]
	}
	
	}
