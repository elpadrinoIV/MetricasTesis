require 'test/unit'

require 'ant_pattern_filter'
class PatronArchivosUnitTestsTest < Test::Unit::TestCase
  def setup
    @patron_filter = MetricasTesis::AntPatternFilter.new
    @patron_filter.set_fileset('src/')
    @patron_filter.add_include('**/*Test.java')
    @patron_filter.add_exclude('**/ShutdownResponderTest.java')
    @patron_filter.add_exclude('**/QueryTableBaseTest.java')
    @patron_filter.add_exclude('**/Test.java')
    @patron_filter.add_exclude('**/SystemUnderTest.java')
    @patron_filter.add_exclude('**/MySystemUnderTest.java')

  end
=begin
  def test_ninguna_prueba_unitaria
    lista = Array.new
    lista << 'M       src/fitnesse/ComponentFactory.java'
    lista << 'D       src/fitnesse/slimTables/ComparatorUtil.java'
    lista << 'A       src/fitnesse/testsystems/slim/HtmlTable.java'

    cantidad = @patron_filter.filtrar(lista).size
    assert_equal(0, cantidad)
  end

  def test_ninguna_prueba_unitaria
    lista = Array.new
    lista << 'M       src/fitnesse/ComponentFactory.java'
    lista << 'D       src/fitnesse/slimTables/ComparatorUtil.java'
    lista << 'A       src/fitnesse/testsystems/slim/HtmlTable.java'

    cantidad = @patron_filter.filtrar(lista).size
    assert_equal(0, cantidad)
  end
=end
end
