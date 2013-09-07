# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'archivos_commits_handler'
require 'commits_handler'

module Fixtures
  class ContarArchivosModificadosEntreCommits
    def initialize
      path_repos = '/home/stoma/Documents/ruby/MetricasTesis'
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

    def cantidad_archivos_modificados
      0
    end
  end
end
