module MetricasTesis
  module Scripts
    module Utilitarios
      class TableToArray
        def initialize          
        end

        def convertir tabla, separador
          tabla_convertida = Array.new

          tengo_encabezado = false
          encabezado = Array.new
          tabla.each do |fila|
            
            # se deben ignorar filas vacías o que empiecen con #

            linea = preprocesar_fila(fila)

            if !linea.empty?
              if !tengo_encabezado
                # la primer linea debería ser el nombre de las columnas
                encabezado = linea.split(separador)
                encabezado = convertir_a_simbolos(encabezado)
                tengo_encabezado = true;
              else
                # es una fila normal
                valores = linea.split(separador)
                if valores.size != encabezado.size
                  # tiro error
                  raise IndexError, 'fila con distinta cantidad de columnas que el encabezado'
                end

                valores.each {|valor| valor.gsub!('"', '')}

                tabla_convertida << Hash[encabezado.zip valores]

              end
            end
          end
          
          tabla_convertida
        end

        def convertir_desde_archivo archivo

        end
        
        private
        def preprocesar_fila fila
          fila.gsub!(/^\s*#.*/, '')
          fila.strip!
          fila
        end

        def convertir_a_simbolos lista
          lista_convertida = Array.new
          lista.each { |elemento| lista_convertida << elemento.to_sym }
          lista_convertida
        end
      end
    end
  end
end
