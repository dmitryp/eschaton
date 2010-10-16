module Google
  
  class Event < MapObject
    attr_reader :on, :event

    def initialize(options = {})
      options.default! :variable => "#{options[:on]}_#{options[:event]}_event"

      super

      @on = options[:on]
      @event = options[:event]
    end
    
    def listen_to(options = {})
      options.default! :with => []

      with_arguments = options[:with].to_array
      js_arguments = with_arguments.join(', ')

      yield_args = if options[:yield_order]
                     options[:yield_order]
                   else
                     with_arguments
                   end

      # Wrap the GEvent closure in a method to prevent the non-closure bug of javascript and google maps.
      wrap_method = "#{self.on}_#{self.event}(#{self.on})"

      self << "function #{wrap_method}{"
      self << "return GEvent.addListener(#{self.on}, \"#{self.event}\", function(#{js_arguments}) {"

      yield *(self.script.to_array + yield_args)

      self <<  "});"
      self << "}"

      script << "#{self.variable} = #{wrap_method};"
    end    

    def remove
      self << "GEvent.removeListener(#{self.variable});"
    end

  end

end