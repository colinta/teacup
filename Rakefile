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

desc 'diesplay list of contributors'
task(:contrib)  { contrib }

desc 'run RSpec tests'
RSpec::Core::RakeTask.new

desc 'build and install the gem'
task(:prep) { system('rake build; rake install') }

# - - - - - - - - - - - - - - - - - - -
# Helpers
# - - - - - - - - - - - - - - - - - - -

def version
  puts "Teacup #{Teacup::VERSION}"
end

def contrib
  puts Teacup::CONTRIBUTORS
end
