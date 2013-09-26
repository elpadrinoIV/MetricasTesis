require 'test/unit'

require 'analizador_modificaciones_java'
class DeteccionModificacionesNoTrivialesTest < Test::Unit::TestCase
  def setup
    path_repos = './.git'
    @analizador = MetricasTesis::AnalizadorModificacionesJava.new(path_repos)
    @archivo = 'TestData/Java/TestUnitarioNumero1.java'
  end
=begin
  def test_cambios_line_ending
    # Cambiado line-ending (dos2unix)
    commit_hash = '8ff6591e0e22d058e40781a933a84e0d70c4d4d4'

    cantidad_cambios = @analizador.cambios_no_triviales(@archivo, commit_hash)
    assert_equal(0, cantidad_cambios)
  end

  def test_cambios_espacios_y_tabs
    # Cambiados tabs por espacios
    commit_hash = '235f30edecee9fc41bc8817b34c3fe56900e5108'

    cantidad_cambios = @analizador.cambios_no_triviales(@archivo, commit_hash)
    assert_equal(0, cantidad_cambios)
  end

  def test_lineas_vacias_agregadas
    # Agregadas lineas vacias
    commit_hash = '7aa6dffa50f5dd4b3feefc3e8f4ca9b0b33d2581'

    cantidad_cambios = @analizador.cambios_no_triviales(@archivo, commit_hash)
    assert_equal(0, cantidad_cambios)
  end

  def test_lineas_vacias_eliminadas
    # Lineas vacias eliminadas
    commit_hash = 'da33a53ad23d294cb1e4494e7f69f22a5e4fafda'

    cantidad_cambios = @analizador.cambios_no_triviales(@archivo, commit_hash)
    assert_equal(0, cantidad_cambios)
  end

  def test_espacios_agregados_y_eliminados
    # Agregando espacios y quitando espacios
    commit_hash = '4101d499febf8a4dbf1959dacca37d03751c521f'

    cantidad_cambios = @analizador.cambios_no_triviales(@archivo, commit_hash)
    assert_equal(0, cantidad_cambios)

    # Volviendo para atras con los cambios de espacios
    commit_hash = 'e2cf492eee985bae584e7a6134b7367f505f759f'

    cantidad_cambios = @analizador.cambios_no_triviales(@archivo, commit_hash)
    assert_equal(0, cantidad_cambios)
  end

  def test_lineas_codigo_agregadas
    # Agregando lineas.
    commit_hash = '492df8bfd08bc2ff7ee316febf0c0995276fb8f5'

    cantidad_cambios = @analizador.cambios_no_triviales(@archivo, commit_hash)
    assert_equal(6, cantidad_cambios)
  end
=end
end
