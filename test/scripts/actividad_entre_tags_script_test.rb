require 'test/unit'

require 'actividad_entre_tags_script'
class ActividadEntreTagsScriptTest < Test::Unit::TestCase
  def setup
    path_repos = './.git'
    @script = MetricasTesis::Scripts::ActividadEntreTagsScript.new path_repos
  end

  def test_resumen_actividad
    # col1   col2   col3
    #  1      0      2
    #  2      1      5
    #  3      4      11
    #  4      0      20
    #
    #  Resumen:
    # Col1: 10, Col2: 5, Col3: 38

    actividad = Array.new
    actividad << {:col1 => 1, :col2 => 0, :col3 => 2}
    actividad << {:col1 => 2, :col2 => 1, :col3 => 5}
    actividad << {:col1 => 3, :col2 => 4, :col3 => 11}
    actividad << {:col1 => 4, :col2 => 0, :col3 => 20}

    resumen = @script.get_resumen_actividad(actividad)
    assert_equal(10, resumen[:col1])
    assert_equal(5, resumen[:col2])
    assert_equal(38, resumen[:col3])
  end
end
