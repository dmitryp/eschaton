module Eschaton

  # Represents a javascript function, this can be used to write javascript functions that are either anonymous or are named.
  # If the JavascriptFunction is anonymous it can be passed to methods that use the anonymous function.
  #  
  # ==== Examples
  #
  #  function = javascript.function do |function|
  #              function.alert("Hello world!")
  #             end
  #
  #  function.call!
  #
  # It can also be used to declare a function that can be called at a later stage:
  #  
  #  function = javascript.function(:name => :hello_world) do |function|
  #               function.alert("Hello world!")
  #             end
  #
  #  script.confirm("Call this function?") do
  #    function.call!
  #  end
  #
  class JavascriptFunction < Eschaton::Script
    attr_accessor :name, :body
    
    def initialize(options = {}, &block)      
      super
      
      options = options.prepare_options

      self.name = options[:name]
      self.body = Eschaton.script

      if self.anonymous?
        self << "function(){"        
      else
        Eschaton.global_script << self
        self << "function #{options.name.to_js_method}(){"
      end

      self << self.body

      Eschaton.with_global_script(self.body, &block)

      self << "}"

      redirect_output :to => self.body  
    end
    
    def before_javascript_added(javascript)
      if javascript.is_a?(Eschaton::JavascriptFunction)
        javascript.body
      else
        javascript
      end
    end
        
    def self.from_block(options = {}, &block)
      Eschaton::JavascriptFunction.new(options, &block)
    end

    def call!(*options)
      if self.anonymous?
        Eschaton.global_script << "(#{self}).call(#{options.to_js_arguments});"
      else
        Eschaton.global_script << "#{self.name.to_js_method}(#{options.to_js_arguments});"
      end
    end

    def anonymous?
      self.name.blank?
    end
  end

end