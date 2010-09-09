module Eschaton
  module Events

    def self.included(base)
      base.class_eval do
        extend Eschaton::Events::ClassMethods
        include Eschaton::Events::InstanceMethods
      end
    end
    
    module InstanceMethods
      
      def doing(event, options = {})
        self.class.doing(event, options)
      end

    end

    module ClassMethods
      @@listeners = {}
      
      def listeners
        @@listeners
      end

      def when(event, &block)
        @@listeners[event] ||= []
        
        @@listeners[event] << block
      end
      
      def doing(event, options = {})
        listeners = @@listeners[event] || []
        
        listeners.each do |listener|
          listener.call options
        end
      end

    end
  end
end
