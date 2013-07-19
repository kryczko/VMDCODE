pbc unwrap -all
axes location Off
display depthcue off
color Display Background blue2
mol delrep 0 0
mol addrep 0
mol modstyle 0 0 VDW 0.1500000 1000.000000
mol modmaterial 0 0 BrushedMetal
mol addrep 0 
mol modstyle 1 0 DynamicBonds 1.25 0.05 1000.0
mol modmaterial 1 0 BrushedMetal
mol addrep 0
mol modstyle 2 0 HBonds 3.6 30.0 1.0
mol modcolor 2 0 ColorID 15
mol modmaterial 2 0 Transparent
mol addrep 0
mol modstyle 3 0 VDW 0.0500000 1000.000000
mol modcolor 3 0 ColorID 2
mol modmaterial 3 0 Glossy
mol showperiodic 0 3 xyzXYZn
mol numperiodic 0 3 1

# declare the pbc function
proc pbc_round {f} {
        
	set n [expr int($f)]
	set d [expr $f - $n]
	if { [expr abs($d)] >= 0.5 } {
		if {$f > 0} { set n [expr $n + 1]}
		if {$f < 0} { set n [expr $n - 1]}
	}
return $n
}  



# get the number of frames
set nframes [molinfo top get numframes]

set xlat 12.42
set ylat 12.42
set zlat 12.42


variable hindex
variable showh


for { set i 0 } { $i < $nframes} { incr i 10} {

	set oindex 0 	
	
	set oatom [[atomselect top "name O"] get index]
	set hatom [[atomselect top "name H"] get index]

	set oatoms [atomselect top "name O"]	
	set hatoms [atomselect top "name H"]


	set ox [$oatoms get {x}]
	set oy [$oatoms get {y}]
	set oz [$oatoms get {z}]
	set hx [$hatoms get {x}]
        set hy [$hatoms get {y}]
        set hz [$hatoms get {z}]
	
	set onum [llength $oatom]
	set hnum [llength $hatom]
	
	for { set j 0 } { $j < $onum } {incr j} {
		set count 0
		for { set k 0} { $k < $hnum } { incr k } {
		
			set dx [expr [lindex $ox $j] - [lindex $hx $k]]
			set dy [expr [lindex $oy $j] - [lindex $hy $k]]
			set dz [expr [lindex $oz $j] - [lindex $hz $k]]
			
			set dx [expr $dx - [expr [pbc_round [expr $dx/$xlat]]*$xlat]]
			set dy [expr $dy - [expr [pbc_round [expr $dy/$ylat]]*$ylat]]
			set dz [expr $dz - [expr [pbc_round [expr $dz/$zlat]]*$zlat]]	
			
			set dist [expr sqrt( $dx*$dx + $dy*$dy + $dz*$dz )]
			if {$dist < 1.35} {
			incr count
			lappend hindex [expr $k + 64]
			}
		}

	if {($count == 1)} {
	lappend oindex $j
	lappend showh $hindex
	}
	unset hindex
	}
	
	
	set olen [llength $oindex]

	if { $olen != 1} {

	set oindex [lreplace $oindex 0 0]

	
	mol addrep 0
	mol modselect 4 0 index $oindex $showh 
	mol modcolor 4 0 ColorID 12
	mol modmaterial 4 0 Glossy
	mol modstyle 4 0 VDW 0.3 1000.0
	mol modselect 5 0 index $oindex $showh
	mol modcolor 5 0 ColorID 12
	mol modmaterial 5 0 Glossy
	mol modstyle 5 0 DynamicBonds 1.5 0.2 1000.0
	unset oindex
	unset showh
	}

	# Declare a new variable that will increment by 1 from 1-number of frames	
	set j [expr $i/10]
	set n [expr $i/10 + 1]

	# for the files named chg000#
	if {$j < 10} {

	#open file
	set filename "/home/kryczko/git/VMDCODE/CHARGE!/chg[format "000%d" $j]"
	puts $filename

	# create a new representation
	mol new $filename type {CHGCAR} first 0 last -1 step 1 waitfor 1 volsets {0 }
	}
	
	# for the files named chg 00## (process same as above)
	if {($j >= 10)&&($j < 100)} {
        set filename chg[format "00%d" $j]
        puts $filename

        mol new "/home/kryczko/git/VMDCODE/CHARGE!/$filename" type {CHGCAR} first 0 last -1 step 1 waitfor 1 volsets {0 }
        }
	
	# for the files named chg0### (process same as above)
	if {($j >= 100)&&($j < 1000)} {
	set filename chg[format "0%d" $j]
        puts $filename

        mol representation Isosurface 0.5 0 0 2 1 1
        mol new "/home/kryczko/git/VMDCODE/CHARGE!/$filename" type {CHGCAR} first 0 last -1 step 1 waitfor 1 volsets {0 }
	
	}

	# for the files named chg#### (process same as above)
        if {$j >= 1000} {
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
	
	

	# go to the frame
	 animate goto $i
	
	scale by 1.20
	
	
        mol delrep 6 0
        display update
	puts $j
	rotate y by [expr $j*0.13333]
        set filename snap.[format "%d"  $j].rgb
               render snapshot $filename
	
	mol delete [expr $n]
}
	
	

	

