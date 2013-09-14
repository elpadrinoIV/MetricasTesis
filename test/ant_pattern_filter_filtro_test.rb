require 'test/unit'

require 'ant_pattern_filter'
class AntPatternFilterFiltroTest < Test::Unit::TestCase
  def setup
    @lista = Array.new
    @lista << 'src/Test.java'
    @lista << 'src/MyUnitTest.java'
    @lista << 'src/UnNivel/Test.java'
    @lista << 'src/UnNivel/MyUnitTest.java'
    @lista << 'src/UnNivel/OtroNivel/UnoMas/Test.java'
    @lista << 'src/UnNivel/OtroNivel/UnoMas/MyUnitTest.java'
    
    @lista << 'src/MiClase.java'
    @lista << 'src/MiClaseArchivo.java'
    @lista << 'src/MiClaseSaraza.java'
    @lista << 'src/UnNivel/MiClase.java'
    @lista << 'src/UnNivel/MiClaseArchivo.java'
    @lista << 'src/UnNivel/MiClaseSaraza.java'
    @lista << 'src/UnNivel/OtroNivel/UnoMas/MiClase.java'
    @lista << 'src/UnNivel/OtroNivel/UnoMas/MiClaseArchivo.java'
    @lista << 'src/UnNivel/OtroNivel/UnoMas/MiClaseSaraza.java'

    @lista << 'src/NivelDiferente/MiClase.java'
    @lista << 'src/NivelDiferente/MiClaseArchivo.java'
    @lista << 'src/NivelDiferente/MiClaseSaraza.java'
    @lista << 'src/NivelDiferente/OtroNivel/UnoMas/MiClase.java'
    @lista << 'src/NivelDiferente/OtroNivel/UnoMas/MiClaseArchivo.java'
    @lista << 'src/NivelDiferente/OtroNivel/UnoMas/MiClaseSaraza.java'

    @lista << 'src/MiClase.rb'
    @lista << 'src/MiClaseArchivo.rb'
    @lista << 'src/MiClaseSaraza.rb'
    @lista << 'src/UnNivel/MiClase.rb'
    @lista << 'src/UnNivel/MiClaseArchivo.rb'
    @lista << 'src/UnNivel/MiClaseSaraza.rb'
    @lista << 'src/UnNivel/OtroNivel/UnoMas/MiClase.rb'
    @lista << 'src/UnNivel/OtroNivel/UnoMas/MiClaseArchivo.rb'
    @lista << 'src/UnNivel/OtroNivel/UnoMas/MiClaseSaraza.rb'

    @lista << 'afuera/MiClase.java'
  end

  def test_patron_fijo
    patron_filter = MetricasTesis::AntPatternFilter.new
    patron_filter.set_fileset('src/')
    patron_filter.add_include('MiClase.java')
    
    cantidad = patron_filter.filtrar(@lista).size
    assert_equal(1, cantidad)
  end

  def test_un_solo_nivel_include
    patron_filter = MetricasTesis::AntPatternFilter.new
    patron_filter.set_fileset('src/')
    patron_filter.add_include('*/MiClase.java')

    cantidad = patron_filter.filtrar(@lista).size
    assert_equal(2, cantidad)
  end

  def test_todos_los_niveles_include
    patron_filter = MetricasTesis::AntPatternFilter.new
    patron_filter.set_fileset('src/')
    patron_filter.add_include('**/MiClase.java')

    cantidad = patron_filter.filtrar(@lista).size
    assert_equal(5, cantidad)
  end

  def test_primer_nivel_fijo_include
    patron_filter = MetricasTesis::AntPatternFilter.new
    patron_filter.set_fileset('src/')
    patron_filter.add_include('UnNivel/**/MiClase.java')

    cantidad = patron_filter.filtrar(@lista).size
    assert_equal(2, cantidad)
  end

  def test_dos_primer_nivel_distintos_include
    patron_filter = MetricasTesis::AntPatternFilter.new
    patron_filter.set_fileset('src/')
    patron_filter.add_include('UnNivel/**/MiClase.java')
    patron_filter.add_include('NivelDiferente/**/MiClase.java')

    cantidad = patron_filter.filtrar(@lista).size
    assert_equal(4, cantidad)
  end

  def test_include_con_signo_pregunta
    patron_filter = MetricasTesis::AntPatternFilter.new
    patron_filter.set_fileset('src/')
    patron_filter.add_include('??Nivel/**/MiClase.java')
    
    cantidad = patron_filter.filtrar(@lista).size
    assert_equal(2, cantidad)
  end

  def test_todo_bajo_src
    patron_filter = MetricasTesis::AntPatternFilter.new
    patron_filter.set_fileset('src/')
    patron_filter.add_include('**')

    cantidad = patron_filter.filtrar(@lista).size
    assert_equal(30, cantidad)
  end

  def test_todo_java_bajo_src
    patron_filter = MetricasTesis::AntPatternFilter.new
    patron_filter.set_fileset('src/')
    patron_filter.add_include('**/*.java')

    cantidad = patron_filter.filtrar(@lista).size
    assert_equal(21, cantidad)
  end

  def test_todo_non_ruby_bajo_src
    patron_filter = MetricasTesis::AntPatternFilter.new
    patron_filter.set_fileset('src/')
    patron_filter.add_include('**')
    patron_filter.add_exclude('**/*.rb')

    cantidad = patron_filter.filtrar(@lista).size
    assert_equal(21, cantidad)
  end

  def test_todo_java_exclude_tests
    patron_filter = MetricasTesis::AntPatternFilter.new
    patron_filter.set_fileset('src/')
    patron_filter.add_include('**/*.java')
    patron_filter.add_exclude('**/*Test.java')

    cantidad = patron_filter.filtrar(@lista).size
    assert_equal(15, cantidad)
  end

  def test_todo_java_exclude_tests_mas_de_un_nivel
    patron_filter = MetricasTesis::AntPatternFilter.new
    patron_filter.set_fileset('src/')
    patron_filter.add_include('**/*.java')
    patron_filter.add_exclude('*/*/**/*Test.java')
    

    cantidad = patron_filter.filtrar(@lista).size
    assert_equal(19, cantidad)
  end
end
