
require 'base_fila_query'
require 'actividad_entre_tags_script'
require 'ant_pattern_filter'
module Fixtures
  module Scripts
    class ContarActividadEntreTags
      def initialize tag_desde, tag_hasta
        @tag_desde = tag_desde
        @tag_hasta = tag_hasta
        @script = MetricasTesis::Scripts::ActividadEntreTagsScript.new './.git'

        set_patron_acceptance_tests
        set_patron_unit_tests
        set_patron_codigo
      end

      def query
        # lista_commits = @commits_handler.commits_entre_tags(@tag_inicial, @tag_final)
        resultado = Array.new

        actividades_commits = @script.get_actividad_entre_tags(@tag_desde, @tag_hasta)
        actividades_commits.each do |actividad_commit|
          resultado << Fixtures::Utilitarios::BaseFilaQuery.convertir_a_query_row_desde_hash(actividad_commit)
        end

        resultado
      end

      private
      def set_patron_acceptance_tests
        patron_filter = MetricasTesis::AntPatternFilter.new
        # patron_filter.set_fileset('FitNesseRoot/FrontPage/MetricasTesisProject/')
        # patron_filter.add_include('**/content.txt')

        patron_filter.add_include('FitNesseRoot/FrontPage/MetricasTesisProject/**/content.txt')
        patron_filter.add_include('lib/fixtures/**/*.rb')
        @script.pattern_acceptance_tests = patron_filter
      end

      def set_patron_unit_tests
        patron_filter = MetricasTesis::AntPatternFilter.new
        patron_filter.set_fileset('test/')
        patron_filter.add_include('**/*_test.rb')
        @script.pattern_unit_tests = patron_filter
      end

      def set_patron_codigo
        patron_filter = MetricasTesis::AntPatternFilter.new
        patron_filter.set_fileset('lib/')
        patron_filter.add_include('metricas_tesis/**/*.rb')
        patron_filter.add_include('scripts/**/*.rb')
        @script.pattern_codigo = patron_filter
      end
    end
  end
end
