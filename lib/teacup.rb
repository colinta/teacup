unless defined?(Motion::Project::Config)
  raise "The teacup gem must be required within a RubyMotion project Rakefile."
end

require 'motion-require'

teacup_lib = File.dirname(__FILE__)
teacup_source = Dir.glob(File.expand_path('teacup/**/*.rb', teacup_lib))
teacup_source << File.expand_path('dummy.rb', teacup_lib)

Motion::Project::App.setup do |app|
  # scans app.files until it finds app/ (the default)
  # if found, it inserts just before those files, otherwise it will insert to
  # the end of the list
  insert_point = app.files.index { |f| f =~ %r(^(?:\./)?app/) }
  insert_point ||= -1
  app.files.insert(insert_point, *teacup_source)
end

Motion::Require.all teacup_source
