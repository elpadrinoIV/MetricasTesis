# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'commits_handler'
require 'archivos_commits_handler'
module MetricasTesis
  module Scripts
    class ActividadEntreTagsScript
      attr_accessor :pattern_acceptance_tests, :pattern_unit_tests, :pattern_codigo

      def initialize path_repos
        @path_repos = path_repos
        @commits_handler = MetricasTesis::CommitsHandler.new path_repos
        @archivos_commits_handler = MetricasTesis::ArchivosCommitsHandler.new path_repos
      end

      def get_actividad_entre_tags tag_desde, tag_hasta
        commits = @commits_handler.commits_entre_tags(tag_desde, tag_hasta)
        
        resultado = Array.new
        commits.each do |commit|
          archivos_agregados = @archivos_commits_handler.get_archivos(commit, commit, ['A']).values.flatten
          archivos_modificados = @archivos_commits_handler.get_archivos(commit, commit, ['M']).values.flatten
          archivos_eliminados = @archivos_commits_handler.get_archivos(commit, commit, ['D']).values.flatten

          actividad_at = get_actividad_particular :acceptance_tests, archivos_agregados, archivos_modificados, archivos_eliminados
          actividad_ut = get_actividad_particular :unit_tests, archivos_agregados, archivos_modificados, archivos_eliminados
          actividad_codigo = get_actividad_particular :codigo, archivos_agregados, archivos_modificados, archivos_eliminados

          agregados_otros = archivos_agregados.size -
                            actividad_at[:acceptance_tests_agregados] -
                            actividad_ut[:unit_tests_agregados] -
                            actividad_codigo[:codigo_agregados]

          modificados_otros = archivos_modificados.size -
                              actividad_at[:acceptance_tests_modificados] -
                              actividad_ut[:unit_tests_modificados] -
                              actividad_codigo[:codigo_modificados]

          eliminados_otros = archivos_eliminados.size -
                             actividad_at[:acceptance_tests_eliminados] -
                             actividad_ut[:unit_tests_eliminados] -
                             actividad_codigo[:codigo_eliminados]

          fila = Hash.new
          fila[:commit_hash] = commit
          fila.merge!(actividad_at)
          fila.merge!(actividad_ut)
          fila.merge!(actividad_codigo)
          fila[:otro_agregados] = agregados_otros
          fila[:otro_modificados] = modificados_otros
          fila[:otro_eliminados] = eliminados_otros

          resultado << fila
        end

        resultado
      end

      private
      ##
      # +tipo+:: +acceptance_tests+, +:unit_tests+, +:codigo+
      def get_actividad_particular tipo, archivos_agregados, archivos_modificados, archivos_eliminados
        actividad = Hash.new
        nombre_atributo = "pattern_#{tipo}"
        filtro = self.send(nombre_atributo.to_sym)
        archivos_agregados = filtro.filtrar(archivos_agregados)
        archivos_modificados = filtro.filtrar(archivos_modificados)
        archivos_eliminados = filtro.filtrar(archivos_eliminados)
        
        simbolo_agregados = "#{tipo.to_s}_agregados".to_sym
        simbolo_modificados = "#{tipo.to_s}_modificados".to_sym
        simbolo_eliminados = "#{tipo.to_s}_eliminados".to_sym

        actividad[simbolo_agregados] = archivos_agregados.size
        actividad[simbolo_modificados] = archivos_modificados.size
        actividad[simbolo_eliminados] = archivos_eliminados.size
        
        actividad
      end

    end
  end
end
