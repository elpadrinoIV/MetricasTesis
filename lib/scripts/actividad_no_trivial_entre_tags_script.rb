require 'dir_loader'
require 'array_to_table'
require 'fitnesse_file_patterns'

require 'ant_pattern_filter'

require 'analizador_modificaciones'

require 'commits_handler'
require 'archivos_commits_handler'
require 'tags_handler'

module MetricasTesis
  module Scripts
    class ActividadNoTrivialEntreTagsScript
      attr_accessor :pattern_acceptance_tests, :pattern_unit_tests, :pattern_codigo,
        :lista_tags, :lista_excluded_tags, :lista_excluded_commits

      def initialize path_repos
        @path_repos = path_repos
        @commits_handler = MetricasTesis::CommitsHandler.new path_repos
        @archivos_commits_handler = MetricasTesis::ArchivosCommitsHandler.new path_repos
        @analizador_modificaciones = MetricasTesis::AnalizadorModificaciones.new path_repos
        
        path = File.dirname(__FILE__) + '/directorios'
        
        @dir_loader = Scripts::DirLoader.new
        @dir_loader.cargar_datos_de_archivo(path)

        @lista_tags = Array.new
        @lista_excluded_tags = Array.new
      end

      def get_actividad_entre_tags tag_desde, tag_hasta
        
        commits = @commits_handler.commits_entre_tags(tag_desde, tag_hasta)
        
        resultado = Array.new
        # commits = filter_list(commits, @lista_excluded_commits)
        commits = commits - @lista_excluded_commits
        commits.each do |commit|
          puts "Checking commit #{commit}"
          fecha_iso = @commits_handler.fecha_commit(commit, :iso)
          fecha_timestamp = @commits_handler.fecha_commit(commit, :timestamp)

          archivos_modificados = @archivos_commits_handler.get_archivos_de_lista([commit], ['M']).values.flatten
          
          archivos_modificados_at = @pattern_acceptance_tests.filtrar(archivos_modificados)
          archivos_modificados_ut = @pattern_unit_tests.filtrar(archivos_modificados)
          archivos_modificados_codigo = @pattern_codigo.filtrar(archivos_modificados)

          archivos_modificados_ut = archivos_modificados_ut - ['src/fitnesse/components/ClassPathBuilderTest.java', # /* dentro de string ("... /* ...")
            'src/fitnesse/components/ContentBufferTest.java',
            'src/fitnesse/http/RequestTest.java',
            'src/fitnesse/wikitext/widgets/ClasspathWidgetTest.java'            
          ]

          cantidad_archivos_modificados_at = 0
          archivos_modificados_at.each do |archivo|
            if (archivos_modificados_at.size > 0)
              print "  - AT #{archivo}: "
              $stdout.flush
              if @analizador_modificaciones.hay_cambio_no_trivial?(archivo, commit)
                print "SI\n"
                cantidad_archivos_modificados_at += 1
              else
                print "NO\n"
              end
              
            else
              cantidad_archivos_modificados_at += 1 if @analizador_modificaciones.hay_cambio_no_trivial?(archivo, commit)
            end
          end

          cantidad_archivos_modificados_ut = 0
          archivos_modificados_ut.each do |archivo|
            if (archivos_modificados_ut.size > 0)
              print "  - UT #{archivo}: "
              $stdout.flush
              if @analizador_modificaciones.hay_cambio_no_trivial?(archivo, commit)
                print "SI\n"
                cantidad_archivos_modificados_ut += 1
              else
                print "NO\n"
              end

            else
              cantidad_archivos_modificados_ut += 1 if @analizador_modificaciones.hay_cambio_no_trivial?(archivo, commit)
            end
          end

          cantidad_archivos_modificados_codigo = 0
          archivos_modificados_codigo.each do |archivo|
            if (archivos_modificados_codigo.size > 0)
              print "  - COD #{archivo}: "
              $stdout.flush
              if @analizador_modificaciones.hay_cambio_no_trivial?(archivo, commit)
                print "SI\n"
                cantidad_archivos_modificados_codigo += 1
              else
                print "NO\n"
              end
            else
              cantidad_archivos_modificados_codigo += 1 if @analizador_modificaciones.hay_cambio_no_trivial?(archivo, commit)
            end
          end

          cantidad_archivos_modificados_otros = archivos_modificados.size -
            cantidad_archivos_modificados_at -
            cantidad_archivos_modificados_ut -
            cantidad_archivos_modificados_codigo

          fila = Hash.new
          fila[:commit_hash] = commit
          
          fila[:fecha_iso] = "\"#{fecha_iso}\""
          fila[:fecha_timestamp] = fecha_timestamp
          
          fila[:acceptance_tests_modificados] = cantidad_archivos_modificados_at
          fila[:unit_tests_modificados] = cantidad_archivos_modificados_ut
          fila[:codigo_modificados] = cantidad_archivos_modificados_codigo
          fila[:otro_modificados] = cantidad_archivos_modificados_otros

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

        columnas = [
          :acceptance_tests_modificados,
          :unit_tests_modificados,
          :codigo_modificados,
          :otro_modificados]

        filter_excluded_tags()
        
        tag_desde = @lista_tags.shift
        @lista_tags.each do |tag|
          puts "TAG_DESDE: #{tag_desde}  - TAG_HASTA: #{tag} "
          actividad = get_actividad_entre_tags(tag_desde, tag)
          resumen_actividad = get_resumen_actividad(actividad, columnas)
          resumen_actividad[:tag] = "\"#{tag}\""
          resumen_actividad_por_tag << resumen_actividad

          tabla = MetricasTesis::Scripts::Utilitarios::ArrayToTable.convertir actividad
          dir_salida = @dir_loader.get_directorio("DATA")
          archivo_salida = dir_salida + "actividad_no_trivial_#{tag_desde}_to_#{tag}.csv"
          MetricasTesis::Scripts::Utilitarios::ArrayToTable.guardar_tabla(tabla, archivo_salida, "\t")
          tag_desde = tag
        end

        tabla_resumen = MetricasTesis::Scripts::Utilitarios::ArrayToTable.convertir resumen_actividad_por_tag

        dir_salida = @dir_loader.get_directorio("DATA")
        archivo_salida = dir_salida + "resumen_actividad_no_trivial.csv"
        MetricasTesis::Scripts::Utilitarios::ArrayToTable.guardar_tabla(tabla_resumen, archivo_salida, "\t")
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

      def filter_list lista, lista_excluidos
        lista_filtrada = Array.new

        lista.each do |elemento|
          if !lista_excluidos.include?(elemento)
            lista_filtrada << elemento
          end
        end

        lista_filtrada
      end

    end
  end
