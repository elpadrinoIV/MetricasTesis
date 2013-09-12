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

  def test_ninguna_prueba_unitaria
    lista = Array.new
    lista << 'src/fitnesse/ComponentFactory.java'
    lista << 'src/fitnesse/slimTables/ComparatorUtil.java'
    lista << 'src/fitnesse/testsystems/slim/HtmlTable.java'

    cantidad = @patron_filter.filtrar(lista).size
    assert_equal(0, cantidad)
  end

  def test_una_prueba_unitaria
    lista = Array.new
    lista << 'src/fitnesse/slim/StackTraceEnricher.java'
    lista << 'src/fitnesse/slim/StackTraceEnricherTest.java'

    cantidad = @patron_filter.filtrar(lista).size
    assert_equal(1, cantidad)
  end

  def test_una_comun_una_matchea_exclude
    lista = Array.new
    lista << 'src/fitnesse/slim/ShutdownResponderTest.java'
    lista << 'src/fitnesse/slim/StackTraceEnricherTest.java'

    cantidad = @patron_filter.filtrar(lista).size
    assert_equal(1, cantidad)
  end

  def test_fuera_de_dir_base
    lista = Array.new
    lista << 'usr/src/fitnesse/slim/ShutdownResponderTest.java'
    lista << 'usr/src/fitnesse/slim/StackTraceEnricherTest.java'

    cantidad = @patron_filter.filtrar(lista).size
    assert_equal(0, cantidad)
  end

end
