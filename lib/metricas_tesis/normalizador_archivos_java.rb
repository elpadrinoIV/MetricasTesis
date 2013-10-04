module MetricasTesis
  class NormalizadorArchivosJava
    def initialize      
    end

    def normalizar lineas
      lineas_normalizadas = quitar_lineas_vacias(lineas)
      lineas_normalizadas = quitar_comentarios_largos(lineas_normalizadas)
      lineas_normalizadas = quitar_comentarios_cortos(lineas_normalizadas)
      lineas_normalizadas
    end

    ##
    # Quita todas las lineas vacías. Por vacío se entiende a una línea
    # que no tiene nada o solo tiene espacios (tabs, \r, etc)
    #
    # Params:
    # +lineas+ las líneas a analizar
    #
    # Devuelve un array como el original sin las líneas vacías
    #
    def quitar_lineas_vacias lineas
      lineas_filtradas = Array.new
      lineas.each do |linea|
        if !(/^\s*$/ =~ linea)
          lineas_filtradas << linea
        end
      end
      lineas_filtradas
    end

    ##
    # Quita los comentarios cortos del estilo //. Borra todo lo que está
    # después de la doble barra (y también quita la doble barra)
    # Tener en cuenta que una doble barra dentro de una cadena no es un
    # comentario
    #
    # Params:
    # +lineas+ las líneas a analizar
    #
    # Devuelve un array como el original sin los comentarios. Borra líneas vacías
    #
    def quitar_comentarios_cortos lineas
      lineas_filtradas = Array.new

      lineas.each do |linea|
        if /(["'])/ =~ linea
          # es un caso especial, me tengo que fijar que las // no estén
          # adentro de un string
          cantidad_letras = linea.size
          numero_letra = 0
          separador_cadena = ''
          omitir_siguiente = false
          linea_sin_comentario_corto = ''
          while numero_letra < cantidad_letras
            letra = linea[numero_letra]
            if omitir_siguiente
              omitir_siguiente = false
              linea_sin_comentario_corto += letra
            else
              if '\\' == letra
                omitir_siguiente = true
              end

              if separador_cadena.empty?
                # modo normal
                if  letra == '/' && linea[numero_letra + 1] == '/'
                  # Empieza comentario corto hasta el final de linea,
                  # dejo de procesar
                  numero_letra = cantidad_letras
                else
                  linea_sin_comentario_corto += letra
                  if '"' == letra || "'" == letra
                    # Empieza cadena
                    separador_cadena = letra
                  end
                end
              else
                # modo cadena
                linea_sin_comentario_corto += letra
                if letra == separador_cadena
                  # fin cadena
                  separador_cadena = ''
                end
              end
            end

            numero_letra += 1
          end

        else
          linea_sin_comentario_corto = linea.gsub(/\/\/.*$/,"")
        end
        
        linea_sin_comentario_corto.strip!
        lineas_filtradas << linea_sin_comentario_corto
      end

      lineas_filtradas = quitar_lineas_vacias(lineas_filtradas)

      lineas_filtradas
    end

    ##
    # Quita los comentarios largos del estilo /* ... */. Borra todo lo que está
    # entre /* y */
    # Tener en cuenta que un /* dentro de una cadena no comienza un comentario
    #
    # Params:
    # +lineas+ las líneas a analizar
    #
    # Devuelve un array como el original sin los comentarios. Borra líneas vacías
    #
    def quitar_comentarios_largos lineas
      archivo = lineas.join("\n")
      archivo.gsub!(/\/\*(.*?\n*)*?\*\//,' ')
      lineas_filtradas = archivo.split("\n")
      lineas_filtradas = quitar_lineas_vacias(lineas_filtradas)
      lineas_filtradas
    end
  end
end
