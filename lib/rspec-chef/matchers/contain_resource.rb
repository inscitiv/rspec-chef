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
        
        def to_s
          [ @type, "[#{@name}]" ].join
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
            run_context = if other.respond_to?(:run_context)
              other.run_context 
            else
              other
            end
            
            begin
              if run_context.respond_to?(:resources)
                # Test hook
                resource = run_context.resources(lookup)
              else
                # Standard behavior
                resource = run_context.resource_collection.find(lookup)
              end
            rescue ::Chef::Exceptions::ResourceNotFound
              @errors << "#{lookup} not found in #{run_context.resource_collection.all_resources.collect(&:description).join(", ")}"
            end
          end
          
          return false unless resource

          matches = true
          @params.each do |key, value|
            unless (real_value = resource.params[key.to_sym]) == value
              @errors << "#{key} expected to be #{value} but it is actually #{real_value}"
              matches = false
            end
          end

          @expected_attributes.each do |key, value|
            unless (real_value = resource.send(key.to_sym)) == value
              @errors << "#{key} expected to be #{value} but it is actually #{real_value}"
              matches = false
            end
          end

          @unexpected_attributes.flatten.each do |attr|
            unless (real_value = resource.send(attr.to_sym)) == nil
              @errors << "#{attr} expected to be nil but it is actually #{real_value}"
              matches = false
            end
          end

          matches
        end

        def description
          %Q{#{@type}("#{@name}")}
        end

        def failure_message_for_should
          %Q{expected #{description}#{errors}}
        end

        def negative_failure_message
          %Q{expected no #{description}#{errors}}
        end

        def errors
          @errors.empty? ? "" : [ ':', @errors.join(', and ') ].join(' ')
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
