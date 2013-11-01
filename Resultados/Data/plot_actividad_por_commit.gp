set term png size 1280,640

proyecto = "jumi"
nombre_archivo = proyecto . "/actividad_por_commit.csv"
archivo = "<(head -n -1 " . nombre_archivo . ")"
# archivo = nombre_archivo


# set term epslatex color header "\\newcommand{\\ft}[0]{\\footnotesize}"
# set output 'actividad_por_commit_porcentaje.tex'

set output proyecto . "/actividad_por_commit_porcentaje.png"

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
 
plot [:][0:100] archivo using ($3/($1+$2+$3)*100):xtic(4) every ::1 ti "\\ft AT" ls 1, \
     archivo using ($2/($1+$2+$3)*100):xtic(4) every ::1 ti "\\ft UT" ls 2, \
     archivo using ($1/($1+$2+$3)*100):xtic("\\ft " . stringcolumn(4)) every ::1 ti "\\ft Código" ls 3
