unless defined?(Motion::Project::Config)
  raise "The teacup gem must be required within a RubyMotion project Rakefile."
end


Motion::Project::App.setup do |app|
  teacup_lib = File.join(File.dirname(__FILE__), 'teacup')
  platform = app.respond_to?(:template) ? app.template : :ios
  teacup_platform_lib = File.join(File.dirname(__FILE__), "teacup-#{platform}")
  unless File.exists? teacup_platform_lib
    raise "Sorry, the platform #{platform.inspect} is not supported by teacup"
  end

  # scans app.files until it finds app/ (the default)
  # if found, it inserts just before those files, otherwise it will insert to
  # the end of the list
  insert_point = app.files.find_index { |file| file =~ /^(?:\.\/)?app\// } || 0

  Dir.glob(File.join(teacup_platform_lib, '**/*.rb')).reverse.each do |file|
    app.files.insert(insert_point, file)
  end
  Dir.glob(File.join(teacup_lib, '**/*.rb')).reverse.each do |file|
    app.files.insert(insert_point, file)
  end
end
