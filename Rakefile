require 'rake'
require 'rake/testtask'

task :default => "test:all"

desc "Ejecutando tests"
Rake::TestTask.new("test:metricas") do |t|
  t.test_files = FileList['test/*_test.rb']
  t.libs = ["lib/metricas_tesis"]
  t.verbose = true
  t.warning = true
end

Rake::TestTask.new("test:scripts") do |t|
  t.test_files = FileList['test/scripts/*_test.rb']
  t.libs = ["lib/metricas_tesis", "lib/scripts"]
  t.verbose = true
  t.warning = true
end

Rake::TestTask.new("test:all") do |t|
  t.test_files = FileList['test/scripts/*_test.rb', 'test/*_test.rb']
  t.libs = ["lib/metricas_tesis", "lib/scripts"]
  t.verbose = true
  t.warning = true
end
