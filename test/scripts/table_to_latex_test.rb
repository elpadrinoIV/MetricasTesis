require 'test/unit'
require 'array_to_table'
require 'table_to_array'
require 'table_to_latex'

class TableToLatexTest < Test::Unit::TestCase
  def setup
  end
  
  def test_conversion_desde_tabla
    tabla = Array.new
    tabla << {:col1 => "AAA", :col2 => "BBB", :col3 => "CCC"}
    tabla << {:col1 => "DDD", :col2 => "EEE", :col3 => "FFF"}

    resultado_obtenido = MetricasTesis::Scripts::Utilitarios::TableToLatex.convertir(tabla)
    resultado_esperado = get_resultado_esperado()

    assert_equal(resultado_esperado, resultado_obtenido)
  end

  def get_resultado_esperado
    resultado = Array.new
    resultado << '\renewcommand{\arraystretch}{1.2}'
    resultado << '\begin{table}[!htpb]'
    resultado << '\centering'
    resultado << '\begin{tabular}{@{}ccc@{}}'
    resultado << '\toprule'
    resultado << '\multicolumn{1}{c}{\textbf{col1}} & \multicolumn{1}{c}{\textbf{col2}} & \multicolumn{1}{c}{\textbf{col3}}\\\\'
    resultado << '\midrule'
    resultado << 'AAA & BBB & CCC\\\\'
    resultado << 'DDD & EEE & FFF\\\\'
    resultado << '\bottomrule'
    resultado << '\end{tabular}'
    resultado << '\caption{}'
    resultado << '\label{tbl:}'
    resultado << '\end{table}'

    resultado
  end
end
