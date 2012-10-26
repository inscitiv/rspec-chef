module RSpec
  module Chef
    module ChefSupport
      def load_context(cookbook_name, cookbook_path, dna)
        recipe_name = ::Chef::Recipe.parse_recipe_name(cookbook_name)
        
        cookbook_collection = ::Chef::CookbookCollection.new
        cookbook_path = [ cookbook_path ] unless cookbook_path.is_a?(Array)
        for path in cookbook_path
          if File.exists?(File.expand_path('metadata.rb', path))
            ::Chef::Log.info "Loading specific cookbook #{path}"
            require 'chef/cookbook/chefignore'
            chefignore = ::Chef::Cookbook::Chefignore.new(path)
            loader = ::Chef::Cookbook::CookbookVersionLoader.new(path, chefignore)
            loader.load_cookbooks
            raise "No cookbook found in #{path}" if loader.empty?
            cookbook_collection[loader.cookbook_name] = loader.cookbook_version
          else
            ::Chef::Log.info "Loading cookbooks in dir #{path}"
            cookbook_collection.merge! ::Chef::CookbookLoader.new([ path ]).load_cookbooks
          end
        end

        node = ::Chef::Node.new
        node.consume_attributes(dna)

        formatter = ::Chef::Formatters.new(::Chef::Config.formatter, STDOUT, STDERR)
        events = ::Chef::EventDispatch::Dispatcher.new(formatter)
        run_context = ::Chef::RunContext.new(node, cookbook_collection, events)

        run_list = ::Chef::RunList.new(cookbook_name)
        silently do
          run_context.load(run_list.expand('_default'))
        end
        
        run_context
      end

      private

      def silently
        begin
          verbose = $VERBOSE
          $VERBOSE = nil
          yield
        ensure
          $VERBOSE = verbose
        end
      end
    end
  end
end
