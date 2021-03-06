require 'analizador_modificaciones'
module Fixtures
  class ContarModificacionesNoTrivialesEnCommit
    def initialize
      @analizador = MetricasTesis::AnalizadorModificaciones.new('./.git')
    end

    def set_commit_hash commit_hash
      @commit_hash = commit_hash
    end

    def archivos_modificados
      cantidad_archivos_modificados = @analizador.archivos_con_cambios_no_triviales(@commit_hash)
      cantidad_archivos_modificados > 0
    end
  end
end
