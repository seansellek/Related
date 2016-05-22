require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "Open an pry session preloaded with this library"
task :console do
  sh "./bin/console"
end
