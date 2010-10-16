Eschaton::Extensions.make_globally_available do

  def jQuery(selector = nil, &block)
    if selector.not_nil?
      Eschaton::Jquery.new selector, &block
    else
      Eschaton::Jquery
    end
  end

end

module Eschaton

  # jQuery, without seeds.
  #
  # As a convenience, if a symbol is supplied as a +selector+ it will be treated as the +id+ and
  # if a string is supplied it is treated as the +selector+.
  #
  # ==== Options:
  #
  # * +id+ - Optional. Finds elements by their id.
  # * +css_class+ - Optional. Finds elements by their css class.
  # * +selector+ - Optional. Finds elements using a jQuery selector.
  #
  # ==== Examples
  #
  #  feedback_element = jQuery(:feedback) 
  #
  #  feedback_element = jQuery(:id => :feedback)
  #
  #  anchors_in_divs = jQuery('div > a')
  #
  #  anchors_in_divs = jQuery(:selector => 'div > a')
  #
  #  selected_elements = jQuery(:css_class => 'selected')
  class Jquery < JavascriptObject
    attr_accessor :id, :element
    
    def initialize(selector) # :nodoc:
      self.variable = self.determine_element_selector(selector)

      super :variable => self.variable
      
      yield self if block_given?
    end
    
    # Any script generated within the +block+ will execute when the document is ready.
    #
    #  jQuery.ready do
    #    jQuery(:feedback).update_html "The Document is ready"
    #  end 
    def self.ready(&block)
      self << "jQuery(document).ready(function() {"

      yield Eschaton.global_script
      
      self << "})"
    end
    
    # Updates the html content.
    #
    # ==== Examples
    #
    #  map_feedback_element = jQuery(:map_feedback)
    #
    #  map_feedback_element.update_html "Loading markers ..."
    #  ...
    #  map_feedback_element.replate_html "Processing markers ..."
    #  ...
    #  map_feedback_element.html = "Done"
    def update_html(html)
      html = html.interpolate_javascript_variables

      self << "#{self.variable}.html(#{html});"
    end

    alias replace_html update_html
    alias html= update_html
    
    # Deletes the element from the Dom.
    #
    # ==== Examples
    #
    #  jQuery('div.location_buttons').delete!
    #
    #  jQuery(:current_label).delete!
    def delete!
      self << "#{self.variable}.remove();"
    end
    
    # When the element is clicked the script generated from the given +block+ will be executed.
    #
    # ==== Example
    #
    #  jQuery(:close_info_window_button).click do |script|
    #    script.map.close_info_window
    #  end
    def click(&block)
      self.listen_to :event => :click, &block
    end
    
    # Listen to an +event+ on the elements.
    #
    # ==== Options:
    # 
    # * +event+ - Required. The event type to listen to, see jQuerys[http://api.jquery.com/bind/] event types for supported events.
    #
    # ==== Example
    #
    #  marker_links = jQuery('a.marker_link')
    #
    #  marker_links.listen_to(:event => :mouse_over) do |script|
    #    marker_links.set_style => 'background-color: green'
    #  end
    #
    #  marker_links.listen_to(:event => :mouse_leave) do |script|
    #    marker_links.set_style => 'background-color: grey'
    #  end    
    def listen_to(options, &block)
      event = options[:event].to_jquery_event
      function = self.javascript.function(&block)
      
      self << "#{self.variable}.bind('#{event}', #{function});"
    end
    
    # Sets the value of the element.
    #
    # ==== Examples
    #    
    #  jQuery(:latitude).value = location.latitude
    #  jQuery(:longitude).value = location.longitude
    #
    #  jQuery(:current_location_label).text = location
    def value=(value)
      self << "#{self.variable}.val(#{value.to_js});"
    end

    alias text= value=

    # Gets the value of the element.
    #
    # ==== Examples
    #
    #  script.alert jQuery(:current_location_name).value
    #
    #  script.alert jQuery(:current_search_term).text
    def value
      "#{self.variable}.val()".to_sym
    end
    
    alias text value
    
    # Gets the value of the attibute with the given +name+.
    #
    # ==== Example
    #
    #  script.alert jQuery(:location_button).attibute(:class)
    def attribute(name)
      "#{self.variable}.attr(#{name.to_s.to_js})".to_sym
    end
    
    # Sets the attributes of the element from the given +attribute+ hash.
    #
    # ==== Examples
    # 
    #  jQuery('a.location_button').set_attributes(:class => :location_button, :style => 'border: solid 1px #DDD')
    #
    # If you are setting only a single attribute you can use set_attribute:
    #
    #  jQuery('a.location_button').set_attribute(:class => :location_button)    
    def set_attributes(attributes)
      self << "#{self.variable}.attr(#{attributes.to_js})"
    end
    
    alias set_attribute set_attributes
    
    # Sets the styles of the element from the given +styles+ hash.
    #
    # ==== Examples
    # 
    #  jQuery(:feedback).set_styles 'background-color' => 'green', :border => 'solid 1px black'
    #
    # If you are setting only a single style you can use set_style:
    #
    #  jQuery(:feedback).set_style 'background-color' => 'green'
    def set_styles(styles)
      self << "#{self.variable}.css(#{styles.to_css_styles})"      
    end

    alias set_style set_styles
    
    protected
      def determine_element_selector(options) #:nodoc:
        options = if options.is_a?(String)
                    {:selector => options.to_s}.prepare_options
                  elsif options.is_a?(Symbol)
                    {:element_id => options.to_s}.prepare_options
                  else
                    options.prepare_options(:rename => {:id => :element_id})
                  end

        selector = if options.has_option?(:element_id)
                     "##{options.element_id}"
                    elsif options.has_option?(:css_class)
                      ".#{options.css_class}"
                    elsif options.has_option?(:selector)
                      options.selector
                    end

        "jQuery('#{selector}')"
      end    
  end

end