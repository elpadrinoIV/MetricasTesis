require 'actividad_simultanea_entre_tags_script'
module Fixtures
  class ContarActividadSimultanea
    def initialize
      @commits = Array.new
      @script = MetricasTesis::Scripts::ActividadSimultaneaEntreTagsScript.new('')
    end

    def agregar_commit at, ut, codigo
      @commits << {:acceptance_tests_modificados => at,
        :unit_tests_modificados => ut,
        :codigo_modificados => codigo}
    end

    def codigo
      @script.get_actividad_simultanea_de_commits(@commits, :cantidad)[:codigo]
    end

    def ut
      @script.get_actividad_simultanea_de_commits(@commits, :cantidad)[:ut]
    end

    def at
      @script.get_actividad_simultanea_de_commits(@commits, :cantidad)[:at]
    end

    def ut_codigo
      @script.get_actividad_simultanea_de_commits(@commits, :cantidad)[:ut_codigo]
    end

    def at_codigo
      @script.get_actividad_simultanea_de_commits(@commits, :cantidad)[:at_codigo]
    end

    def at_ut
      @script.get_actividad_simultanea_de_commits(@commits, :cantidad)[:at_ut]
    end

    def at_ut_codigo
      @script.get_actividad_simultanea_de_commits(@commits, :cantidad)[:at_ut_codigo]
    end

    def codigo_porcentaje
      @script.get_actividad_simultanea_de_commits(@commits, :porcentaje)[:codigo]
    end

    def ut_porcentaje
      @script.get_actividad_simultanea_de_commits(@commits, :porcentaje)[:ut]
    end

    def at_porcentaje
      @script.get_actividad_simultanea_de_commits(@commits, :porcentaje)[:at]
    end

    def ut_codigo_porcentaje
      @script.get_actividad_simultanea_de_commits(@commits, :porcentaje)[:ut_codigo]
    end

    def at_codigo_porcentaje
      @script.get_actividad_simultanea_de_commits(@commits, :porcentaje)[:at_codigo]
    end

    def at_ut_porcentaje
      @script.get_actividad_simultanea_de_commits(@commits, :porcentaje)[:at_ut]
    end

    def at_ut_codigo_porcentaje
      @script.get_actividad_simultanea_de_commits(@commits, :porcentaje)[:at_ut_codigo]
    end
  end
  
end
