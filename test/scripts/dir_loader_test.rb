require 'test/unit'

require 'dir_loader'
class DirLoaderTest < Test::Unit::TestCase
  def setup
    @dir_loader = Scripts::DirLoader.new
  end

  def test_cargar_datos_desde_archivo
    @dir_loader.cargar_datos_de_archivo('../../scripts/directorios')

    assert_equal('../../Resultados', @dir_loader.get_directorio('RESULTADOS'))
    assert_equal('../../Resultados/Data', @dir_loader.get_directorio('DATA'))
    assert_equal('../../Resultados/IMAGENES', @dir_loader.get_directorio('IMAGENES'))
  end

  def test_cargar_datos_archivo_inexistente
    assert_raise(IOError) do
      @dir_loader.cargar_datos_de_archivo('archivo_inexistente')
    end
  end

  def test_cargar_pedir_directorio_que_no_existe
    @dir_loader.cargar_datos_de_archivo('../../scripts/directorios')

    assert_raise(ArgumentError) do
      @dir_loader.get_directorio('DIRECTORIO_INEXISTENTE')
    end
  end

end
