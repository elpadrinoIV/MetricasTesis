module MetricasTesis
  module Scripts
    module Utilitarios
      class ArrayToTable
        def initialize
        end

        ##
        # Convierte un array donde cada elemento es un hash con los elementos
        # de la fila. Asume que la estructura del hash es siempre igual para
        # cada fila.
        #
        # Params:
        # +array+:: array de hashes, donde cada hash es una fila de la tabla
        #
        # Devuelve un array de arrays con la forma de la tabla.
        #
        # Ejemplo
        #   tabla = Array.new
        #   fila1 = {:nombre => "Nico", :edad => 26}
        #   fila2 = {:nombre => "Gil", :edad => 24}
        #
        #   tabla << fila1
        #   tabla << fila2
        #
        #   tabla_convertida = ArrayToTable.convertir tabla
        #   puts tabla_convertida
        #   # => [["nombre", "edad"], ["Nico", 26], ["Gil", 24]]
        #
        def self.convertir array
          tabla = Array.new
          
          # Header tabla
          header = Array.new

          if 0 != array.size
            header = Array.new
            array[0].keys.each { |key| header << key }
            tabla << header
          end

          array.each do |fila_original|
            fila_nueva = Array.new
            header.each { |key| fila_nueva << fila_original[key] }
            tabla << fila_nueva
          end

          tabla
        end

        def self.guardar_tabla tabla, path_archivo, separador
          file = File.open(path_archivo, 'w')
          tabla.each do |fila|
            fila_archivo = fila.join(separador)
            file.puts fila_archivo
          end

          file.close          
        end
      end
    end
  end
end
