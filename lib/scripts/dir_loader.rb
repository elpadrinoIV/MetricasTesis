module Scripts
  class DirLoader
    def initialize
      @directorios = Hash.new
    end

    def cargar_datos_de_archivo path_archivo
      lineas = IO.readlines(path_archivo)
      lineas.each do |linea|
        if /^\s*(?<nombre>[a-zA-Z0-9_-]+)\s*=\s*(?<dir>.+)$/ =~ linea
          if @directorios.has_key? nombre
            raise IndexError, 'nombre clave repetido'
          end

          @directorios[nombre] = dir
        end
      end
    end

    def get_directorio nombre
      if !@directorios.has_key? nombre
        raise ArgumentError, "no hay directorio para #{nombre}"
      end
      @directorios[nombre]
    end
  end
end
