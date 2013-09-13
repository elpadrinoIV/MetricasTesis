require 'test/unit'

require 'ant_pattern_filter'
class PatronArchivosAcceptanceTestsTest < Test::Unit::TestCase
  def setup
    @patron_filter = MetricasTesis::AntPatternFilter.new
    @patron_filter.set_fileset('FitNesseRoot/FrontPage/MetricasTesisProject')
    @patron_filter.add_include('**/content.txt')
    @patron_filter.add_exclude('**/ExcluirTodosSubniveles/**')
    @patron_filter.add_exclude('**/ExcluirSoloUnNivel/*')
  end

  def test_ninguna_prueba_aceptacion
    lista = Array.new
    lista << 'src/fitnesse/ComponentFactory.java'
    lista << 'src/fitnesse/slim/StackTraceEnricherTest.java'
    lista << 'FitNesseRoot/FrontPage/content.txt'
    lista << 'Otro/FrontPage/MetricasTesisProject/content.txt'

    cantidad = @patron_filter.filtrar(lista).size
    assert_equal(0, cantidad)
  end

  def test_una_prueba_aceptacion
    lista = Array.new
    lista << 'FitNesseRoot/FrontPage/content.txt'
    lista << 'FitNesseRoot/FrontPage/MetricasTesisProject/ActividadArchivosSuite/content.txt'

    cantidad = @patron_filter.filtrar(lista).size
    assert_equal(1, cantidad)
  end

  def test_varios_comun_varios_matchean_exclude
    lista = Array.new

    # 2 pruebas de aceptación
    lista << 'FitNesseRoot/FrontPage/MetricasTesisProject/ActividadArchivosSuite/ContarActividadTestsUnitarios/content.txt'
    lista << 'FitNesseRoot/FrontPage/MetricasTesisProject/content.txt'

    # matchea exclude un solo nivel
    lista << 'FitNesseRoot/FrontPage/MetricasTesisProject/ExcluirSoloUnNivel/content.txt'
    lista << 'FitNesseRoot/FrontPage/MetricasTesisProject/ActividadArchivosSuite/ExcluirSoloUnNivel/content.txt'

    # no matchea exclude un solo nivel, porque está 2 niveles adentro
    lista << 'FitNesseRoot/FrontPage/MetricasTesisProject/ExcluirSoloUnNivel/OtroNivel/content.txt'

    # matchea exlcude todos los subniveles
    lista << 'FitNesseRoot/FrontPage/MetricasTesisProject/ExcluirTodosSubniveles/content.txt'
    lista << 'FitNesseRoot/FrontPage/MetricasTesisProject/ActividadArchivosSuite/ExcluirTodosSubniveles/content.txt'
    lista << 'FitNesseRoot/FrontPage/MetricasTesisProject/ExcluirTodosSubniveles/UnNivel/OtroNivel/content.txt'

    cantidad = @patron_filter.filtrar(lista).size
    assert_equal(3, cantidad)
  end
end
