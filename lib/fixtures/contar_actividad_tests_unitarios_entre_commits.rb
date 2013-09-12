# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'ant_pattern_filter'
require 'archivos_commits_handler'
require 'commits_handler'

module Fixtures
  class ContarActividadTestsUnitariosEntreCommits
    def initialize
      path_repos = '../fitnesse/.git'
      @commits_handler = MetricasTesis::CommitsHandler.new(path_repos)
      @archivos_commits_handler = MetricasTesis::ArchivosCommitsHandler.new(path_repos)
      @patron_filter = MetricasTesis::AntPatternFilter.new
      @datos_patron = Fixtures::SetUpPatron.get_patron

      @patron_filter.set_fileset(@datos_patron.fileset)

      @datos_patron.includes.each do |include|
        @patron_filter.add_include(include)
      end

      @datos_patron.excludes.each do |exclude|
        @patron_filter.add_exclude(exclude)
      end
    end

    def set_hash_commit_desde hash
      @commit_desde = hash
    end

    def set_hash_commit_hasta hash
      @commit_hasta = hash
    end
   
    def cantidad_archivos_agregados
      cantidad_archivos 'A'
    end

    def cantidad_archivos_modificados
      cantidad_archivos 'M'
    end

    def cantidad_archivos_eliminados
      cantidad_archivos 'D'
    end

    def cantidad_archivos modificador
      lista_commits = @commits_handler.commits_entre_commits(@commit_desde, @commit_hasta)
      hash_archivos = @archivos_commits_handler.get_archivos_de_lista(lista_commits, ["#{modificador}"])
      archivos = hash_archivos.values.flatten
      cantidad = @patron_filter.filtrar(archivos).size
      cantidad
    end
  end
end
