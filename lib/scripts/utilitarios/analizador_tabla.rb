module MetricasTesis
  module Scripts
    module Utilitarios
      class AnalizadorTabla
        def initialize          
        end

        def self.calcular_total tabla
          resultado = Hash.new
          columnas = obtener_encabezado(tabla)

          columnas.each do |columna|
            if tabla[0][columna].is_a? Fixnum
              suma_columna = 0
              tabla.each do |fila|
                suma_columna += fila[columna]
              end
              resultado[columna] = suma_columna
            end
          end
          
          resultado
        end

        def self.obtener_encabezado tabla
          header = Array.new

          if 0 != tabla.size
            header = tabla[0].keys
          end
          header
        end
      end
    end
  end
end
