require 'dir_loader'
require 'array_to_table'
require 'fitnesse_file_patterns'

require 'ant_pattern_filter'
require 'commits_handler'
require 'archivos_commits_handler'
require 'tags_handler'

module MetricasTesis
  module Scripts
    class ActividadEntreTagsScript
      attr_accessor :pattern_acceptance_tests, :pattern_unit_tests, :pattern_codigo,
        :lista_tags, :lista_excluded_tags

      def initialize path_repos
        @path_repos = path_repos
        @commits_handler = MetricasTesis::CommitsHandler.new path_repos
        @archivos_commits_handler = MetricasTesis::ArchivosCommitsHandler.new path_repos
        
        path = File.dirname(__FILE__) + '/directorios'
        
        @dir_loader = Scripts::DirLoader.new
        @dir_loader.cargar_datos_de_archivo(path)

        @lista_tags = Array.new
        @lista_excluded_tags = Array.new
      end

      def get_actividad_entre_tags tag_desde, tag_hasta
        
        commits = @commits_handler.commits_entre_tags(tag_desde, tag_hasta)
        
        resultado = Array.new
        commits.each do |commit|
          fecha_iso = @commits_handler.fecha_commit(commit, :iso)
          fecha_timestamp = @commits_handler.fecha_commit(commit, :timestamp)
          
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
          
          fila[:fecha_iso] = fecha_iso
          fila[:fecha_timestamp] = fecha_timestamp
          
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

      def run
        puts "RUNNING"
        if 0 == @lista_tags.size
          tags_handler = MetricasTesis::TagsHandler.new @path_repos
          @lista_tags = tags_handler.get_tags
        end

        resumen_actividad_por_tag = Array.new

        columnas = [:acceptance_tests_agregados,
          :acceptance_tests_modificados,
          :acceptance_tests_eliminados,
          :unit_tests_agregados,
          :unit_tests_modificados,
          :unit_tests_eliminados,
          :codigo_agregados,
          :codigo_modificados,
          :codigo_eliminados,
          :otro_agregados,
          :otro_modificados,
          :otro_eliminados]

        filter_excluded_tags()
        
        tag_desde = @lista_tags.shift
        @lista_tags.each do |tag|
          puts "TAG_DESDE: #{tag_desde}  - TAG_HASTA: #{tag} "
          actividad = get_actividad_entre_tags(tag_desde, tag)
          resumen_actividad = get_resumen_actividad(actividad, columnas)
          resumen_actividad_por_tag << resumen_actividad

          tabla = MetricasTesis::Scripts::Utilitarios::ArrayToTable.convertir actividad
          dir_salida = @dir_loader.get_directorio("DATA")
          archivo_salida = dir_salida + "actividad_#{tag_desde}_to_#{tag}.csv"
          MetricasTesis::Scripts::Utilitarios::ArrayToTable.guardar_tabla_csv(tabla, archivo_salida)
          tag_desde = tag
        end

        tabla_resumen = MetricasTesis::Scripts::Utilitarios::ArrayToTable.convertir resumen_actividad_por_tag
        dir_salida = @dir_loader.get_directorio("DATA")
        archivo_salida = dir_salida + "resumen_actividad.csv"
        MetricasTesis::Scripts::Utilitarios::ArrayToTable.guardar_tabla_csv(tabla_resumen, archivo_salida)
      end

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

      ##
      # Obtiene la suma de valores para cada columna (ver ejemplo)
      #
      # Params:
      # +actividad+: array donde cada elemento es un hash con la info de la columna
      # +columnas+: lista con las columnas que se quieren sumar. Si se deja vacío,
      # se toman todas las columnas
      #
      # Devuelve un hash con la suma de cada columna
      #
      # Ejemplo:
      #   actividad = Array.new
      #   actividad << {:col1 => 1, :col2 => 10, :col3 => 100}
      #   actividad << {:col1 => 2, :col2 => 11, :col3 => 101}
      #   actividad << {:col1 => 3, :col2 => 12, :col3 => 102}
      #
      #   resumen = get_resumen_actividad(actividad)
      #   # resumen = {:col1 => 6, :col2 => 33, :col3 => 303}
      #
      def get_resumen_actividad actividad, columnas=nil
        fila = Hash.new
        claves = Array.new

        if (nil == columnas)
          claves = actividad[0].keys if 0 != actividad.size
        else
          claves = columnas
        end

        claves.each do |clave|
          
          total = actividad.inject(0){|suma, hash| suma + hash[clave]}
          fila[clave] = total
        end

        fila
      end

      private
      def filter_excluded_tags
        lista_filtrada = Array.new
        @lista_tags.each do |tag|
          if !@lista_excluded_tags.include?(tag)
            lista_filtrada << tag
          end
        end

        @lista_tags = lista_filtrada
      end

    end
  end
end

git_dir_fitnesse = File.dirname(__FILE__) + '/../../../fitnesse/.git'

script = MetricasTesis::Scripts::ActividadEntreTagsScript.new git_dir_fitnesse

script.pattern_acceptance_tests = MetricasTesis::Scripts::Utilitarios::FitnesseFilePatterns.get_patron_pruebas_aceptacion
script.pattern_unit_tests = MetricasTesis::Scripts::Utilitarios::FitnesseFilePatterns.get_patron_pruebas_unitarias
script.pattern_codigo = MetricasTesis::Scripts::Utilitarios::FitnesseFilePatterns.get_patron_codigo

script.lista_excluded_tags = ["list", "nonewtmpl"]
script.run
