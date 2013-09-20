module MetricasTesis
  class CommitsHandler
    def initialize path_to_repo
      @path_to_repo = path_to_repo
    end

    # Devuelve una lista con todos los commits
    def commits
    end

    ##
    # Devuelve una lista con todos los commits que se encuentran
    # entre ambos commits.
    # Params:
    # +commit_desde+:: se toman los commits desde este commit inclusive
    # +commit_hasta+:: se toman los commits hasta este commit inclusive
    # +filtro+:: REGEX a buscar en el mensaje del commit.
    #
    # Lanza la excepción ArgumentError si:
    # - No existe alguno de los commits
    # - +commit_desde+ ocurre luego de +commit_hasta+
    def commits_entre_commits (commit_desde, commit_hasta, filtro="")
      if !existe_commit? commit_desde
        raise ArgumentError, 'commit_desde no existe'
      end

      if !existe_commit? commit_hasta
        raise ArgumentError, 'commit_hasta no existe'
      end

      commits = `git --git-dir='#{@path_to_repo}' log --pretty=format:"%H" --reverse`.split
      
      commits_reales = Array.new
      ya_encontre_commit_desde = false
      ya_encontre_commit_hasta = false
      commits.each do |commit|
        if commit == commit_desde
          ya_encontre_commit_desde = true
        end
        
        if ya_encontre_commit_desde && !ya_encontre_commit_hasta
          commits_reales << commit
        end

        if commit == commit_hasta
          ya_encontre_commit_hasta = true
        end
      end

      if ya_encontre_commit_desde && ya_encontre_commit_hasta
        commits = commits_reales
      else
        commits = Array.new
      end
      
      if (commits.empty?)
        raise ArgumentError, 'no se puede llegar de commit_desde a commit_hasta'
      end

      if !filtro.empty?
        commits = self.filtrar_commits(commits, filtro)
      end

      commits
    end

    ##
    # Devuelve una lista con todos los commits que se encuentran
    # entre 2 tags.
    # Params:
    # +tag_desde+:: nombre tag
    # +tag_hasta+:: nombre tag
    # +filtro+:: REGEX a buscar en el mensaje del commit.
    #
    # Lanza la excepción ArgumentError si:
    # - No existe alguno de los commits
    # - +tag_desde+ ocurre luego de +tag_hasta+
    def commits_entre_tags (tag_desde, tag_hasta, filtro="")
      if !existe_commit? tag_desde
        raise ArgumentError, 'tag_desde no existe'
      end

      if !existe_commit? tag_hasta
        raise ArgumentError, 'tag_hasta no existe'
      end

      commits = `git --git-dir='#{@path_to_repo}' log --pretty=format:"%H" --reverse #{tag_desde..tag_hasta}`.split

      commits_reales = Array.new

      if !filtro.empty?
        commits = self.filtrar_commits(commits, filtro)
      end

      commits
    end

    ##
    # Indica si un hash corresponde a un commit del proyecto
    # Params:
    # +commit_hash+:: hash
    def existe_commit? (commit_hash)
      `git  --git-dir='#{@path_to_repo}'  rev-list #{commit_hash} 2>&1`; existe=$?.success?
      existe
    end

    def filtrar_commits (commits, filtro)
      commits_filtrados = Array.new

      commits.each do |commit|
        mensaje = `git  --git-dir='#{@path_to_repo}'  show -s --oneline #{commit}`
        
        if /#{filtro}/ =~ mensaje
          commits_filtrados << commit
        end
      end

      commits_filtrados
    end

    def fecha_commit commit_hash, formato_fecha
      if !existe_commit?(commit_hash)
        raise ArgumentError, 'no existe commit #{commit_hash}'
      end

      if (:iso != formato_fecha && :timestamp != formato_fecha)
        raise ArgumentError, 'los formatos de fecha solo pueden ser ":iso" o ":timestamp"'
      end

      opcion_formato_fecha = ""
      case formato_fecha
      when :iso
        opcion_formato_fecha = '%ci'
      when :timestamp
        opcion_formato_fecha = '%ct'
      end

      fecha = `git --git-dir='#{@path_to_repo}' show -s --format="#{opcion_formato_fecha}" #{commit_hash} 2>&1`
      fecha.chomp!.chomp!
      fecha
    end
  end
end
