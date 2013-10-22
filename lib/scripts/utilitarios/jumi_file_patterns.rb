require 'ant_pattern_filter'
module MetricasTesis
  module Scripts
    module Utilitarios
      ##
      # Clase para no estar escribiendo todo el tiempo los patrones de
      # pruebas de aceptación, unitarias y código cada vez
      class JumiFilePatterns
        def self.get_patron_pruebas_aceptacion
          patron = MetricasTesis::AntPatternFilter.new
          patron.set_fileset('end-to-end-tests')
          patron.add_include('**/*.java')
          patron
        end

        def self.get_patron_pruebas_unitarias
          patron = MetricasTesis::AntPatternFilter.new
          # patron.set_fileset('src/')
          patron.add_include('jumi-api/**/*Test.java')
          patron.add_include('jumi-core/**/*Test.java')
          patron.add_include('jumi-daemon/**/*Test.java')
          patron.add_include('jumi-launcher/**/*Test.java')
          patron
        end

        def self.get_patron_codigo
          patron= MetricasTesis::AntPatternFilter.new
          # patron.set_fileset('src/')
          patron.add_include('jumi-api/**/*.java')
          patron.add_include('jumi-core/**/*.java')
          patron.add_include('jumi-daemon/**/*.java')
          patron.add_include('jumi-launcher/**/*.java')

          patron.add_exclude('**/*Test.java')
          patron
        end
      end
    end
  end
end
