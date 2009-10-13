module Google

  # Creates and manages per-zoom-level clusters for large amounts of markers (hundreds or thousands).
  # Read more[http://gmaps-utility-library-dev.googlecode.com/svn/tags/markerclusterer/1.0/] online.  
  class MarkerClusterer < MapObject
    
    def initialize(options = {})
      super

      script << "var #{self.marker_array_var} = new Array();"

      self.remaining_options = options
    end

    def add_marker(marker_or_options = {})
      marker = Google::OptionsHelper.to_marker(marker_or_options)

      self.track_marker(marker)
    end
        
    def added_to_map(map) # :nodoc:
      script << "#{self.var} = new MarkerClusterer(#{map}, #{self.marker_array_var}, #{self.remaining_options.to_google_options});"
    end    

    protected
      attr_accessor :remaining_options
      def track_marker(marker)
        script << "#{self.marker_array_var}.push(#{marker});"
      end
    
      def marker_array_var
        "#{self.var}_markers"
      end


  end
end