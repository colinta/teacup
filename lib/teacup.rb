unless defined?(Motion::Project::Config)
  raise "This file (teacup) must be required within a RubyMotion project Rakefile."
end


Motion::Project::App.setup do |app|
  Dir.glob(File.join(File.dirname(__FILE__), 'teacup/**/*.rb')).reverse.each do |file|
    app.files.unshift(file)
  end
  app.files.push(File.join(File.dirname(__FILE__), 'dummy.rb'))
end
