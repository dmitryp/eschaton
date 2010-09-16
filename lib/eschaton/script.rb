module Eschaton

  class Script
    attr_accessor :lines, :recorder

    def initialize
      self.lines = []
    end

    def <<(javascript)
      self.recorder << javascript if self.recording?
      self.lines << javascript
    
      javascript
    end
              
    # Allows for recording any script contained within the block passed to this method. This will return what was 
    # recorded in the form of a JavascriptGenerator.
    #
    # This is useful for testing and debugging output when generating script. 
    #
    # Example:
    #  script << "// This is before recording"
    #
    #  # record will containin the script generated within the block
    #  record = script.record_for_test do
    #             script << "// This is within recording"    
    #             script << "// Again, this is within a record"
    #           end
    #
    #  script << "// This is after recording"
    def record_for_test(&block)
      recorder = self.start_recording!

      yield self

      self.stop_recording!

      recorder
    end

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

    # Returns script that has been generated and allows for addtional +options+ regarding generation than the default +to_s+ method.
    #
    # ==== Options:
    # * +strip_each_line+ - Optional. Indicates if leading and trailing whitespace should be stripped from each line, defaulted to +true+.
    # * +inline+ - Optional. Indicates if new lines should be stripped from the generated script, defaulted to +false+.
    def generate(options = {})
      options.default! :strip_each_line => true, :inline => false

      expanded_output = self.lines.collect(&:to_s)

      output = if options[:inline].false?
                 expanded_output.join("\n")
               else
                 expanded_output.join
               end

      output.strip_each_line! if options[:strip_each_line].true?
      
      if output.respond_to?(:html_safe)
        output.html_safe
      else
        output
      end
    end

    def to_s
      self.generate
    end

    alias inspect to_s

    def self.extend_with_slice(extention_module)
      include extention_module
    end
    
  end

end
