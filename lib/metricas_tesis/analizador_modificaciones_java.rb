module MetricasTesis
  class AnalizadorModificacionesJava
    def initialize path_repos
      @path_repos = path_repos
    end

    def cambios_no_triviales(archivo, commit_hash)
      diff = `git diff --word-diff #{commit_hash}^..#{commit_hash} -- #{archivo}`.split("\n")

      cantidad_cambiados = 0
      diff.each do |linea|
        # Si no tiene el patrón {+...+} o [-...-] entonces no me interesa
        if ( /\{\+.+\+\}/ =~ linea || /\[\+.+\+\]/ =~ linea)
          cantidad_cambiados += 1
        end
      end

      # puts diff
      cantidad_cambiados
    end
  end
end
