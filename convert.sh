#!/bin/bash

files=/home/kryczko/git/VMDCODE/CHGMOVIE/*.rgb
count=0
for f in $files
do	
	echo $count
	convert snap.$count.rgb $count.png
	count=`expr $count + 1`
done
