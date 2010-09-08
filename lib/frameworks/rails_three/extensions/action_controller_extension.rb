require 'action_controller'

module Eschaton
  module ActionControllerExtension # :nodoc:
    
    module InstanceMethods
      def set_current_view
        Eschaton.current_view = self.view_context
      end
    end

    module ClassMethods
      def extend_with_slice(extention_module)
        include extention_module
      end
    end

  end
end

ActionController::Base.class_eval do
  before_filter :set_current_view

  include Eschaton::ActionControllerExtension::InstanceMethods
  extend Eschaton::ActionControllerExtension::ClassMethods  
end
