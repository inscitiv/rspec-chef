require 'rspec'
require 'chef'
require 'rspec-chef/chef_support'
require 'rspec-chef/json_support'
require 'rspec-chef/matchers'
require 'rspec-chef/examples'

module RSpec
  module Chef
    VERSION = '0.1.0'
  end
end

class Chef::Resource
  def description
    [ self.class.name, [ '[', self.name, ']' ].join ].join
  end
end

class Chef::RunContext
  def description
    self.class.name
  end
end

RSpec.configure do |c|
  c.add_setting :cookbook_path,   :default => '/etc/chef/recipes'
  c.add_setting :json_attributes, :default => {}
  c.add_setting :log_level,       :default => :warn
end
