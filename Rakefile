require 'rake'
require 'rake/testtask'

task :default => :test

desc "Ejecutando tests"
Rake::TestTask.new("test") {|t|
  t.pattern = 'test/*_test.rb'
  t.verbose = true
  t.warning = true
}