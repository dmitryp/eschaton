require 'action_view'

module Eschaton
  module ActionViewExtension # :nodoc:

    module ClassMethods
      def extend_with_slice(extention_module)
        include extention_module
      end
    end

  end
end

ActionView::Base.class_eval do
  extend Eschaton::ActionViewExtension::ClassMethods
end
