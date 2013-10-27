require 'table_to_array'
require 'array_to_table'
module MetricasTesis
  module Scripts
    module Utilitarios
      class TableToLatex
        def initialize          
        end

        def self.convertir tabla
          tabla_latex = Array.new
          tabla_para_csv = MetricasTesis::Scripts::Utilitarios::ArrayToTable.convertir(tabla)

          # Encabezado
          tabla_latex << '\renewcommand{\arraystretch}{1.2}'
          tabla_latex << '\begin{table}[!htpb]'
          tabla_latex << '\centering'

          cantidad_columnas = tabla.first.keys.size
          tabla_latex << '\begin{tabular}{@{}' + 'c'*cantidad_columnas + '@{}}'
          tabla_latex << '\toprule'

          # Contenido tabla
          # Nombres columnas
          fila_nombres_columnas = tabla_para_csv.shift
          fila_latex = ""
          fila_nombres_columnas.each do |columna|
            fila_latex += "\\multicolumn{1}{c}{\\textbf{#{columna}}} & "
          end
          # puse un & de más, lo saco y pongo el fin de linea
          fila_latex.gsub!(/\s*&\s*$/, '\\\\\\\\')
          tabla_latex << fila_latex
          
          tabla_latex << '\midrule'

          # el resto del contenido de la tabla
          tabla_para_csv.each do |fila|
            fila_latex = ""
            fila.each do |columna|
              fila_latex += "#{columna} & "
            end
            # puse un & de más, lo saco y pongo el fin de linea
            fila_latex.gsub!(/\s*&\s*$/, '\\\\\\\\')
            tabla_latex << fila_latex
          end
    
          # Fin tabla
          tabla_latex << '\bottomrule'
          tabla_latex << '\end{tabular}'
          tabla_latex << '\caption{}'
          tabla_latex << '\label{tbl:}'
          tabla_latex << '\end{table}'
        end

      end
    end
  end
end


if "RUN_SCRIPT" == ARGV[0] && /\.csv$/ =~ ARGV[1]
  path_archivo = ARGV[1]
  archivo = File.readlines(path_archivo)
  tabla = MetricasTesis::Scripts::Utilitarios::TableToArray.convertir(archivo, "\t")
  tabla_latex = MetricasTesis::Scripts::Utilitarios::TableToLatex.convertir(tabla)
  
  path_archivo_latex = path_archivo.gsub(/\.csv$/, '.tex')
  archivo_latex = File.open(path_archivo_latex, 'w')
  tabla_latex.each { |linea| archivo_latex.puts linea }
  archivo_latex.close  
end