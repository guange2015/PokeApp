require 'rspec/core/rake_task'
require 'rake/rdoctask'
require 'yard'
require 'yard/rake/yardoc_task'


require 'yard/rake/yardoc_task'
require 'yard'


RSpec::Core::RakeTask.new do |t|
    t.rspec_opts = ["--color", "--format", "d"]
    t.pattern = "test/*_spec.rb"
end

Rake::RDocTask.new do |rd|
    rd.main = "Readme"
    rd.rdoc_files.include("Readme", "./**/*.rb")
    #rd.template = 'poke'
end

YARD::Rake::YardocTask.new do |t|
  t.files   = ['**/*.rb', '*.rb']   # optional
  #t.options = ['--any', '--extra', '--opts'] # optional
end

task :default => [:spec]


YARD::Rake::YardocTask.new do |t|
  t.files   = ['**/*.rb', '*.rb']   # optional
  t.options = ['--markup','markdown'] # optional
end
