require 'dir_loader'
require 'array_to_table'
require 'table_to_array'


module MetricasTesis
  module Scripts
    class ActividadSimultaneaEntreTagsScript
      attr_accessor :at_symbol, :ut_symbol, :codigo_symbol
      
      def initialize
        path = File.dirname(__FILE__) + '/directorios'
        
        @dir_loader = Scripts::DirLoader.new
        @dir_loader.cargar_datos_de_archivo(path)

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
      end

    end
  end
end

if "RUN_SCRIPT" == ARGV[0]

  # script = MetricasTesis::Scripts::ActividadEntreTagsScript.new git_dir_fitnesse

  # script.lista_excluded_tags = ["list", "nonewtmpl"]
  # script.run
end