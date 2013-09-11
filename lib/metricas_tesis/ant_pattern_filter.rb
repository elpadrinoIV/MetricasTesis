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
      regex = patron.gsub('?', '.')
      regex.gsub!('*', '[^/]*')
      puts regex
      /#{regex}/ =~ cadena
    end

    private
    def obtener_regex patron
      regex = patron.gsub('**', '.*')
    end

  end
end
