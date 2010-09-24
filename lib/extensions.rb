module Eschaton

  class Extensions

    def self.extend_rails_controllers(&block)
      self.extend_object :object => ActionController::Base, :extension_block => block
    end
    
    def self.extend_eschaton(&block)
      self.extend_object :object => Eschaton, :extension_block => block
    end  
    
    def self.extend_object(options, &block)
      object = options[:object]
      extension_block = options[:extension_block]

      if extension_block.not_nil?
        object.class_eval &extension_block
      end
    end

  end
  
end