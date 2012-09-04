require File.expand_path('../spec_helper', File.dirname(__FILE__))

class RSpecChefSupport
  include RSpec::Chef::ChefSupport
end

describe RSpecChefSupport do
  def mock_recipe
    recipe = mock(:recipe)
    recipe.stub(:from_file)
    recipe
  end
  
  context "recipe 'foo'" do
    it "includes the cookbook 'foo'" do
      run_context = subject.load_context('foo', COOKBOOKS, {})
      run_context.cookbook_collection['foo'].should_not be_nil
    end
    it "loads default recipe 'foo/default'" do
      Chef::Recipe.should_receive(:new).with(:foo, "default", an_instance_of(Chef::RunContext)).and_return mock_recipe
      subject.load_context('foo', COOKBOOKS, {})
    end
  end

  context "recipe 'foo::install'" do
    it "loads specific recipe 'foo/install'" do
      Chef::Recipe.should_receive(:new).with(:foo, "install", an_instance_of(Chef::RunContext)).and_return mock_recipe
      subject.load_context('foo::install', COOKBOOKS, {})
    end
  end
end
