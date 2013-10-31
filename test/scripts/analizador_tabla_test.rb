require 'test/unit'

require 'analizador_tabla'
class DirLoaderTest < Test::Unit::TestCase
  def setup
  end

  def test_calcular_total
    tabla = Array.new
    tabla << {:col1 => 1, :col2 => 11, :col3 => "Cadena1"}
    tabla << {:col1 => 2, :col2 => 12, :col3 => "Cadena2"}
    tabla << {:col1 => 3, :col2 => 13, :col3 => "Cadena3"}

    total = MetricasTesis::Scripts::Utilitarios::AnalizadorTabla.calcular_total(tabla)

    esperado = {:col1 => 6, :col2 =>36}

    assert_equal(esperado, total)
  end
end

