# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'commits_handler'
module Fixtures
  class ContarCommitsQueSonDePrueba
    def initialize
      path_repos = './.git'
      @commits_handler = MetricasTesis::CommitsHandler.new(path_repos)
    end

    def set_hash_commit_desde hash
      @commit_desde = hash
    end

    def set_hash_commit_hasta hash
      @commit_hasta = hash
    end

    def set_filtro filtro
      @filtro = filtro
    end

    def cantidad_commits_de_prueba
      commits = @commits_handler.commits_entre_commits(@commit_desde, @commit_hasta, @filtro)
      commits.size
    end
  end
end
