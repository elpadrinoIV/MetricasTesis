require 'base_fila_query'

module Fixtures
  module Utilitarios
    class FilaQueryContarActividadEntreTags < Fixtures::Utilitarios::BaseFilaQuery
      attr_accessor :commit_hash, :at_agregados, :at_modificados, :at_eliminados,
                    :ut_agregados, :ut_modificados, :ut_eliminados,
                    :codigo_agregados, :codigo_modificados, :codigo_eliminados,
                    :otro_agregados, :otro_modificados, :otro_eliminados

      def initialize
      end
    end
  end
end
