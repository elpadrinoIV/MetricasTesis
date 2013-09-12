module MetricasTesis
  class AntPatternFilter
    def initialize
      @fileset = ""
      @includes = Array.new
      @excludes = Array.new
      @filtro_include = obtener_regex_filtro(:include)
      @filtro_exclude = obtener_regex_filtro(:exclude)
    end

    def set_fileset fileset
      @fileset = fileset
      # si no termina en /, se lo agrego
      @fileset += '/' unless ( /\/$/ =~ fileset)

      @filtro_exclude = obtener_regex_filtro(:exclude)
    end

    def add_include include
      @includes << include
      @filtro_include = obtener_regex_filtro(:include)
    end

    def add_exclude exclude
      @excludes << exclude
      @filtro_exclude = obtener_regex_filtro(:exclude)
    end

    def filtrar lista_archivos
      lista_filtrada = Array.new
      
      lista_archivos.each do |archivo|
        lista_filtrada << archivo if cumple_filtro? archivo
      end

      lista_filtrada
    end

    ##
    # Indica si una cadena cumple con el filtro tomando en cuenta
    # el fileset, includes y excludes indicados.
    #
    # Ver ejemplo para ver que cosas permite
    #
    # Params
    # +path_archivo+ cadena path del archivo
    #
    # Ejemplo:
    #   # Se pueden indicar archivos asi:
    #   archivo = 'src/fitnesse/slim/ShutdownResponderTest.java'
    #
    #   # O asi (formato que da git):
    #   archivo = 'M      src/fitnesse/slim/ShutdownResponderTest.java'
    #
    def cumple_filtro? path_archivo
      path_archivo.gsub!(/^[A-Z]\s+/,'')
      
      cumple = false
      if /#{@filtro_include}/ =~ path_archivo
        cumple = true
        if (!@excludes.empty?)
          matchea_excludes = /#{@filtro_exclude}/ =~ path_archivo
          cumple = cumple && !matchea_excludes
        end
      end

      cumple
    end

    ##
    # Indica si una cadena cumple con el patrón indicado
    #
    # Solo se utiliza el patrón dado, no utiliza el fileset,
    # includes, excludes.
    #
    # +cadena+ path del archivo
    # +patron+ patrón ant a aplicar
    #
    # Ejemplo:
    #   patron = 'org/apache/**/CVS/*'
    #   cadena1 = 'org/apache/CVS/Entries'
    #   cadena2 = 'org/apache/jakarta/tools/ant/CVS/Entries'
    #   cadena3 = 'org/apache/CVS/foo/bar/Entries'
    #
    #   cumple_patron? cadena1, patron  # true
    #   cumple_patron? cadena2, patron  # true
    #   cumple_patron? cadena3, patron  # false
    #
    def cumple_patron? cadena, patron
      regex = obtener_regex patron
      
      /#{regex}/ =~ cadena
    end

    private
    def obtener_regex patron
      # Si termina con / o con \, reemplazo por /** (o \**)
      regex = patron.gsub(/([\/\\])$/,'\1**')

      regex.gsub!(/\/\*\*$/,'<<<<<<SEARCH_ALL_SUBFOLDERS>>>>>>')

      # No debe matchear una porción, sino todo, por eso
      # agrego ^ al principio y $ al final
      regex = '^' + regex + '$'

      # El punto el regex lo toma como caracter especial para indicar
      # "cualquier caracter". Lo reemplazo para que lo tome literal
      regex.gsub!('.', '\\.')

      # los signos de pregunta son uno y solo 1 caracter cualquiera
      regex.gsub!('?', '.')

      regex_splitted = Array.new
      regex.split('**/').each do |sub_regex|
        # los asteriscos individuales son cualquier cosa menos una barra
        regex_splitted << sub_regex.gsub('*', '[^/]*')
      end

      regex = regex_splitted.join('([^/]+/)*')
      regex.gsub!('<<<<<<SEARCH_ALL_SUBFOLDERS>>>>>>', '(/.*)*')

      regex
    end

    def obtener_regex_filtro tipo
      regex = ""
      array_regexes = Array.new
      case tipo
      when :include
        @includes.each do |include|
          patron = @fileset + include
          array_regexes << obtener_regex(patron)
        end
      when :exclude
        @excludes.each do |exclude|
          patron = @fileset + exclude
          array_regexes << obtener_regex(patron)
        end
      end

      regex = array_regexes.join('|')
    end
  end
end
