require 'test/unit'

require 'ant_pattern_filter'
class AntPatternFilterTest < Test::Unit::TestCase
  def setup
    @ant_pattern_filter = MetricasTesis::AntPatternFilter.new
  end

  def test_fixed_pattern
    patron = 'src/MyFile.java'
    cadena1 = 'src/MyFile.java'
    cadena2 = 'uno/src/MyFile.java'
    cadena3 = 'src/MyFile.java.bkp'

    assert(@ant_pattern_filter.cumple_patron?(cadena1, patron))
    assert(!@ant_pattern_filter.cumple_patron?(cadena2, patron))
    assert(!@ant_pattern_filter.cumple_patron?(cadena3, patron))
  end

  def test_signo_pregunta_aislado
    patron = 'src/?/MyFile.java'
    cadena1 = 'src/a/MyFile.java'
    cadena2 = 'src/z/MyFile.java'
    cadena3 = 'src/aa/MyFile.java'

    assert(@ant_pattern_filter.cumple_patron?(cadena1, patron))
    assert(@ant_pattern_filter.cumple_patron?(cadena2, patron))
    assert(!@ant_pattern_filter.cumple_patron?(cadena3, patron))
  end

  def test_asterisco_aislado
    patron = 'src/*/MyFile.java'
    cadena1 = 'src/a/MyFile.java'
    cadena2 = 'src/aaasdasd/MyFile.java'
    cadena3 = 'src//MyFile.java'
    cadena4 = 'src/uno/dos/MyFile.java'

    assert(@ant_pattern_filter.cumple_patron?(cadena1, patron))
    assert(@ant_pattern_filter.cumple_patron?(cadena2, patron))
    assert(@ant_pattern_filter.cumple_patron?(cadena3, patron))
    assert(!@ant_pattern_filter.cumple_patron?(cadena4, patron))

    patron = 'src/*.java'
    cadena1 = 'src/MyFile.java'
    cadena2 = 'src/aaasdasd/MyFile.java'
    cadena3 = 'src/MyFile.rb'

    assert(@ant_pattern_filter.cumple_patron?(cadena1, patron))
    assert(!@ant_pattern_filter.cumple_patron?(cadena2, patron))
    assert(!@ant_pattern_filter.cumple_patron?(cadena3, patron))
  end

  def test_doble_asterisco_aislado
    patron = '**/MyFile.java'
    cadena1 = 'MyFile.java'
    cadena2 = 'src/MyFile.java'
    cadena3 = 'uno/dos/MyFile.java'
    cadena4 = 'uno/dos/tres/cuatro/cinco/MyFile.java'
    cadena5 = 'uno/dos/EsteNoMyFile.java'
    cadena6 = 'uno/dos/MyFile.java.bkp'

    assert(@ant_pattern_filter.cumple_patron?(cadena1, patron))
    assert(@ant_pattern_filter.cumple_patron?(cadena2, patron))
    assert(@ant_pattern_filter.cumple_patron?(cadena3, patron))
    assert(@ant_pattern_filter.cumple_patron?(cadena4, patron))
    assert(!@ant_pattern_filter.cumple_patron?(cadena5, patron))
    assert(!@ant_pattern_filter.cumple_patron?(cadena6, patron))

    patron = 'src/**/MyFile.java'
    cadena1 = 'src/uno/MyFile.java'
    cadena2 = 'src/uno/dos/tres/MyFile.java'
    cadena3 = 'src/MyFile.java'
    cadena4 = 'usr/src/uno/MyFile.java'

    assert(@ant_pattern_filter.cumple_patron?(cadena1, patron))
    assert(@ant_pattern_filter.cumple_patron?(cadena2, patron))
    assert(@ant_pattern_filter.cumple_patron?(cadena3, patron))
    assert(!@ant_pattern_filter.cumple_patron?(cadena4, patron))

    patron = 'src/**'
    cadena1 = 'src/uno/MyFile.java'
    cadena2 = 'src/uno/dos/tres/BlaBla.java'
    cadena3 = 'src/MyFile.java'
    cadena4 = 'usr/src/uno/MyFile.java'

    assert(@ant_pattern_filter.cumple_patron?(cadena1, patron))
    assert(@ant_pattern_filter.cumple_patron?(cadena2, patron))
    assert(@ant_pattern_filter.cumple_patron?(cadena3, patron))
    assert(!@ant_pattern_filter.cumple_patron?(cadena4, patron))
  end

  def test_patron_termina_con_barra
    # There is one "shorthand": if a pattern ends with / or \,
    # then ** is appended. For example, mypackage/test/ is
    # interpreted as if it were mypackage/test/**.

    patron = 'src/'
    cadena1 = 'src/uno/MyFile.java'
    cadena2 = 'src/uno/dos/tres/MyFile.java'
    cadena3 = 'src/MyFile.java'
    cadena4 = 'usr/src/uno/MyFile.java'

    assert(@ant_pattern_filter.cumple_patron?(cadena1, patron))
    assert(@ant_pattern_filter.cumple_patron?(cadena2, patron))
    assert(@ant_pattern_filter.cumple_patron?(cadena3, patron))
    assert(!@ant_pattern_filter.cumple_patron?(cadena4, patron))

    patron = 'usr/src/'
    cadena1 = 'src/uno/MyFile.java'
    cadena2 = 'src/uno/dos/tres/MyFile.java'
    cadena3 = 'src/MyFile.java'
    cadena4 = 'usr/src/uno/MyFile.java'

    assert(!@ant_pattern_filter.cumple_patron?(cadena1, patron))
    assert(!@ant_pattern_filter.cumple_patron?(cadena2, patron))
    assert(!@ant_pattern_filter.cumple_patron?(cadena3, patron))
    assert(@ant_pattern_filter.cumple_patron?(cadena4, patron))
    
    patron = 'src\\'
    cadena1 = 'src\\uno\\MyFile.java'
    cadena2 = 'src\\uno\\dos\\tres\\MyFile.java'
    cadena3 = 'src\\MyFile.java'
    cadena4 = 'usr\\src\\uno\\MyFile.java'
    # TODO: Hacerlo para dirs en formato windows
    # assert(@ant_pattern_filter.cumple_patron?(cadena1, patron))
    # assert(@ant_pattern_filter.cumple_patron?(cadena2, patron))
    # assert(@ant_pattern_filter.cumple_patron?(cadena3, patron))
    # assert(!@ant_pattern_filter.cumple_patron?(cadena4, patron))
  end

  def test_ejemplos_apache
    # Ejemplos sacados de http://ant.apache.org/manual/dirtasks.html
    patron = '**/CVS/*'
    cadena1 = 'CVS/Repository'
    cadena2 = 'org/apache/CVS/Entries'
    cadena3 = 'org/apache/jakarta/tools/ant/CVS/Entries'
    cadena4 = 'org/apache/CVS/foo/bar/Entries'

    assert(@ant_pattern_filter.cumple_patron?(cadena1, patron))
    assert(@ant_pattern_filter.cumple_patron?(cadena2, patron))
    assert(@ant_pattern_filter.cumple_patron?(cadena3, patron))
    assert(!@ant_pattern_filter.cumple_patron?(cadena4, patron))
  end
end
