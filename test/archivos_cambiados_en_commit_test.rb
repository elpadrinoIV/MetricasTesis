require File.dirname(__FILE__) + '/helper.rb'

require 'archivos_commits_handler'
class ArchivosCambiadosEnCommitTest < Test::Unit::TestCase
  def setup
    path_repos = '/home/stoma/Documents/ruby/MetricasTesis'
    @ach = MetricasTesis::ArchivosCommitsHandler.new(path_repos)
  end

  def test_ningun_archivo_cambiado_un_commit
    commit_desde = '630abb361de9c70f4a6986594c4860224a9ce4cb'
    commit_hasta = '630abb361de9c70f4a6986594c4860224a9ce4cb'

    archivos_cambiados = @ach.get_archivos_cambiados(commit_desde, commit_hasta)

    commits_esperados = 1
    commits_obtenidos = archivos_cambiados.size
    archivos_modificados_esperados = 0
    archivos_modificados_obtenidos = archivos_cambiados.values.inject(0) {|total,val| total + val.size}

    assert_equal(commits_esperados, commits_obtenidos)
    assert_equal(archivos_modificados_esperados, archivos_modificados_obtenidos)
  end

  def test_un_archivo_cambiado_un_commit
    commit_desde = '74e5b2348bd9ed05eba89df571f24f76136658ad'
    commit_hasta = '74e5b2348bd9ed05eba89df571f24f76136658ad'

    archivos_cambiados = @ach.get_archivos_cambiados(commit_desde, commit_hasta)

    commits_esperados = 1
    commits_obtenidos = archivos_cambiados.size
    archivos_modificados_esperados = 1
    archivos_modificados_obtenidos = archivos_cambiados.values.inject(0) {|total,val| total + val.size}

    assert_equal(commits_esperados, commits_obtenidos)
    assert_equal(archivos_modificados_esperados, archivos_modificados_obtenidos)
  end

  def varios_archivos_cambiados_un_commit
    commit_desde = '4c52b1cee185e419182fc5362b3a45ed7f8f20a4'
    commit_hasta = '4c52b1cee185e419182fc5362b3a45ed7f8f20a4'

    archivos_cambiados = @ach.get_archivos_cambiados(commit_desde, commit_hasta)

    commits_esperados = 1
    commits_obtenidos = archivos_cambiados.size
    archivos_modificados_esperados = 2
    archivos_modificados_obtenidos = archivos_cambiados.values.inject(0) {|total,val| total + val.size}

    assert_equal(commits_esperados, commits_obtenidos)
    assert_equal(archivos_modificados_esperados, archivos_modificados_obtenidos)
  end

  def varios_archivos_cambiados_varios_commits
    commit_desde = '630abb361de9c70f4a6986594c4860224a9ce4cb'
    commit_desde = '3de42f9222f93495088347120049ce550ba0a586'
    archivos_cambiados = @ach.get_archivos_cambiados(commit_desde, commit_hasta)

    commits_esperados = 4
    commits_obtenidos = archivos_cambiados.size
    archivos_modificados_esperados = 4
    archivos_modificados_obtenidos = archivos_cambiados.values.inject(0) {|total,val| total + val.size}

    assert_equal(commits_esperados, commits_obtenidos)
    assert_equal(archivos_modificados_esperados, archivos_modificados_obtenidos)
  end
end
