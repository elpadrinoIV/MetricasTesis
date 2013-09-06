require File.dirname(__FILE__) + '/helper.rb'

require 'archivos_commits_handler'
class ArchivosCambiadosEnCommitTest < Test::Unit::TestCase
  def setup
    path_repos = '/home/stoma/Documents/ruby/MetricasTesis'
    @ach = MetricasTesis::ArchivosCommitsHandler.new(path_repos)
  end
=begin
  def test_ningun_archivo_cambiado_un_commit
    commit_hash = '630abb361de9c70f4a6986594c4860224a9ce4cb'
    archivos_cambiados = @ach.get_archivos_cambiados(commit_hash)

    assert_equal(0, archivos_cambiados.size)
  end
=end
end
