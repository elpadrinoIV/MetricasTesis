require 'test/unit'

require 'archivos_commits_handler'
class ArchivosAgregadosEnCommitTest < Test::Unit::TestCase
  def setup
    path_repos = './.git'
    @ach = MetricasTesis::ArchivosCommitsHandler.new(path_repos)
  end

  def test_ningun_archivo_agregado_un_commit
    commit_desde = '4c52b1cee185e419182fc5362b3a45ed7f8f20a4'
    commit_hasta = '4c52b1cee185e419182fc5362b3a45ed7f8f20a4'

    archivos_agregados = @ach.get_archivos(commit_desde, commit_hasta, ['A'])

    commits_esperados = 1
    commits_obtenidos = archivos_agregados.size
    archivos_agregados_esperados = 0
    archivos_agregados_obtenidos = archivos_agregados.values.inject(0) {|total,val| total + val.size}

    assert_equal(commits_esperados, commits_obtenidos)
    assert_equal(archivos_agregados_esperados, archivos_agregados_obtenidos)
  end

  def test_un_archivo_agregado_un_commit
    commit_desde = '630abb361de9c70f4a6986594c4860224a9ce4cb'
    commit_hasta = '630abb361de9c70f4a6986594c4860224a9ce4cb'

    archivos_agregados = @ach.get_archivos(commit_desde, commit_hasta, ['A'])

    commits_esperados = 1
    commits_obtenidos = archivos_agregados.size
    archivos_agregados_esperados = 1
    archivos_agregados_obtenidos = archivos_agregados.values.inject(0) {|total,val| total + val.size}

    assert_equal(commits_esperados, commits_obtenidos)
    assert_equal(archivos_agregados_esperados, archivos_agregados_obtenidos)
  end

  def test_varios_archivos_cambiados_un_commit
    commit_desde = '74e5b2348bd9ed05eba89df571f24f76136658ad'
    commit_hasta = '74e5b2348bd9ed05eba89df571f24f76136658ad'

    archivos_agregados = @ach.get_archivos(commit_desde, commit_hasta, ['A'])

    commits_esperados = 1
    commits_obtenidos = archivos_agregados.size
    archivos_agregados_esperados = 2
    archivos_agregados_obtenidos = archivos_agregados.values.inject(0) {|total,val| total + val.size}

    assert_equal(commits_esperados, commits_obtenidos)
    assert_equal(archivos_agregados_esperados, archivos_agregados_obtenidos)
  end

  def test_varios_archivos_cambiados_varios_commits
    commit_desde = '630abb361de9c70f4a6986594c4860224a9ce4cb'
    commit_hasta = '74e5b2348bd9ed05eba89df571f24f76136658ad'

    archivos_agregados = @ach.get_archivos(commit_desde, commit_hasta, ['A'])

    commits_esperados = 2
    commits_obtenidos = archivos_agregados.size
    archivos_agregados_esperados = 3
    archivos_agregados_obtenidos = archivos_agregados.values.inject(0) {|total,val| total + val.size}

    assert_equal(commits_esperados, commits_obtenidos)
    assert_equal(archivos_agregados_esperados, archivos_agregados_obtenidos)
  end

  def test_varios_commit_hash_erroneo
    commit_desde = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
    commit_hasta = 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
    
    assert_raise(ArgumentError) do
      @ach.get_archivos(commit_desde, commit_hasta, ['A'])
    end
  end

  def test_varios_archivos_dada_lista_commits
    lista_commits = Array.new
    lista_commits << '630abb361de9c70f4a6986594c4860224a9ce4cb'
    lista_commits << '74e5b2348bd9ed05eba89df571f24f76136658ad'
    lista_commits << '3de42f9222f93495088347120049ce550ba0a586'

    archivos_agregados = @ach.get_archivos_de_lista(lista_commits, ['A'])

    commits_esperados = 3
    commits_obtenidos = archivos_agregados.size
    archivos_agregados_esperados = 3
    archivos_agregados_obtenidos = archivos_agregados.values.inject(0) {|total,val| total + val.size}

    assert_equal(commits_esperados, commits_obtenidos)
    assert_equal(archivos_agregados_esperados, archivos_agregados_obtenidos)
  end
end
