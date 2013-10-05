require 'dir_loader'
require 'array_to_table'
require 'table_to_array'

require 'tags_handler'


module MetricasTesis
  module Scripts
    class ActividadSimultaneaEntreTagsScript
      attr_accessor :at_symbol, :ut_symbol, :codigo_symbol, :lista_excluded_tags
      
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

      def get_actividad_simultanea_de_commits commits
        ninguno = 0
        codigo = 0
        ut = 0
        at = 0
        ut_codigo = 0
        at_codigo = 0
        at_ut = 0
        at_ut_codigo = 0

        commits.each do |commit|
          mod_at = commit[@at_symbol].to_i
          mod_ut = commit[@ut_symbol].to_i
          mod_codigo = commit[@codigo_symbol].to_i

          if (0 == mod_at && 0 == mod_ut && 0 == mod_codigo )
            # ninguno
            ninguno += 1
          elsif (0 == mod_at && 0 == mod_ut && mod_codigo > 0)
            # solo código
            codigo += 1
          elsif (0 == mod_at && mod_ut > 0 && 0 == mod_codigo)
            # solo ut
            ut += 1
          elsif (mod_at > 0 && 0 == mod_ut && 0 == mod_codigo)
            # solo at
            at += 1
          elsif (0 == mod_at && mod_ut > 0 && mod_codigo > 0)
            # ut y código
            ut_codigo += 1
          elsif (mod_at > 0 && 0 == mod_ut && mod_codigo > 0)
            # at y código
            at_codigo += 1
          elsif (mod_at > 0 && mod_ut > 0 && 0 == mod_codigo)
            # at y ut
            at_ut += 1
          elsif (mod_at > 0 && mod_ut > 0 && mod_codigo > 0)
            at_ut_codigo += 1
          end
        end

        resultado = {:ninguno => ninguno, :codigo => codigo, :ut => ut, :at => at,
          :ut_codigo => ut_codigo, :at_codigo => at_codigo, :at_ut => at_ut,
          :at_ut_codigo => at_ut_codigo}
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

        actividad_simultanea_entre_tags = Array.new

        tag_desde = @lista_tags.shift
        @lista_tags.each do |tag|
          path_archivo = dir_archivos + "actividad_no_trivial_#{tag_desde}_to_#{tag}.csv"
          archivo = File.readlines(path_archivo)
          commits = MetricasTesis::Scripts::Utilitarios::TableToArray.convertir(archivo, "\t")

          actividad = get_actividad_simultanea_de_commits(commits)
          actividad[:tag] = tag

          actividad_simultanea_entre_tags << actividad

          tag_desde = tag
        end

        tabla_actividad = MetricasTesis::Scripts::Utilitarios::ArrayToTable.convertir actividad_simultanea_entre_tags

        dir_salida = @dir_loader.get_directorio("DATA")
        archivo_salida = dir_salida + "actividad_simultanea.csv"
        MetricasTesis::Scripts::Utilitarios::ArrayToTable.guardar_tabla(tabla_actividad, archivo_salida, "\t")

      end

    end
  end
end

if "RUN_SCRIPT" == ARGV[0]
  git_dir_fitnesse = File.dirname(__FILE__) + '/../../../fitnesse/.git'

  script = MetricasTesis::Scripts::ActividadSimultaneaEntreTagsScript.new git_dir_fitnesse

  script.lista_excluded_tags = ["list", "nonewtmpl"]
  script.run
end