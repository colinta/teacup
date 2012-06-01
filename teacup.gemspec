require File.expand_path('../lib/teacup/version.rb', __FILE__)
require File.expand_path('../lib/teacup/contributors.rb', __FILE__)

Gem::Specification.new do |gem|

  gem.authors  = Teacup::CONTRIBUTORS
  gem.description = <<-DESC
  Teacup is a community-driven DSL for making CSS-like templates for RubyMotion iOS
  apps.
  DESC

  gem.summary = 'A community-driven DSL for creating user interfaces on the iphone.'
  gem.homepage = 'https://github.com/rubymotion/teacup'

  gem.files   = %w(lib/teacup.rb
                   lib/teacup/version.rb
                   lib/teacup/contributors.rb
                   lib/teacup/helpers/helpers.rb
                   lib/teacup/style_sheet.rb)

  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files  = gem.files.grep(%r{^spec/})

  gem.name          = 'teacup'
  gem.require_paths = ['lib']
  gem.version       = Teacup::VERSION

  gem.add_dependency 'rake'
  gem.add_development_dependency 'rspec'

end
