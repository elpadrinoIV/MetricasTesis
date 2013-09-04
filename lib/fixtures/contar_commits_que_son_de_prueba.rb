# To change this template, choose Tools | Templates
# and open the template in the editor.

module Fixtures
  class ContarCommitsQueSonDePrueba
    def initialize
    end

    def set_hash_commit_desde (hash)
      @commit_desde = hash
    end

    def set_hash_commit_hasta (hash)
      @commit_hasta = hash
    end

    def cantidad_commits_de_prueba
      0
    end
  end
end
