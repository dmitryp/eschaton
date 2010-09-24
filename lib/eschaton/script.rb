module Eschaton

  class Script
    attr_accessor :lines

    def initialize(options = {})
      self.lines = []
    end

    def <<(javascript)
      self.recorder << javascript if self.recording?

      output = if self.redirect_output?
                 self.redirected_output
               else
                 self.lines
               end
      
      if self.respond_to?(:before_javascript_added)
        javascript = self.before_javascript_added(javascript)
      end
      
      output << javascript

      javascript
    end
    
    alias raw_javascript <<
              
    # Allows for recording any script contained within the block passed to this method.
    #
    # This is useful for testing and debugging output when generating script. 
    #
    # Example:
    #  script << "// This is before recording"
    #
    #  # record will contain the script generated within the block
    #  record = script.record do
    #             script << "// This is within recording"    
    #             script << "// Again, this is within a record"
    #           end
    #
    #  script << "// This is after recording"
    def record(&block)
      recorder = self.start_recording!

      yield self

      self.stop_recording!

      recorder
    end

    def to_s
      expanded_output = self.lines.collect(&:to_s)

      output = expanded_output.join("\n")

      output.strip_each_line!

      output = ' ' if output.blank? # This issue is weird, figure it out

      if output.respond_to?(:html_safe)
        output.html_safe
      else
        output
      end
    end

    alias inspect to_s
    alias to_js to_s
    
    def translate_to_javascript_method_call(method_name, *options)
      method_name = method_name.to_s

      if method_name =~ /\?$/
        "#{method_name.to_js_method}(#{options.to_js_arguments})".to_sym
      else
        self << "#{method_name.to_js_method}(#{options.to_js_arguments});"
      end
    end
    
    alias method_missing translate_to_javascript_method_call
    
    protected
      attr_accessor :recorder, :redirected_output

      def start_recording!
        recorder = Eschaton.script

        self.recorder = recorder
            
        recorder
      end
    
      def stop_recording!
        self.recorder = nil
      end
    
      def recording?
        self.recorder.not_nil?
      end

      def redirect_output(options)
        self.redirected_output = options[:to]
      end
      
      def redirect_output?
        self.redirected_output.not_nil?
      end
  end

end
