module Fixtures
  class ContarModificacionesNoTrivialesEnCommit
    def initialize

    end

    def set_commit_hash commit_hash
      @commit_hash = commit_hash
    end

    def lineas_modificadas
      0
    end

    def lineas_agregadas
      0
    end

    def lineas_eliminadas
      0
    end
  end
end
