require 'rspec/core/rake_task'
require File.expand_path '../lib/teacup/version.rb', __FILE__

# Default task
task :default => :spec # Run spec

# - - - - - - - - - - - - - - - - - - -
# Tasks
# - - - - - - - - - - - - - - - - - - -

desc 'display Teacup\'s current version'
task(:version) { version }

desc 'run RSpec tests'
RSpec::Core::RakeTask.new

# - - - - - - - - - - - - - - - - - - -
# Helpers
# - - - - - - - - - - - - - - - - - - -

def version
  puts "Teacup #{Teacup::VERSION}"
end
