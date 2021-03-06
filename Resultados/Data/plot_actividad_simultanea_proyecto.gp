set term png size 1280,640

proyecto = "jumi"
archivo_cantidad = proyecto . "/actividad_simultanea_proyecto_cantidad.csv"

# set output proyecto . "/actividad_simultanea_proyecto.png"

# set term epslatex color
# set output 'actividad_simultanea.tex'

set title "Actividad en todo el proyecto"


# leyenda arriba a la izquierda
set key left top

set style line 1 lc rgb "#1E90FF"
set style line 2 lc rgb "#32CD32"
set style line 3 lc rgb "#333333"

set style data histogram
set style histogram cluster gap 2
set style fill solid border -2.0
set xtic rotate by -45 scale 0 font ",8"

set xlabel "Tags"

set ylabel "Porcentaje"
set ytics 10

set output proyecto . "/actividad_simultanea_porcentaje_sobre_at_ut_codigo.png"
plot [:][0:100] archivo_cantidad using ($2/($2+$3+$4+$5+$6+$7+$8)*100):xtic(9) every ::1 ti "Código" ls 1, \
     archivo_cantidad using ($5/($2+$3+$4+$5+$6+$7+$8)*100):xtic(9) every ::1 ti "UT + Código" ls 2, \
     archivo_cantidad using ($8/($2+$3+$4+$5+$6+$7+$8)*100):xtic(9) every ::1 ti "AT + UT + Código" ls 3
