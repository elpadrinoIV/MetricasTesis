# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'archivos_commits_handler'
require 'commits_handler'

module Fixtures
  class ContarArchivosAgregadosEntreCommits
    def initialize
      path_repos = './.git'
      @commits_handler = MetricasTesis::CommitsHandler.new(path_repos)
      @archivos_commits_handler = MetricasTesis::ArchivosCommitsHandler.new(path_repos)
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

    def cantidad_archivos_agregados
      # lista_commits = @commits_handler.commits_entre_commits(@commit_desde, @commit_hasta, @filtro)
      # archivos_modificados = @archivos_commits_handler.get_archivos_cambiados_de_lista(lista_commits)
      # cantidad = archivos_modificados.values.inject(0) {|total,val| total + val.size}
      0
    end

    def cantidad_archivos_agregados_menos_eliminados
      # lista_commits = @commits_handler.commits_entre_commits(@commit_desde, @commit_hasta, @filtro)
      # archivos_modificados = @archivos_commits_handler.get_archivos_cambiados_de_lista(lista_commits)
      # cantidad = archivos_modificados.values.inject(0) {|total,val| total + val.size}
      0
    end
  end
end
