$:.unshift('/Library/RubyMotion/lib')
require 'motion/project'
require 'bundler'
Bundler.require


Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'teacup'
  app.identifier = 'com.rubymotion.teacup'
  app.vendor_project 'vendor/TeacupDummy', :static
end
