module Fixtures
  class ContarModificacionesNoTrivialesEnCommit
    def initialize

    end

    def set_commit_hash commit_hash
      @commit_hash = commit_hash
    end

    def archivos_modificados
      false
    end
  end
end
