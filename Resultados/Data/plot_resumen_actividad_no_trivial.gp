set term png size 1280,640
set output 'resumen_actividad_no_trivial.png'

# set term epslatex color
# set output 'resumen_actividad_no_trivial.tex'

set title "Archivos modificados entre tags"


# leyenda arriba a la izquierda
set key left top

set style line 1 lc rgb "#1E90FF"
set style line 2 lc rgb "#32CD32"
set style line 3 lc rgb "#333333"

set style data histogram
set style histogram cluster gap 2
set style fill solid border -2.0
set xtic rotate by -45 scale 0 font ",8"


plot 'resumen_actividad_no_trivial.csv' using 1:xtic(5) every ::2 ti "AT modificados" ls 1, \
     'resumen_actividad_no_trivial.csv' using 2:xtic(5) every ::2 ti "UT modificados" ls 2, \
     'resumen_actividad_no_trivial.csv' using 3:xtic(5) every ::2 ti "Código modificados" ls 3
 
