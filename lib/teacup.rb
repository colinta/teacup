unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

# In order that we can prepend our files to the load path after the user has
# configured their app.files, we need to run code *after* the user has set up
# their app.
#
# Unfortunately, the canonical place to require rubygems is at the top of the
# file (while we could just add to the instructions "please `require 'teacup'`
# at the bottom, that would be odd, and no-one would read the instructions).
#
# To this end, we tweak the App setup function so that whenever setup is called,
# we configure teacup after that.
#
# This is not great though, as other gems may (following the instructions at
# http://reality.hk/posts/2012/05/22/create-gems-for-rubymotion/) also call
# setup...
#
# For sanity reasons, we therefore delete teacup requires from the load order
# and re-add them to the front every single time {setup} is called.
#
# TODO: We should send a patch to rubymotion that adds first-class support for
# app.gems. These could then be required *after* the user has finished running
# the setup block, so that they can just run setup properly.
#
class << Motion::Project::App

  def setup_with_teacup
    setup_without_teacup do |app|
      yield app

      dirs = %w(teacup teacup/core_extensions)
      files = dirs.map{ |dir| Dir.glob("#{File.dirname(__FILE__)}/#{dir}/*.rb") }.flatten
      app.files = files + (app.files - files)
    end
  end

  alias setup_without_teacup setup
  alias setup setup_with_teacup
end
