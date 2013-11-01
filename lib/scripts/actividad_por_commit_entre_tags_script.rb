require 'dir_loader'
require 'array_to_table'
require 'table_to_array'
require 'analizador_tabla'

require 'datos_fitnesse'
require 'datos_jumi'

require 'tags_handler'


module MetricasTesis
  module Scripts
    class ActividadPorCommitEntreTagsScript
      attr_accessor :at_symbol, :ut_symbol, :codigo_symbol, :lista_excluded_tags,
        :lista_tags
      
      def initialize path_repos
        @path_repos = path_repos
        path = File.dirname(__FILE__) + '/directorios'
        
        @dir_loader = Scripts::DirLoader.new
        @dir_loader.cargar_datos_de_archivo(path)

        @lista_tags = Array.new

        @at_symbol = :acceptance_tests_modificados
        @ut_symbol = :unit_tests_modificados
        @codigo_symbol = :codigo_modificados
      end

      ##
      # Cuenta en cuantos commits se modificaron:
      # * código
      # * UT
      # * AT
      #
      # Params:
      # +commits+:: lista que indica para cada commit, cuantos AT, UT y código se modificaron
      #
      # Devuelve un hash con los valores para cada uno
      #
      def get_actividad_por_commit commits
        codigo = 0
        ut = 0
        at = 0
        
        commits.each do |commit|
          mod_at = commit[@at_symbol].to_i
          mod_ut = commit[@ut_symbol].to_i
          mod_codigo = commit[@codigo_symbol].to_i

          codigo += 1 if mod_codigo > 0
          ut += 1 if mod_ut > 0
          at += 1 if mod_at > 0
        end

        resultado = {:codigo => codigo, :ut => ut, :at => at}
        resultado
      end

      def run
        puts "RUNNING"

        if @lista_tags.empty?
          tags_handler = MetricasTesis::TagsHandler.new @path_repos
          @lista_tags = tags_handler.get_tags
        end

        @lista_tags = @lista_tags - @lista_excluded_tags

        dir_archivos = @dir_loader.get_directorio("DATA")

        actividad_por_commit_entre_tags = Array.new
        
        tag_desde = @lista_tags.shift
        @lista_tags.each do |tag|
          path_archivo = dir_archivos + "actividad_no_trivial_#{tag_desde}_to_#{tag}.csv"
          archivo = File.readlines(path_archivo)
          commits = MetricasTesis::Scripts::Utilitarios::TableToArray.convertir(archivo, "\t")

          actividad = get_actividad_por_commit(commits)
          
          actividad[:tag] = tag
          
          actividad_por_commit_entre_tags << actividad
          
          tag_desde = tag
        end

        fila_total = MetricasTesis::Scripts::Utilitarios::AnalizadorTabla.calcular_total(actividad_por_commit_entre_tags)
        fila_total[:tag] = "Total"
        actividad_por_commit_entre_tags << fila_total

        tabla_actividad_por_commit = MetricasTesis::Scripts::Utilitarios::ArrayToTable.convertir actividad_por_commit_entre_tags
        
        dir_salida = @dir_loader.get_directorio("DATA")
        archivo_salida = dir_salida + "actividad_por_commit.csv"
        MetricasTesis::Scripts::Utilitarios::ArrayToTable.guardar_tabla(tabla_actividad_por_commit, archivo_salida, "\t")
      end
    end
  end
end

if "RUN_SCRIPT" == ARGV[0]
  datos_proyecto = MetricasTesis::Scripts::Utilitarios::DatosJumi.new
  
  script = MetricasTesis::Scripts::ActividadPorCommitEntreTagsScript.new datos_proyecto.git_dir
  script.lista_excluded_tags = datos_proyecto.lista_excluded_tags
  script.run
end