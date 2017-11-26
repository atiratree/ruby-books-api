require 'sequel'
require 'rubocop'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'

$: << File.expand_path("../config", __FILE__)

RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['*.rb']
  task.fail_on_error = false
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :test => :spec

task default: [:rubocop, :test]
