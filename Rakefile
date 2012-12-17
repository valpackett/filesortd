require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "cane/rake_task"

RSpec::Core::RakeTask.new(:spec) do |rspec|
end

Cane::RakeTask.new(:quality) do |cane|
  cane.abc_max = 10
  cane.no_style = true
end

task :default => :spec
