#!/usr/bin/env rake

# Bundler gem tasks ftw
require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
require File.expand_path '../lib/teacup/version.rb', __FILE__

# Default task
task :default => :spec # Run spec
task :v       => :version # Alt

# - - - - - - - - - - - - - - - - - - -
# Tasks
# - - - - - - - - - - - - - - - - - - -

desc 'display Teacup\'s current version'
task(:version) { version }

desc 'run RSpec tests'
RSpec::Core::RakeTask.new

desc 'build and install the gem'
task :prep do
  system('rake build; rake install')
end

# - - - - - - - - - - - - - - - - - - -
# Helpers
# - - - - - - - - - - - - - - - - - - -

def version
  puts "Teacup #{Teacup::VERSION}"
end
