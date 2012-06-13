# -*- encoding: utf-8 -*-
require File.expand_path('../lib/teacup/version.rb', __FILE__)

Gem::Specification.new do |gem|
  gem.authors = ['Conrad Irwin', 'Colin Thomas-Arnold', 'Mark Villacampa', 'Chris Clarke']
  gem.email   = ['conrad@rapportive.com', 'colinta@gmail.com']
  gem.summary     = %{DSLs that allow rubymotion developers to create iOS UIs programmatically.}
  gem.description = <<-DESC
      rubymotion has enabled ruby developers to create native iOS applications
      using their favorite language, but creating views programmatically is an
      exercise in patience and repetition.  Teacup aims to alleviate those
      headaches by providing a DSL that can be used to create layouts (aka view
      hierarchies) easily, and to style those layouts using CSS-like
      stylesheets.  The end result is easier to maintain and DRYer (we hope!).
      DESC

  gem.homepage    = 'https://github.com/rubymotion/teacup'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

  gem.name          = 'teacup'
  gem.require_paths = ['lib']
  gem.version       = Teacup::VERSION

  # Put dependencies here
  # e.g. gem.add_dependency "some_gem", "~> optional_version_number"

  gem.add_dependency 'bubble-wrap'
  gem.add_development_dependency 'rake'

end
