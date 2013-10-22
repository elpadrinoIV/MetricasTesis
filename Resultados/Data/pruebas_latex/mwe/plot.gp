# set term png
# set output 'test.png'
set encoding iso_8859_1
set term epslatex color
set output 'test.tex'

plot sin(x) ti "Eñe"
