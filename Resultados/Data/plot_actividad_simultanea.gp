# set term png size 1280,640

proyecto = "fitnesse"
archivo_cantidad = proyecto . "/actividad_simultanea_cantidad.csv"
# archivo_porcentaje = proyecto . "/actividad_simultanea_porcentaje.csv"

# set output proyecto . "/actividad_simultanea_cantidad.png"

set term epslatex color header "\\newcommand{\\ft}[0]{\\footnotesize}"
set output 'actividad_simultanea.tex'

# set title "Actividad entre tags"

# leyenda arriba a la izquierda
set key left top

set style line 1 lc rgb "#1E90FF"
set style line 2 lc rgb "#32CD32"
set style line 3 lc rgb "#333333"

set style data histogram
set style histogram cluster gap 2
set style fill solid border -2.0
set xtic rotate by -45 scale 0 font ",8"

set xlabel "Releases"
set ylabel "Porcentaje (\\%)"
plot archivo_cantidad using 2:xtic(9) every ::1 ti "\\ft Código" ls 1, \
     archivo_cantidad using 5:xtic(9) every ::1 ti "\\ft UT + Código" ls 2, \
     archivo_cantidad using 8:xtic("\\ft " . stringcolumn(9)) every ::1 ti "\\ft AT + UT + Código" ls 3
 
# set output proyecto . "/actividad_simultanea_porcentaje_sobre_at_ut_codigo.png"
set output "actividad_simultanea_porcentaje.tex"
plot [:][0:100] archivo_cantidad using ($2/($2+$3+$4+$5+$6+$7+$8)*100):xtic(9) every ::1 ti "\\ft Código" ls 1, \
     archivo_cantidad using ($5/($2+$3+$4+$5+$6+$7+$8)*100):xtic(9) every ::1 ti "\\ft UT + Código" ls 2, \
     archivo_cantidad using ($8/($2+$3+$4+$5+$6+$7+$8)*100):xtic("\\ft " . stringcolumn(9)) every ::1 ti "\\ft AT + UT + Código" ls 3
