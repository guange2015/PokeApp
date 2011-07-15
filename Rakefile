require 'rspec/core/rake_task'
require 'rake/rdoctask'

RSpec::Core::RakeTask.new do |t|
    t.rspec_opts = ["--color", "--format", "d"]
    t.pattern = "test/*_spec.rb"
end

Rake::RDocTask.new do |rd|
    rd.main = "Readme"
    rd.rdoc_files.include("Readme", "./**/*.rb")
    rd.template = 'poke'
end

task :default => [:spec]



