require 'test/unit'

require 'table_to_array'

class TableToArrayTest < Test::Unit::TestCase
  def setup
    @conversor = MetricasTesis::Scripts::Utilitarios::TableToArray.new
  end

  def test_levantar_tabla_memoria
    tabla = Array.new
    tabla << 'col1	col2	col3'
    tabla << '1234	abcd	"mi string"'
    tabla << '5678	efgh	"otra cadena larga"'
    tabla << '9101	ijkl	"bla"'

    tabla_esperada = Array.new
    tabla_esperada << {:col1 => "1234", :col2 => "abcd", :col3 => "mi string"}
    tabla_esperada << {:col1 => "5678", :col2 => "efgh", :col3 => "otra cadena larga"}
    tabla_esperada << {:col1 => "9101", :col2 => "ijkl", :col3 => "bla"}

    tabla_obtenida = @conversor.convertir(tabla, "\t")

    assert_equal(tabla_esperada, tabla_obtenida)
  end

end
