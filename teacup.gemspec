require File.expand_path('../lib/teacup/version.rb', __FILE__)
require File.expand_path('../lib/teacup/contributors.rb', __FILE__)

Gem::Specification.new do |gem|

  gem.authors  = Teacup::CONTRIBUTORS
  gem.description = <<-DESC
  Teacup is a community-driven DSL for making CSS-like templates for RubyMotion iOS
  apps.
  DESC

  gem.summary = 'CSS-like templates for RubyMotion.'
  gem.homepage = 'https://github.com/rubymotion/teacup'

  gem.files   = `git ls-files`.lines.map(&:strip)
  
  gem.executables = gem.files.grep(%r(^bin/)).map { |f| File.basename(f) }
  gem.test_files  = gem.files.grep(%r{^(test|spec|features)/})

  gem.name          = 'teacup'
  gem.require_paths = ['lib']
  gem.version       = "#{Teacup::VERSION}.pre"

  gem.add_dependency 'rake'
  gem.add_development_dependency 'rspec'

end
