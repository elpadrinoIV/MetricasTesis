# To change this template, choose Tools | Templates
# and open the template in the editor.

module Fixtures
  class StaticPatron
    attr_reader :fileset
    attr_reader :includes
    attr_reader :excludes
    
    def initialize
      @fileset = ""
      @includes = Array.new
      @excludes = Array.new
    end

    def set_fileset fileset
      @fileset = fileset
    end

    def add_include include
      @includes << include
    end

    def add_exclude exclude
      @excludes << exclude
    end
  end
end
