module MetricasTesis
  class AntPatternFilter
    def initialize
      @fileset = ""
      @includes = Array.new
      @excludes = Array.new
    end

    def set_fileset fileset
      @fileset = fileset
    end

    def add_include include
      @includes << include
    end

    def add_exclude include
      @includes << include
    end

    def filtrar lista
      return lista
    end

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
  end
end
