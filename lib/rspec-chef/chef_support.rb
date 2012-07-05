module RSpec
  module Chef
    module ChefSupport
      def lookup_recipe(cookbook_name, cookbook_path, dna)
        recipe_name = ::Chef::Recipe.parse_recipe_name(cookbook_name)

        cookbook_collection = ::Chef::CookbookCollection.new(::Chef::CookbookLoader.new(cookbook_path))
        node = ::Chef::Node.new
        node.consume_attributes(dna)

        run_context = ::Chef::RunContext.new(node, cookbook_collection)

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
