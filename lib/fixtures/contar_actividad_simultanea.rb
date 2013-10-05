require 'actividad_simultanea_entre_tags_script'
module Fixtures
  class ContarActividadSimultanea
    def initialize
      @commits = Array.new
      @script = MetricasTesis::Scripts::ActividadSimultaneaEntreTagsScript.new
    end

    def agregar_commit at, ut, codigo
      @commits << {:acceptance_tests_modificados => at,
        :unit_tests_modificados => ut,
        :codigo_modificados => codigo}
    end

    def codigo
      @script.get_actividad_simultanea_de_commits(@commits)[:codigo]
    end

    def ut
      @script.get_actividad_simultanea_de_commits(@commits)[:ut]
    end

    def at
      @script.get_actividad_simultanea_de_commits(@commits)[:at]
    end

    def ut_codigo
      @script.get_actividad_simultanea_de_commits(@commits)[:ut_codigo]
    end

    def at_codigo
      @script.get_actividad_simultanea_de_commits(@commits)[:at_codigo]
    end

    def at_ut
      @script.get_actividad_simultanea_de_commits(@commits)[:at_ut]
    end

    def at_ut_codigo
      @script.get_actividad_simultanea_de_commits(@commits)[:at_ut_codigo]
    end
  end
  
end
