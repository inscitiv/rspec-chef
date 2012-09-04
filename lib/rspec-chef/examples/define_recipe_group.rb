module RSpec
  module Chef
    module DefineRecipeGroup
      include RSpec::Chef::Matchers
      include JSONSupport
      include ChefSupport

      def subject
        @run_context ||= run_context
      end

      def run_context
        ::Chef::Log.level = self.respond_to?(:log_level) ? log_level : RSpec.configuration.log_level

        path = self.respond_to?(:cookbook_path) ? cookbook_path : RSpec.configuration.cookbook_path
        dna = json(self.respond_to?(:json_attributes) ? json_attributes : RSpec.configuration.json_attributes)
        
        cookbook_name = self.class.top_level_description.downcase
        load_context(cookbook_name, path, dna)
      end
    end
  end
end
