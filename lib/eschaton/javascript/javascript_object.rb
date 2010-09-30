module Eschaton
  
  # Represents a javascript object on which you can call methods.
  #
  # Any method called on this object will translate the methods into a javascript compatable 
  # camelCase method which is called on the +var+. Calls are stacked and javascript is returned by calling to_s.
  class JavascriptObject
    attr_accessor :variable, :create_variable

    # ==== Options:
    # * +variable+ - Optional. The name of the javascript variable, defaulted to a random name.
    # * +create_variable+ - Optional. Indicates whether the javascript variable should be created and assigned, defaulted to +true+.
    # * +script+ - Optional. The script object to use for generation.
    def initialize(options = {})
      options.default! :variable => :random, :create_variable => true

      self.variable = options.extract(:variable)
      self.create_variable = options.extract(:create_variable)

      @script = options.extract(:script)
    end

    def self.existing(options)
      options[:create_variable] = false

      self.new(options)
    end

    def create_variable?
      self.create_variable
    end
    
    def existing_variable?
      !self.create_variable?
    end

    def translate_to_javascript_method_call(method_name, *options)
      method_name = method_name.to_s

      if method_name =~ /\?$/
        "#{self.variable}.#{method_name.to_js_method}(#{options.to_js_arguments})".to_sym
      else
        self << "#{self.variable}.#{method_name.to_js_method}(#{options.to_js_arguments});"
      end
    end
    
    alias method_missing translate_to_javascript_method_call
    
    def <<(javascript)
      self.script << javascript
    
      javascript
    end

    def to_s
      self.variable.to_s
    end

    alias to_js to_s
    alias to_json to_s

    def variable=(name)
      @variable = if name == :random
                    Eschaton.random_id
                  else
                    name
                  end
    end

    protected
      def script
        @script || Eschaton.global_script
      end

  end

end