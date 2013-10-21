require 'fitnesse_file_patterns'

module MetricasTesis
  module Scripts
    module Utilitarios
      class DatosFitnesse
        attr_reader :git_dir, :pattern_acceptance_tests, :pattern_unit_tests, :pattern_codigo,
          :lista_excluded_tags

        def initialize
          @git_dir = File.dirname(__FILE__) + '/../../../../fitnesse/.git'
          @pattern_acceptance_tests = MetricasTesis::Scripts::Utilitarios::FitnesseFilePatterns.get_patron_pruebas_aceptacion
          @pattern_unit_tests = MetricasTesis::Scripts::Utilitarios::FitnesseFilePatterns.get_patron_pruebas_unitarias
          @pattern_codigo = MetricasTesis::Scripts::Utilitarios::FitnesseFilePatterns.get_patron_codigo
          @lista_excluded_tags = ["list", "nonewtmpl"]
        end
      end
    end
  end
end