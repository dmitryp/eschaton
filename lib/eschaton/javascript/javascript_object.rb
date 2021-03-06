module Eschaton
  
  # Represents a javascript object on which you can call methods.
  #
  # Any method called on this object will translate the methods into a javascript compatable 
  # camelCase method which is called on the +var+. Calls are stacked and javascript is returned by calling to_s.
  class JavascriptObject
    attr_reader :var

    # ==== Options:
    # * +var+ - Optional. The name of the javascript variable, defaulted to a random name.
    # * +create_var+ - Optional. Indicates whether the javascript variable should be created and assigned, defaulted to +true+.
    # * +script+ - Optional. The script object to use for generation.
    def initialize(options = {})
      options.default! :var => :random, :create_var => true
    
      self.var = options.extract(:var)
      @create_var = options.extract(:create_var)
      @script = options.extract(:script)
    end

    def self.existing(options)
      options[:create_var] = false

      self.new(options)
    end

    def create_var?
      @create_var
    end

    # Converts the given +method+ and +args+ to a javascript method call with arguments.  
    def method_to_js(method, *args)
      method_name = method.to_s 
      if method_name =~ /\?$/
        "#{self.var}.#{method_name.chop.to_js_method}(#{args.to_js_arguments})".to_sym
      else
        self << "#{self.var}.#{method.to_js_method}(#{args.to_js_arguments});"
      end
    end

    alias method_missing method_to_js
    
    # Adds +javascript+ to the generator.
    #
    # self << "var i = 10;"
    def <<(javascript)
      self.script << javascript
    
      javascript
    end

    def to_s
      self.var.to_s
    end

    alias to_js to_s
    alias to_json to_s

    protected
      def script
        @script || Eschaton.global_script
      end

    private
      def var=(name)
        @var = if name == :random
                 "_#{rand(2000)}"
               else
                 name
               end
      end
    
  end

end