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
      # raise ArgumentError, 'commit_desde no existe'
      # hashes = `git log --pretty=format:"%H"`.split
    end
  end
end
