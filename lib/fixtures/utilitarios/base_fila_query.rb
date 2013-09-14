# To change this template, choose Tools | Templates
# and open the template in the editor.

module Fixtures
  module Utilitarios
    class BaseFilaQuery
      def initialize
      end

      def convertir_a_query_row
        fila = Array.new
        instance_variables.each do |v|
          campo = Array.new
          campo << v.to_s.sub('@', '')
          campo << instance_variable_get(v)
          fila << campo
        end

        fila
      end
    end
  end
end
