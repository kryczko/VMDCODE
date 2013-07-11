#pbc unwrap -all
#display depthcue off

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

variable oindex
variable hindex

for { set i 0 } { $i < 1} { incr i 20} {
	# go to the frame
	animate goto $i
	rotate y by 1.0 
	display update	
	

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
			if {$dist < 1.2} {
			incr count
			}
		}
	puts "O$j : $count"
	}
}
	
	

	

