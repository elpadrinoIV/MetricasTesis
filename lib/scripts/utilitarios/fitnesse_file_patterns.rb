
module MetricasTesis
  module Scripts
    module Utilitarios
      ##
      # Clase para no estar escribiendo todo el tiempo los patrones de
      # pruebas de aceptación, unitarias y código cada vez
      class FitnesseFilePatterns
        def self.get_patron_pruebas_aceptacion
          patron = MetricasTesis::AntPatternFilter.new
          # patron.set_fileset('FitNesseRoot/FitNesse/SuiteAcceptanceTests/')
          patron.add_include('FitNesseRoot/FitNesse/SuiteAcceptanceTests/**/content.txt')
          patron.add_include('src/fitnesse/fixtures/*.java')
          patron
        end

        def self.get_patron_pruebas_unitarias
          patron = MetricasTesis::AntPatternFilter.new
          patron.set_fileset('src/')
          patron.add_include('**/*Test.java')
          patron.add_exclude('**/ShutdownResponderTest.java')
          patron.add_exclude('**/QueryTableBaseTest.java')
          patron.add_exclude('**/Test.java')
          patron.add_exclude('**/SystemUnderTest.java')
          patron.add_exclude('**/MySystemUnderTest.java')
          patron
        end

        def self.get_patron_codigo
          patron= MetricasTesis::AntPatternFilter.new
          patron.set_fileset('src/')
          patron.add_include('fit/**/*.java')
          patron.add_include('fitnesse/**/*.java')
          patron.add_include('fitnesseMain/**/*.java')
          patron.add_include('util/**/*.java')
          patron.add_exclude('**/*Test.java')
          patron.add_exclude('**/fixtures/**')
          patron
        end
      end
    end
  end
end