end

if "RUN_SCRIPT" == ARGV[0]
  
  git_dir_fitnesse = File.dirname(__FILE__) + '/../../../fitnesse/.git'

  script = MetricasTesis::Scripts::ActividadNoTrivialEntreTagsScript.new git_dir_fitnesse

  script.pattern_acceptance_tests = MetricasTesis::Scripts::Utilitarios::FitnesseFilePatterns.get_patron_pruebas_aceptacion
  script.pattern_unit_tests = MetricasTesis::Scripts::Utilitarios::FitnesseFilePatterns.get_patron_pruebas_unitarias
  script.pattern_codigo = MetricasTesis::Scripts::Utilitarios::FitnesseFilePatterns.get_patron_codigo

  script.lista_excluded_tags = ["list", "nonewtmpl"]
  script.lista_excluded_commits = []
  # script.lista_excluded_commits = ['c1e4c47555cea326a6d3c93185c90a3df2d13b84',
  #  'ba03fe1917ae022427607c4270e643ccd78ec118',
  #  '3bec390e6f8e9e341149b7d060551a92b93d3154',
  #  '0a7a350f082f787f0e534f5ae75937dd2d91d0b9']
  script.run
  # analizador = MetricasTesis::AnalizadorModificacionesJava.new git_dir_fitnesse
  # puts analizador.hay_cambio_no_trivial?('src/fitnesse/components/ClassPathBuilderTest.java', '0a7a350f082f787f0e534f5ae75937dd2d91d0b9')
end

