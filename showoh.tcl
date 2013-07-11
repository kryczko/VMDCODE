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
# loop through each frame

for { set i 0 } { $i < 1} { incr i } {
	# go to the frame
	animate goto $i
	
	set oatoms [[atomselect top "name O"] get index]	
	set hatoms [[atomselect top "name H"] get index]
	
	set onum [llength $oatoms]
	set hnum [llength $hatoms]

	for { set j 60 } { $j < 61 } {incr j} {
		set count 0
		for { set k 0} { $k < $hnum } { incr k } {
			
	       		set blength [list [lindex $oatoms $j] [lindex $hatoms $k]]
			set bl [measure bond $blength frame $i]
			set newbl [expr $bl - [expr [pbc_round [expr $bl/$xlat]]*$xlat]]
			puts $newbl
			#if { ([expr abs($bl)] <= 1.1)&& ([expr abs($bl)] >= 0.9)} { incr count }
		}
        #puts "frame $i : O $j : count =  $count"
	} 
}
	
	

	

