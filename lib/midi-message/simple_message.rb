#!/usr/bin/env ruby
#
module MIDIMessage

    # common behavior amongst all Message types
    module SimpleMessageBehavior

      attr_reader :name,
                  :status,
                  :verbose_name

      def initialize_simple_message(status_nibble_1, status_nibble_2)
	@status = [status_nibble_1, status_nibble_2]
        group_name = self.class.const_get(:DisplayName)
        group_name_alias = self.class.const_get(:UseConstants) rescue nil
        val = self.send(self.class.const_get(:ConstProp)) rescue @status[1]
        group = Constant[group_name] || (group_name_alias.nil? ? nil : Constant[group_name_alias])
        unless group.nil?
          const = group.find { |k,v| k if v.eql?(val) }
          unless const.nil?
            @name = const.first
            @verbose_name = "#{self.class::DisplayName}: #{const.first}"
          end
        end
      end

      def to_hex_s
        to_a.join
      end
      alias_method :hex, :to_hex_s

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

	def const(name)
	  key = const_get(:DisplayName) rescue nil
          key = const_get(:UseConstants) rescue key
	  unless key.nil?
	    Constant.instance[key.to_s][name.to_s] 
          end
	end

        def display_name(name)
          const_set(:DisplayName, name)
        end

        def use_constants(name, options = {})
          for_prop = options[:for]
          const_set(:ConstProp, for_prop) unless for_prop.nil?
          const_set(:UseConstants, name)
        end

      end

    end

end
