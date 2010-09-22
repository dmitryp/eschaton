module Eschaton

  # Represents a javascript function, this can be used to write javascript functions that are either anonymous or are named.
  # If the JavascriptFunction is anonymous it can be passed to methods that use the anonymous function.
  #  
  # ==== Examples
  #
  #  function = Eschaton.function do |function|
  #              function.alert("Hello world!")
  #             end
  #
  #  function.call!
  #
  # It can also be used to declare a function that can be called at a later stage:
  #  
  #  function = Eschaton.function(:name => :hello_world) do |function|
  #               function.alert("Hello world!")
  #             end
  #
  #  script.confirm("Call this function?") do
  #    function.call!
  #  end
  #
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
      if self.anonymous?
        Eschaton.global_script << "(#{self}).call(#{options.to_js_arguments});"
      else
        Eschaton.global_script << "#{self.name.to_js_method}(#{options.to_js_arguments});"
      end
    end

    def anonymous?
      self.name.blank?
    end

    def function(options = {}, &block)
      Eschaton.function options, &block
    end

    def variable(name)
      Eschaton.variable :var => name
    end

    def element(options)
      Eschaton.element options
    end  

    def to_s
      self.script.to_s
    end
    
    alias to_js to_s
  end

end