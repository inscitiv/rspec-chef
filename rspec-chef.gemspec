## This is the rakegem gemspec template. Make sure you read and understand
## all of the comments. Some sections require modification, and others can
## be deleted if you don't need them. Once you understand the contents of
## this file, feel free to delete any comments that begin with two hash marks.
## You can find comprehensive Gem::Specification documentation, at
## http://docs.rubygems.org/read/chapter/20
Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  ## Leave these as is they will be modified for you by the rake gemspec task.
  ## If your rubyforge_project name is different, then edit it and comment out
  ## the sub! line in the Rakefile
  s.name              = 'rspec-chef'
  s.version           = '0.1.1'
  s.date              = '2011-12-30'
  s.rubyforge_project = 'rspec-chef'

  ## Make sure your summary is short. The description may be as long
  ## as you like.
  s.summary     = "Rspec matchers and examples for your Chef recipes"
  s.description = s.summary

  ## List the primary authors. If there are a bunch of authors, it's probably
  ## better to set the email to an email list or something. If you don't have
  ## a custom homepage, consider using your GitHub URL or the like.
  s.authors  = ["Kevin Gilpin", "David Calavera"]
  s.email    = 'kgilpin@gmail.com'
  s.homepage = 'http://github.com/inscitiv/rspec-chef'

  ## This gets added to the $LOAD_PATH so that 'lib/NAME.rb' can be required as
  ## require 'NAME.rb' or'/lib/NAME/file.rb' can be as require 'NAME/file.rb'
  s.require_paths = %w[lib]

  ## List your runtime dependencies here. Runtime dependencies are those
  ## that are needed for an end user to actually USE your code.
  s.add_dependency('chef')
  s.add_dependency('rspec')
  s.add_dependency('json')

  ## Leave this section as-is. It will be automatically generated from the
  ## contents of your Git repository via the gemspec task. DO NOT REMOVE
  ## THE MANIFEST COMMENTS, they are used as delimiters by the task.
  # = MANIFEST =
  s.files = %w[
    Gemfile
    Gemfile.lock
    LICENSE
    README.md
    Rakefile
    lib/rspec-chef.rb
    lib/rspec-chef/chef_support.rb
    lib/rspec-chef/examples.rb
    lib/rspec-chef/examples/define_recipe_group.rb
    lib/rspec-chef/json_support.rb
    lib/rspec-chef/matchers.rb
    lib/rspec-chef/matchers/contain_resource.rb
    rspec-chef.gemspec
    spec/fixtures/cookbooks/foo/recipes/default.rb
    spec/fixtures/cookbooks/foo/recipes/install.rb
    spec/rspec-chef/chef_support_spec.rb
    spec/rspec-chef/examples/define_recipe_group_spec.rb
    spec/rspec-chef/json_support_spec.rb
    spec/rspec-chef/matchers/contain_resource_spec.rb
    spec/spec_helper.rb
  ]
  # = MANIFEST =

  ## Test files will be grabbed from the file list. Make sure the path glob
  ## matches what you actually use.
  ## s.test_files = s.files.select { |path| path =~ %r{^spec/.*_spec\.rb} }
end
