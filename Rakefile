$:.unshift('/Library/RubyMotion/lib')

platform = ENV.fetch('platform', 'ios')
if platform == 'ios'
  require 'motion/project/template/ios'
elsif platform == 'osx'
  require 'motion/project/template/osx'
else
  raise "Unsupported platform #{ENV['platform']}"
end

require 'bundler'
Bundler.require


Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'teacup'
  app.identifier = 'com.rubymotion.teacup'
  app.specs_dir = "spec/#{app.template}/"
end
