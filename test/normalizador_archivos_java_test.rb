require 'test/unit'

require 'normalizador_archivos_java'

class NormalizadorArchivosJavaTest < Test::Unit::TestCase
  def setup
    @normalizador = MetricasTesis::NormalizadorArchivosJava.new
  end

  def test_quitar_lineas_vacias_o_con_espacios
    archivo = Array.new
    archivo << "linea no vacia"
    archivo << ""
    archivo << "     "
    archivo << "\t\t    \t\t"
    archivo << "linea no vacia 2"
    archivo << "\n"
    archivo << "\n\r"
    archivo << "\r"
    archivo << "\r\n"
    archivo << "linea no vacia 3"

    resultado_esperado = Array.new
    resultado_esperado << "linea no vacia"
    resultado_esperado << "linea no vacia 2"
    resultado_esperado << "linea no vacia 3"

    resultado = @normalizador.quitar_lineas_vacias(archivo)
    assert_equal(resultado_esperado, resultado)
  end

  def test_strip_comentarios_cortos_sencillo
    archivo = Array.new
    archivo << "     \t// Espacios y comentario corto"
    archivo << "// Arranca con comentario corto"
    archivo << "int a; // comentario al final"
    archivo << "public void hacerAlgo()"
    
    resultado_esperado = Array.new
    resultado_esperado << "int a;"
    resultado_esperado << "public void hacerAlgo()"

    resultado = @normalizador.quitar_comentarios_cortos(archivo)
    assert_equal(resultado_esperado, resultado)
  end

  def test_strip_comentarios_cortos_dentro_de_comillas
    archivo = Array.new
    archivo << 'String cadena = "cadena con dos // adentro";'
    archivo << "String cadena = 'cadena con dos // adentro';"
    archivo << '//String cadena = "cadena con dos // adentro";'
    archivo << "//String cadena = 'cadena con dos // adentro';"
    archivo << 'String cadena = "cadena con dos // adentro"; // "Comentario"'
    archivo << "String cadena = 'cadena con dos // adentro'; // 'Comentario'"


    resultado_esperado = Array.new
    resultado_esperado << 'String cadena = "cadena con dos // adentro";'
    resultado_esperado << "String cadena = 'cadena con dos // adentro';"
    resultado_esperado << 'String cadena = "cadena con dos // adentro";'
    resultado_esperado << "String cadena = 'cadena con dos // adentro';"

    resultado = @normalizador.quitar_comentarios_cortos(archivo)
    assert_equal(resultado_esperado, resultado)
  end

  def test_strip_comentarios_largos_una_linea
    archivo = Array.new
    archivo << "     \t/* Espacios y comentario largo una linea */"
    archivo << "linea normal 1"
    archivo << "/* Arranca con comentario largo y termina */"
    archivo << "linea normal 2"
    archivo << "linea normal 3/* comentario al final */"
    archivo << "linea normal /* comentario largo medio */4"
    archivo << "linea /*comentario 1*/normal /*comentario 2*/5"

    resultado_esperado = Array.new
    resultado_esperado << "linea normal 1"
    resultado_esperado << "linea normal 2"
    resultado_esperado << "linea normal 3 "
    resultado_esperado << "linea normal  4"
    resultado_esperado << "linea  normal  5"
    
    resultado = @normalizador.quitar_comentarios_largos(archivo)
    assert_equal(resultado_esperado, resultado)
  end

  def test_strip_comentarios_largos_varias_linea
    archivo = Array.new
    archivo << "linea normal 1"
    archivo << "/* Comentario largo que ocupa"
    archivo << " dos lineas */"
    archivo << "/* Comentario"
    archivo << " * comun"
    archivo << " * de"
    archivo << " * java"
    archivo << " */"
    archivo << "linea normal 2"
    archivo << "/******** Comentario con muchos asteriscos"
    archivo << " al comienzo */"
    archivo << "linea normal 3"
    archivo << "/* Comentario con muchos asteriscos"
    archivo << " al final **************/"
    archivo << "linea normal 4"
    archivo << "/***** muchos al principio"
    archivo << " * muchos al final *******/"
    archivo << "linea/* comentario que"
    archivo << "         sigue hasta abajo */ normal 5"

    resultado_esperado = Array.new
    resultado_esperado << "linea normal 1"
    resultado_esperado << "linea normal 2"
    resultado_esperado << "linea normal 3"
    resultado_esperado << "linea normal 4"
    resultado_esperado << "linea  normal 5"

    resultado = @normalizador.quitar_comentarios_largos(archivo)
    assert_equal(resultado_esperado, resultado)
  end

  def test_normalizar_archivo_problematico_fitnesse
    archivo = Array.new
    archivo << '/** this class is adapted from the trinidad project (http://fitnesse.info/trinidad) */'
    archivo << 'package fitnesse.trinidad.examples;'
    archivo << ''
    archivo << 'import org.junit.runner.RunWith;'
    archivo << ''
    archivo << 'import fitnesse.trinidad.*;'
    archivo << 'import fitnesse.trinidad.FitnesseSuite.*;'
    archivo << ''
    archivo << '@RunWith(FitnesseSuite.class)'
    archivo << '@Name("FitNesse.SuiteAcceptanceTests.SuiteFixtureTests")'
    archivo << '@FitnesseDir(".")'
    archivo << '// @TestEngine(FitTestEngine.class) //this is optional since it\'s the default'
    archivo << '// @OutputDir("/tmp/fitnesse") //Specify an absolute or relative path'
    archivo << '@OutputDir(systemProperty = "java.io.tmpdir", pathExtension = "fitnesse")'
    archivo << 'public class JUnitExampleFitnesseSuiteTest {'
    archivo << ''
    archivo << '}'

    resultado_esperado = Array.new
    resultado_esperado << 'package fitnesse.trinidad.examples;'
    resultado_esperado << 'import org.junit.runner.RunWith;'
    resultado_esperado << 'import fitnesse.trinidad.*;'
    resultado_esperado << 'import fitnesse.trinidad.FitnesseSuite.*;'
    resultado_esperado << '@RunWith(FitnesseSuite.class)'
    resultado_esperado << '@Name("FitNesse.SuiteAcceptanceTests.SuiteFixtureTests")'
    resultado_esperado << '@FitnesseDir(".")'
    resultado_esperado << '@OutputDir(systemProperty = "java.io.tmpdir", pathExtension = "fitnesse")'
    resultado_esperado << 'public class JUnitExampleFitnesseSuiteTest {'
    resultado_esperado << '}'


    resultado = @normalizador.normalizar(archivo)
    assert_equal(resultado_esperado, resultado)
  end
end
