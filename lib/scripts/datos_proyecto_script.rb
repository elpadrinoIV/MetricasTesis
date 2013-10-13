require 'dir_loader'
require 'array_to_table'
require 'table_to_array'

require 'commits_handler'
require 'analizador_modificaciones'
require 'tags_handler'

require 'fitnesse_file_patterns'
require 'ant_pattern_filter'
require 'archivos_commits_handler'

require 'estadistica'

module MetricasTesis
  module Scripts
    class DatosProyectoScript
      attr_accessor :lista_tags, :lista_excluded_tags, :lista_excluded_commits,
        :pattern_acceptance_tests, :pattern_unit_tests, :pattern_codigo
        
      def initialize path_repos
        @path_repos = path_repos
        path = File.dirname(__FILE__) + '/directorios'

        @commits_handler = MetricasTesis::CommitsHandler.new path_repos
        @analizador_modificaciones = MetricasTesis::AnalizadorModificaciones.new path_repos
        @archivos_commits_handler = MetricasTesis::ArchivosCommitsHandler.new path_repos

        @dir_loader = Scripts::DirLoader.new
        @dir_loader.cargar_datos_de_archivo(path)

        @lista_tags = Array.new
      end

      def get_datos_proyecto(tag_desde, tag_hasta)
        commits = @commits_handler.commits_entre_tags(tag_desde, tag_hasta)

        datos_commits = Array.new
        commits = commits - @lista_excluded_commits
        commits.each do |commit|
          fecha_iso = @commits_handler.fecha_commit(commit, :iso)
          fecha_timestamp = @commits_handler.fecha_commit(commit, :timestamp)
          fila = Hash.new
          fila[:commit_hash] = commit
          fila[:fecha_iso] = "\"#{fecha_iso}\""
          fila[:fecha_timestamp] = fecha_timestamp

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
            cantidad_archivos_modificados_at += 1 if @analizador_modificaciones.hay_cambio_no_trivial?(archivo, commit)
          end

          cantidad_archivos_modificados_ut = 0
          archivos_modificados_ut.each do |archivo|
            cantidad_archivos_modificados_ut += 1 if @analizador_modificaciones.hay_cambio_no_trivial?(archivo, commit)
          end

          cantidad_archivos_modificados_codigo = 0
          archivos_modificados_codigo.each do |archivo|
            cantidad_archivos_modificados_codigo += 1 if @analizador_modificaciones.hay_cambio_no_trivial?(archivo, commit)
          end

          fila[:archivos_modificados_at] = cantidad_archivos_modificados_at
          fila[:archivos_modificados_ut] = cantidad_archivos_modificados_ut
          fila[:archivos_modificados_codigo] = cantidad_archivos_modificados_codigo

          datos_commits << fila
        end

        datos = procesar_commits(datos_commits)
        datos
      end

      def run
        puts "RUNNING"

        datos_proyecto = Array.new

        if @lista_tags.empty?
          tags_handler = MetricasTesis::TagsHandler.new @path_repos
          @lista_tags = tags_handler.get_tags
        end

        @lista_tags = @lista_tags - @lista_excluded_tags

        tag_desde = @lista_tags.shift
        @lista_tags.each do |tag|
          puts "TAG_DESDE: #{tag_desde}  - TAG_HASTA: #{tag} "
          datos_tag = get_datos_proyecto(tag_desde, tag)

          datos_tag[:tag_desde] = "\"#{tag_desde}\""
          datos_tag[:tag_hasta] = "\"#{tag}\""
          
          datos_proyecto << datos_tag

          tag_desde = tag
        end

        tabla_datos_proyecto = MetricasTesis::Scripts::Utilitarios::ArrayToTable.convertir datos_proyecto
        dir_salida = @dir_loader.get_directorio("DATA")
        archivo_salida = dir_salida + "datos_proyecto.csv"
        MetricasTesis::Scripts::Utilitarios::ArrayToTable.guardar_tabla(tabla_datos_proyecto, archivo_salida, "\t")
      end

      def procesar_commits datos_commits
        resultado = Hash.new
        cantidad_commits = datos_commits.size
        
        # media y desvio de tiempo entre commits
        lista_timestamps = Array.new
        datos_commits.each{ |commit| lista_timestamps << commit[:fecha_timestamp].to_i}
        
        lista_timestamps.sort!

        timestamp_primer_commit = lista_timestamps.min
        timestamp_ultimo_commit = lista_timestamps.max

        # calculo la diferencia entre una fecha y la siguiente
        # ruby rocks!
        diferencia_timestamps = lista_timestamps.each_cons(2).map{|primero, segundo| segundo - primero}

        media_tiempo_entre_commits = diferencia_timestamps.mean
        # El desvío es malísimo, no tiene sentido calcularlo.
        # desviacion_standard_tiempo_entre_commits = diferencia_timestamps.standard_deviation

        # Análisis archivos modificados
        archivos_modificados_at = Array.new
        datos_commits.each{ |commit| archivos_modificados_at << commit[:archivos_modificados_at].to_i}

        archivos_modificados_ut = Array.new
        datos_commits.each{ |commit| archivos_modificados_ut << commit[:archivos_modificados_ut].to_i}

        archivos_modificados_codigo = Array.new
        datos_commits.each{ |commit| archivos_modificados_codigo << commit[:archivos_modificados_codigo].to_i}

        todos_los_archivos_modificados = Array.new
        datos_commits.each{ |commit| todos_los_archivos_modificados << commit[:archivos_modificados_at].to_i +
                                                                       commit[:archivos_modificados_ut].to_i +
                                                                       commit[:archivos_modificados_codigo].to_i}

        resultado[:cantidad_commits] = cantidad_commits
        resultado[:tiempo_dias] = ((timestamp_ultimo_commit - timestamp_primer_commit)/60.0/60.0/24.0).round
        resultado[:media_tiempo_horas_entre_commits] = (media_tiempo_entre_commits/60.0/60.0).round

        resultado[:media_archivos_at_por_commit] = archivos_modificados_at.mean.round(1)
        resultado[:media_archivos_ut_por_commit] = archivos_modificados_ut.mean.round(1)
        resultado[:media_archivos_codigo_por_commit] = archivos_modificados_codigo.mean.round(1)
        resultado[:media_archivos_modificados_por_commit] = todos_los_archivos_modificados.mean.round(1)

        resultado
      end

    end
  end
end

if "RUN_SCRIPT" == ARGV[0]
  git_dir_fitnesse = File.dirname(__FILE__) + '/../../../fitnesse/.git'

  script = MetricasTesis::Scripts::DatosProyectoScript.new git_dir_fitnesse
  script.pattern_acceptance_tests = MetricasTesis::Scripts::Utilitarios::FitnesseFilePatterns.get_patron_pruebas_aceptacion
  script.pattern_unit_tests = MetricasTesis::Scripts::Utilitarios::FitnesseFilePatterns.get_patron_pruebas_unitarias
  script.pattern_codigo = MetricasTesis::Scripts::Utilitarios::FitnesseFilePatterns.get_patron_codigo
  
  script.lista_excluded_tags = ["list", "nonewtmpl"]
  script.lista_excluded_commits = []
  script.run
end