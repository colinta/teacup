$:.unshift('/Library/RubyMotion/lib')
require 'motion/project'


dirs = ['lib', 'app']


Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.files = dirs.map{|d| Dir.glob(File.join(app.project_dir, "#{d}/**/*.rb")) }.flatten
  app.name = 'teacup'
  app.files_dependencies 'app/app_delegate.rb' => 'app/styles/main_styles.rb'
  app.files_dependencies 'app/controllers/landscape_only_controller.rb' => 'app/controllers/first_controller.rb'
end
