module Eschaton

  class JavascriptFunction < JavascriptObject
    attr_accessor :name
    
    def initialize(options = {})      
      self.name = options[:name]
      
      super
    end
    
    def self.from_block(options = {}, &block)
      options = options.prepare_options
      
      function_script = Eschaton.script

      if options.has_option?(:name)
        Eschaton.global_script << function_script
        function_script << "function #{options.name.to_js_method}(){"
      else
        function_script << "function(){"
      end

      Eschaton.with_global_script(function_script, &block)

      function_script << "}"
      
      Eschaton::JavascriptFunction.new(:script => function_script, :name => options.value_for(:name))
    end
    
    def call!(*options)
      if self.named?
        Eschaton.global_script << "#{self.name.to_js_method}(#{options.to_js_arguments});"
      else
        Eschaton.global_script << "(#{self}).call(#{options.to_js_arguments});"
      end
    end
    
    def named?
      self.name.not_blank?
    end

    def to_s
      self.script.to_s
    end
    
    alias to_js to_s
  end

end