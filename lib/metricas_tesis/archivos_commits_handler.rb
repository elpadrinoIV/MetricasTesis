require 'commits_handler'
module MetricasTesis
  class ArchivosCommitsHandler
    def initialize path_to_repo
      @path_to_repo = path_to_repo
      @commits_handler = MetricasTesis::CommitsHandler.new path_to_repo
    end

    ##
    # Obtiene los archivos que fueron A, M o D en un grupo de commits
    # Params:
    # +commit_desde+:: se toman los commits desde este commit inclusive
    # +commit_hasta+:: se toman los commits hasta este commit inclusive
    # +condiciones+:: lista que indica que actividad se busca:
    # * +A+:: archivos <b>a</b>gregados
    # * +M+:: archivos <b>m</b>odificados
    # * +D+:: archivos <b>d</b>eleted
    #
    # Devuelve un hash con los archivos que cumplen con las condiciones
    # especificadas en cada commit
    #
    # Lanza la excepción ArgumentError si:
    # - No existe alguno de los commits
    # - +commit_desde+ ocurre luego de +commit_hasta+
    def get_archivos (commit_desde, commit_hasta, condiciones)
      lista_commits = @commits_handler.commits_entre_commits(commit_desde, commit_hasta)

      self.get_archivos_de_lista(lista_commits, condiciones)
    end

    ##
    # Obtiene los archivos que cambiaron en un grupo de commits
    # Params:
    # +lista_commits+:: lista con los commits
    # +condiciones+:: lista que indica que actividad se busca:
    # * +A+:: archivos <b>a</b>gregados
    # * +M+:: archivos <b>m</b>odificados
    # * +D+:: archivos <b>d</b>eleted
    #
    # Devuelve un hash con los archivos que cumplen con las condiciones
    # especificadas en cada commit
    #
    # Lanza la excepción ArgumentError si:
    # - No existe alguno de los commits
    def get_archivos_de_lista (lista_commits, condiciones)
      archivos_cambiados = Hash.new

      regex = ""
      condiciones.each do |condicion|
        if /(^[AMD]$)/ =~ condicion
          regex += condicion
        end
      end

      if !regex.empty?
        regex = '^[' + regex + ']'
      end

      lista_commits.each do |commit|
        if !@commits_handler.existe_commit? commit
          raise ArgumentError, 'commit_desde no existe'
        end
        archivos_cambiados_commit = `git --git-dir='#{@path_to_repo}' diff-tree --no-commit-id --name-status -r #{commit}`.split("\n")
        archivos_cambiados_commit = self.filtrar_archivos(archivos_cambiados_commit, regex)

        archivos_cambiados[commit] = archivos_cambiados_commit
      end

      archivos_cambiados
    end

    ##
    # Filtra que archivos cumplen con un cierto filtro.
    # Params:
    # +archivos+: lista de archivos con el formato +[AMD]+ path/al/archivo
    # +filtro+: filtro a aplicar.
    #
    # Devuelve una lista con los archivos filtrados
    #
    # Ejemplo:
    #   # Filtrar archivos modificados
    #   filtrar_archivos (archs, '^M')
    #
    #   # Filtrar archivos dentro de la carpeta TestData
    #   filtrar_archivos (archs, 'TestData/')
    def filtrar_archivos (archivos, filtro)
      archivos_filtrados = Array.new
      archivos.each do |archivo|
        if /#{filtro}/ =~ archivo
          archivos_filtrados << archivo
        end
      end
      archivos_filtrados
    end
  end
end
