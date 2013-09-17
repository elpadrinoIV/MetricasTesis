require 'test/unit'

require 'tags_handler'
require 'date'
class TagsHandlerTest < Test::Unit::TestCase
  def setup
    path_repos = './.git'
    @tags_handler = MetricasTesis::TagsHandler.new(path_repos)
  end

  def test_obtener_todos_los_tags
    cantidad = @tags_handler.get_tags.size
    assert_equal(9, cantidad)
  end

  def test_obtener_tags_ordenados
    # 2013-09-04 14:07:05 -0300 tag0_para_script
    # 2013-09-05 23:58:37 -0300 tag1_para_script
    # 2013-09-13 00:33:53 -0300 tag0
    # 2013-09-13 00:36:27 -0300 tag1
    # 2013-09-13 00:38:01 -0300 tag2
    # 2013-09-13 00:39:35 -0300 tag3
    # 2013-09-13 00:44:05 -0300 tag4
    # 2013-09-13 00:47:09 -0300 tag5
    # 2013-09-13 00:47:56 -0300 tag6
    resultado_esperado = ["tag0_para_script", "tag1_para_script", "tag0", 
                          "tag1", "tag2", "tag3", "tag4", "tag5", "tag6"]
                        
    tags = @tags_handler.get_tags
    assert_equal(resultado_esperado, tags)

  end

  def test_obtener_tags_entre_fechas
    # 2013-09-05 23:58:37 -0300 tag1_para_script
    # 2013-09-13 00:33:53 -0300 tag0
    # 2013-09-13 00:36:27 -0300 tag1
    # 2013-09-13 00:38:01 -0300 tag2

    resultado_esperado = ["tag1_para_script", "tag0", "tag1", "tag2"]
    fecha_desde = Date.parse('2013-09-05 23:50:00 -0300')
    fecha_hasta = Date.parse('2013-09-13 00:38:10 -0300')

    tags = @tags_handler.get_tags(fecha_desde, fecha_hasta)

    assert_equal(resultado_esperado, tags)

  end
end
