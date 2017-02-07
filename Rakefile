require "bundler/gem_tasks"

task :console do
 exec "irb -r questrade_api -I ./lib"
end

require 'rspec/core/rake_task'
task :default => :spec
RSpec::Core::RakeTask.new
