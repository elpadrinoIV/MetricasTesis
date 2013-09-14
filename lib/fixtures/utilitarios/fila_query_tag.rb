# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'base_fila_query'
module Fixtures
  module Utilitarios
    class FilaQueryTag < Fixtures::Utilitarios::BaseFilaQuery
      attr_accessor :commit_hash
      
      def initialize commit_hash
        @commit_hash = commit_hash
      end
    end
  end
end
