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
=begin
  def test_signo_pregunta_aislado
    patron = 'src/?/MyFile.java'
    cadena1 = 'src/a/MyFile.java'
    cadena2 = 'src/z/MyFile.java'
    cadena3 = 'src/aa/MyFile.java'

    assert(@ant_pattern_filter.cumple_patron?(cadena1, patron))
    assert(@ant_pattern_filter.cumple_patron?(cadena2, patron))
    assert(!@ant_pattern_filter.cumple_patron?(cadena3, patron))
  end
=end
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
    assert(@ant_pattern_filter.cumple_patron?(cadena2, patron))
    assert(@ant_pattern_filter.cumple_patron?(cadena3, patron))
    assert(!@ant_pattern_filter.cumple_patron?(cadena4, patron))
  end
end
