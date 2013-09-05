require File.dirname(__FILE__) + '/helper.rb'

require 'commits_handler'
class CommitsEntreCommitsTest < Test::Unit::TestCase
  def setup
    path_repos = '/home/stoma/Documents/ruby/MetricasTesis'
    @commits_handler = MetricasTesis::CommitsHandler.new(path_repos)
  end

  def test_un_solo_commit
    commit_desde = '4f52d24327a05dcb7c471f5064f6fb2b34d1f9b9'
    commit_hasta = '4f52d24327a05dcb7c471f5064f6fb2b34d1f9b9'

    commits = @commits_handler.commits_entre_commits(commit_desde, commit_hasta)
    assert_equal(1, commits.size, "Deberia haber un solo commit")
  end
=begin
  def test_varios_commits
    commit_desde = '4f52d24327a05dcb7c471f5064f6fb2b34d1f9b9'
    commit_hasta = '9b4d59716fed076fd757b4018eb83044578c8018'

    commits = @commits_handler.commits_entre_commits(commit_desde, commit_hasta)
    assert_equal(3, commits.size, "Deberia haber 3 commits")
  end

  def test_no_existe_commit_desde
    commit_desde = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
    commit_hasta = '9b4d59716fed076fd757b4018eb83044578c8018'

    assert_raise (ArgumentError) do
      @commits_handler.commits_entre_commits(commit_desde, commit_hasta)
    end
  end

  def test_no_existe_commit_hasta
    commit_desde = '4f52d24327a05dcb7c471f5064f6fb2b34d1f9b9'
    commit_hasta = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'

    assert_raise (ArgumentError) do
      @commits_handler.commits_entre_commits(commit_desde, commit_hasta)
    end
  end

  def test_commit_hasta_mayor_commit_desde
    commit_desde = '9b4d59716fed076fd757b4018eb83044578c8018'
    commit_hasta = '4f52d24327a05dcb7c471f5064f6fb2b34d1f9b9'

    assert_raise (ArgumentError) do
      @commits_handler.commits_entre_commits(commit_desde, commit_hasta)
    end
  end
=end
end
