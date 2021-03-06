pbc unwrap -all
axes location Off
display depthcue off
color Display Background blue2
mol delrep 0 0
mol addrep 0
mol modstyle 0 0 VDW 0.1500000 1000.000000
mol modmaterial 0 0 BrushedMetal
mol addrep 0 
mol modstyle 1 0 DynamicBonds 1.25 0.1 1000.0
mol modmaterial 1 0 BrushedMetal
mol addrep 0
mol modstyle 2 0 HBonds 3.6 30.0 1.0
mol modcolor 2 0 ColorID 15
mol modmaterial 2 0 Transparent

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

set xlat 14.41
set ylat 14.41
set zlat 14.41


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
	
	for { set j 0 } { $j < $hnum } {incr j} {
		set count 0
		for { set k 0} { $k < $onum } { incr k } {
		
			set dx [expr [lindex $hx $j] - [lindex $ox $k]]
			set dy [expr [lindex $hy $j] - [lindex $oy $k]]
			set dz [expr [lindex $hz $j] - [lindex $oz $k]]
			
			set dx [expr $dx - [expr [pbc_round [expr $dx/$xlat]]*$xlat]]
			set dy [expr $dy - [expr [pbc_round [expr $dy/$ylat]]*$ylat]]
			set dz [expr $dz - [expr [pbc_round [expr $dz/$zlat]]*$zlat]]	
			
			set dist [expr sqrt( $dx*$dx + $dy*$dy + $dz*$dz )]
			if {$dist < 1.35} {
			incr count
			
			}
		}

	if {($count == 0)} {
	lappend oindex [expr $j + $onum] 
	
	}
	
	}
	
	
	set olen [llength $oindex]

	if { $olen != 1} {

	set oindex [lreplace $oindex 0 0]

	
	mol addrep 0
	mol modselect 3 0 index $oindex  
	mol modcolor 3 0 ColorID 12
	mol modmaterial 3 0 Glossy
	mol modstyle 3 0 VDW 0.3 1000.0
	mol modselect 4 0 index $oindex 
	mol modcolor 4 0 ColorID 12
	mol modmaterial 4 0 Glossy
	mol modstyle 4 0 DynamicBonds 1.5 0.2 1000.0
	unset oindex
	
	}

	# go to the frame
        animate goto $i
        mol delrep 5 0

        display update

        #set filename snap.[format "%04d"  $i].rgb
         #      render snapshot $filename

}
	
	

	

