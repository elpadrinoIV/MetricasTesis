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
        :pattern_acceptance_tests, :pattern_unit_tests, :pattern_codigo,
        :tag_referencia
        
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

      def get_datos_archivos
        dir_git_repos = @path_repos.gsub(/\.git$/, '')
        dir_git_repos = Dir.pwd + "/" + dir_git_repos
        
        directorio_original = Dir.pwd

        Dir.chdir(dir_git_repos)
        `git checkout --quiet #{@tag_referencia}`
        todos_los_archivos = `find . | sed 's/^\\.\\///'`.split("\n")
        archivos_at = @pattern_acceptance_tests.filtrar(todos_los_archivos)
        archivos_ut = @pattern_unit_tests.filtrar(todos_los_archivos)
        archivos_codigo = @pattern_codigo.filtrar(todos_los_archivos)

        archivos_at_java_fixtures = Array.new
        archivos_at.each do |archivo|
          archivos_at_java_fixtures << archivo if /\.java$/ =~ archivo
        end

        archivos_at_fitnesse_txt = Array.new
        archivos_at.each do |archivo|
          archivos_at_fitnesse_txt << archivo if /content.txt$/ =~ archivo
        end

        puts "TODOS: #{todos_los_archivos.size}"
        puts "AT: #{archivos_at.size} - JAVA: #{archivos_at_java_fixtures.size} - FITNESSE #{archivos_at_fitnesse_txt.size}"
        puts "UT: #{archivos_ut.size}"
        puts "COD: #{archivos_codigo.size}"

        `git checkout --quiet master`
        Dir.chdir(directorio_original)
      end

      def run
        puts "RUNNING"
        get_datos_archivos
=begin
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
=end
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
  script.tag_referencia = '20130530'
  script.run
end