module Eschaton

  class JavascriptFunction < JavascriptObject

    def self.from_block(options = {}, &block)
      options = options.prepare_options
      
      function_script = Eschaton.script

      if options.has_option?(:name)   
        function_script << "function #{options.name.to_js_method}(){"
      else
        function_script << "function(){"
      end

      Eschaton.with_global_script(function_script, &block)

      function_script << "}"
      
      if options.has_option?(:name)
        Eschaton.global_script << function_script  
      end 

      Eschaton::JavascriptFunction.new(:script => function_script)
    end

    def to_s
      self.script.to_s
    end
    
    alias to_js to_s

  end

end