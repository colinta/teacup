$:.unshift('/Library/RubyMotion/lib')
require 'motion/project'
require "bundler/gem_tasks"
require 'bubble-wrap/loader'
Bundler.setup
Bundler.require
BW.require 'motion/**/*.rb'
BW.require 'app/**/*.rb'


Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'teacup'
  app.identifier = 'com.rubymotion.teacup'
end
