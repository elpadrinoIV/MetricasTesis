require 'fila_query_tag'
require 'commits_handler'
module Fixtures
  class CommitsEntreTags
    def initialize  tag_inicial, tag_final
      @tag_inicial = tag_inicial
      @tag_final = tag_final

      path_repos = './.git'
      @commits_handler = MetricasTesis::CommitsHandler.new(path_repos)
    end

    def query
      lista_commits = @commits_handler.commits_entre_tags(@tag_inicial, @tag_final)
      resultado = Array.new

      lista_commits.each do |commit_hash|
        fila = Fixtures::Utilitarios::FilaQueryTag.new(commit_hash)
        resultado << fila.convertir_a_query_row
      end
      
      resultado
    end
    
  end
end
