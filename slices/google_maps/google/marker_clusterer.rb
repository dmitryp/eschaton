module Google

  # Creates and manages per-zoom-level clusters for large amounts(hundreds or thousands) of markers.
  #
  # If a method or event is not documented here please see the online[http://gmaps-utility-library-dev.googlecode.com/svn/tags/markerclusterer/1.0/docs/reference.html] docs for details  
  #
  # ==== Examples
  #  
  #  clusterer = Google::MarkerClusterer.new
  #
  #  clusterer.add_marker :location => {:latitude => -33.947, :longitude => 18.462}
  #  clusterer.add_marker :location => {:latitude => -33.979, :longitude => 18.465}
  #  clusterer.add_marker :location => {:latitude => -33.999, :longitude => 18.469}      
  #
  #  map.add_marker_clusterer clusterer
  #
  #  # With grid_size and max_zoom options
  #
  #  clusterer = Google::MarkerClusterer.new :grid_size => 80,
  #                                          :max_zoom => 12
  #
  #  clusterer.add_marker :location => {:latitude => -33.947, :longitude => 18.462}
  #  clusterer.add_marker :location => {:latitude => -33.979, :longitude => 18.465}
  #  clusterer.add_marker :location => {:latitude => -33.999, :longitude => 18.469}
  #
  #  map.add_marker_clusterer clusterer
  #
  #  # With style options for small and larger cluster
  #
  #  clusterer = Google::MarkerClusterer.new :styles => [{:height => 10, :width => 10, :url => 'small.png'}, 
  #                                                      {:height => 20, :width => 20, :url => 'bigger.png', :text_colour => :blue}]
  #
  #  clusterer.add_marker :location => {:latitude => -33.947, :longitude => 18.462}
  #  clusterer.add_marker :location => {:latitude => -33.979, :longitude => 18.465}
  #  clusterer.add_marker :location => {:latitude => -33.999, :longitude => 18.469}
  #
  #  map.add_marker_clusterer clusterer  
  class MarkerClusterer < MapObject
     

    # ==== Options:
    #
    # * +grid_size+ - Optional. The grid size of a cluster in pixel, each cluster will be a square. If you want the algorithm to run faster, you can set this value larger. The default value is 60
    # * +max_zoom+ - Optional. The max zoom level monitored by a marker cluster. If not given, the marker cluster assumes the maximum map zoom level. When max_zoom is reached or exceeded all markers will be shown without cluster.
    # * +styles+ - Optional. Custom styles for the cluster markers. The array of hashs should be ordered according to increasing cluster size, with the style for the smallest clusters first, and the style for the largest clusters last.
    #   Each style hash can have the following options:
    #   * +height+ - Height of cluster marker.
    #   * +width+ - Width of cluster marker.
    #   * +anchor+ - Anchor of cluster marker.
    #   * +text_colour+ - Colour of the Text displaying the number of markers that are clustered. The default value is 'black'.
    #   * +url+ - The url of the image that will be used for the cluster marker.
    def initialize(options = {})
      super

      script << "var #{self.marker_array_var} = new Array();"

      self.remaining_options = options
      self.prepare_remaining_options
    end
    
    # Adds a marker to the clusterer, +marker_or_options+ can be a Marker or whatever Marker#new supports.
    #
    # ==== Examples:
    #
    #  clusterer.add_marker :location => {:latitude => -33.947, :longitude => 18.462}
    def add_marker(marker_or_options = {})
      marker = Google::OptionsHelper.to_marker(marker_or_options)

      self.track_marker(marker)
    end
        
    def added_to_map(map) # :nodoc:
      script << "#{self.var} = new MarkerClusterer(#{map}, #{self.marker_array_var}, #{self.remaining_options.to_google_options(:dont_convert => 'styles')});"
    end    

    protected
      attr_accessor :remaining_options

      def track_marker(marker) # :nodoc:
        script << "#{self.marker_array_var}.push(#{marker});"
      end

      def marker_array_var # :nodoc:
        "#{self.var}_markers"
      end
      
      def prepare_remaining_options # :nodoc:      
        if self.remaining_options[:styles]
          javascript_styles = self.remaining_options[:styles].collect do |style|    
                                javascript = style.to_google_options

                                # Hack due to crap naming conventions of this library
                                javascript.gsub!('textColour', 'opt_textColor')
                                javascript.gsub!('anchor', 'opt_anchor')                                

                                javascript
                              end

          self.remaining_options[:styles] = "[#{javascript_styles.join(',')}]"
        end        
      end
      
  end
end