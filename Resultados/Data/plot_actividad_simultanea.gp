set term png size 1280,640
set output 'actividad_simultanea.png'

# set term epslatex color
# set output 'actividad_simultanea.tex'

set title "Actividad entre tags"


# leyenda arriba a la izquierda
set key left top

set style line 1 lc rgb "#1E90FF"
set style line 2 lc rgb "#32CD32"
set style line 3 lc rgb "#333333"

set style data histogram
set style histogram cluster gap 2
set style fill solid border -2.0
set xtic rotate by -45 scale 0 font ",8"


plot 'actividad_simultanea.csv' using 2:xtic(9) every ::1 ti "Código" ls 1, \
     'actividad_simultanea.csv' using 5:xtic(9) every ::1 ti "UT + Código" ls 2, \
     'actividad_simultanea.csv' using 8:xtic(9) every ::1 ti "AT + UT + Código" ls 3
 
