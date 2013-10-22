require 'jumi_file_patterns'

module MetricasTesis
  module Scripts
    module Utilitarios
      class DatosJumi
        attr_reader :git_dir, :pattern_acceptance_tests, :pattern_unit_tests, :pattern_codigo,
          :lista_excluded_tags, :lista_excluded_commits, :lista_excluded_files,
          :tag_referencia

        def initialize
          @git_dir = File.dirname(__FILE__) + '/../../../../jumi/.git'
          @pattern_acceptance_tests = MetricasTesis::Scripts::Utilitarios::JumiFilePatterns.get_patron_pruebas_aceptacion
          @pattern_unit_tests = MetricasTesis::Scripts::Utilitarios::JumiFilePatterns.get_patron_pruebas_unitarias
          @pattern_codigo = MetricasTesis::Scripts::Utilitarios::JumiFilePatterns.get_patron_codigo
          @lista_excluded_tags = []
          @lista_excluded_commits = []
          @lista_excluded_files = ['jumi-core/src/test/java/fi/jumi/core/files/FileNamePatternTestClassFinderTest.java',
            'jumi-core/src/test/java/fi/jumi/core/discovery/PathMatcherTestFileFinderTest.java'
          ]

          @tag_referencia = 'v0.5.390'
        end
      end
    end
  end
end