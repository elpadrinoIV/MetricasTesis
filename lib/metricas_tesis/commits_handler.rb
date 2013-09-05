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
    #
    # Lanza la excepción ArgumentError si:
    # - No existe alguno de los commits
    # - +commit_desde+ ocurre luego de +commit_hasta+
    def commits_entre_commits (commit_desde, commit_hasta)
      if !existe_commit? commit_desde
        raise ArgumentError, 'commit_desde no existe'
      end

      if !existe_commit? commit_hasta
        raise ArgumentError, 'commit_hasta no existe'
      end

      commits = `git rev-list #{commit_desde}^..#{commit_hasta}`.split
      if (commits.empty?)
        raise ArgumentError, 'no se puede llegar de commit_desde a commit_hasta'
      end

      commits
    end

    def existe_commit? (commit_hash)
      `git rev-list #{commit_hash} 2>&1`; existe=$?.success?
      existe
    end
  end
end
