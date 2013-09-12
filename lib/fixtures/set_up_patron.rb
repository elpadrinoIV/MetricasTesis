# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'static_patron'
module Fixtures
  @@patron
  class SetUpPatron
    def initialize
       @@patron = Fixtures::StaticPatron.new
    end

    def set_fileset fileset
      @@patron.set_fileset(fileset)
    end

    def add_include include
      @@patron.add_include(include)
    end

    def add_exclude exclude
      @@patron.add_exclude(exclude)
    end

    def self.get_patron
      @@patron
    end
  end
end
