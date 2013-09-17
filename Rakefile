require 'rake'
require 'rake/testtask'

task :default => "test:all"

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

desc "Corriendo scripts"
task :run_scripts, :script do |t, args|
	scripts_dir = "./lib/scripts/"
	libs = ["lib/scripts", "lib/scripts/utilitarios", "lib/metricas_tesis"]

	scripts =  Dir.glob("#{scripts_dir}*script.rb").class

	if args[:script]
		scripts = [args[:script] ]
	end

	load_path = ""
	libs.each { |lib| load_path += "-I\"#{lib}\" " }

	scripts.each { |script| ruby "#{load_path} #{scripts_dir + script + ".rb"}" }
	# ruby '-I"lib/scripts" -I"lib/scripts/utilitarios" -I"lib/metricas_tesis" ./lib/scripts/actividad_entre_tags_script.rb'
end

