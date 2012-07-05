module RSpec
  module Chef
    module Matchers
      CONTAIN_PATTERN = /^contain_(.+)/

      def method_missing(method, *args, &block)
        return RSpec::Chef::Matchers::ContainResource.new(method, *args, &block) if method.to_s =~ CONTAIN_PATTERN
        super
      end

      class ContainResource
        def initialize(type, *args, &block)
          @type                  = type.to_s[CONTAIN_PATTERN, 1]
          @name                  = args.shift
          @params                = args.shift || {}
          @expected_attributes   = {}
          @unexpected_attributes = []
          @errors                = []
        end

        def matches?(other)
          if other.is_a?(::Chef::Resource)
            type = if @type.is_a?(Class)
              @type
            else
              ::Chef::Resource.const_get ::Chef::Mixin::ConvertToClassName.convert_to_class_name(@type)
            end
            
            resource = other if other.is_a?(type) && other.name == @name
          else
            lookup = @type.dup
            lookup << "[#{@name.to_s}]" if @name
  
            require 'chef/run_context'
            run_context = if other.is_a?(::Chef::RunContext)
              other
            elsif other.respond_to?(:run_context)
              other.run_context 
            end
            
            return false unless run_context
            
            begin
              resource = run_context.resource_collection.find(lookup)
            rescue ::Chef::Exceptions::ResourceNotFound
            end
          end
          
          return false unless resource

          matches = true
          @params.each do |key, value|
            unless (real_value = resource.params[key.to_sym]) == value
              @errors << "#{key} expected to be #{value} but it is #{real_value}"
              matches = false
            end
          end

          @expected_attributes.each do |key, value|
            unless (real_value = resource.send(key.to_sym)) == value
              @errors << "#{key} expected to be #{value} but it is #{real_value}"
              matches = false
            end
          end

          @unexpected_attributes.flatten.each do |attr|
            unless (real_value = resource.send(attr.to_sym)) == nil
              @errors << "#{attr} expected to be nil but it is #{real_value}"
              matches = false
            end
          end

          matches
        end

        def description
          %Q{include Resource[#{@type} @name="#{@name}"]}
        end

        def failure_message_for_should
          %Q{expected that the run_context would #{description}#{errors}}
        end

        def negative_failure_message
          %Q{expected that the run_context would not #{description}#{errors}}
        end

        def errors
          @errors.empty? ? "" : " with #{@errors.join(', and ')}"
        end

        def with(attribute, value)
          @expected_attributes[attribute] = value
          self
        end

        def without(*attributes)
          @unexpected_attributes << attributes
          self
        end
      end
    end
  end
end
