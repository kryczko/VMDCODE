#!/bin/bash

ffmpeg -f image2 -framerate 25 -i snap%03d.png -s 1920x1080 output.mov
