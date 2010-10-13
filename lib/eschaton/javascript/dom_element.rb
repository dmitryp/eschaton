module Eschaton
  
  # There is a graphical element to mashups that inevitably requires access to the HTML Dom. Eschaton facilitates this through Eschaton#element.
  #
  # For example to the get the feedback div:
  #
  #  feedback_element = Eschaton.element(:feedback) 
  #
  # To get all anchor tags in divs:
  #
  #  anchors_in_divs = Eschaton.element('div > a') 
  # 
  # Once you have the elements you need, you could do some of the following:
  # 
  #  Eschaton.element(:feedback).update_html "Loading markers ..."
  #
  # ...
  #
  #  <div id="close_info_window_button"> | Close | </div>
  #
  #  Eschaton.element(:close_info_window_button).when_clicked do 
  #    map.close_info_window!
  #  end
  #
  # ...
  #
  #  <input type="text" id="location" />
  #
  #  map.click do |script, location|
  #    Eschaton.element(:location).value = location
  #  end
  #
  # ...
  #
  #  Eschaton.element(:location_button).set :class => :active
  #
  # ...
  #
  #  Eschaton.element('a.location_button').attributes :class => :location_button , :style => 'border: solid 2px green'
  #
  # ...
  #
  #  Eschaton.element(:debug_panel).append('This is a debug message!')
  #
  # If a method is undocumented here, see jQuerys[http://api.jquery.com/] .
  class DomElement < JavascriptObject
    attr_accessor :id, :element
    
    # Elements are obtained through Eschaton#element
    def initialize(options)
      self.variable = self.determine_element_selector(options)

      super :variable => self.variable 
    end
    
    # Updates the Html of the Element, any Inner Html is replaced.
    #
    # ==== Examples
    #
    #  map_feedback_element = Eschaton.element(:map_feedback)
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
    #  Eschaton.element('div.location_buttons').delete!
    #
    #  Eschaton.element(:current_label).delete!
    def delete!
      self << "#{self.variable}.remove();"
    end
    
    # 
    #
    #
    #
    #
    def when_clicked(&block)
      self.listen_to :event => :click, &block
    end
    
    # Listen to any of the events noted here[http://api.jquery.com/bind/]
    def listen_to(options, &block)
      event = options[:event].to_jquery_event
      function = self.script.function(&block)
      
      self << "#{self.variable}.bind('#{event}', #{function});"
    end
    
    # Sets the value of the element.
    #
    # ==== Examples
    #    
    #  Eschaton.element(:latitude).value = location.latitude
    #  Eschaton.element(:longitude).value = location.longitude
    #
    #  Eschaton.element(:current_location_label).text = location
    def value=(value)
      self << "#{self.variable}.val(#{value.to_js});"
    end

    alias text= value=

    # Gets the value of the element.
    #
    # ==== Examples
    #
    #  script.alert Eschaton.element(:current_location_name).value
    #
    #  script.alert Eschaton.element(:current_search_term).text
    def value
      "#{self.variable}.val()".to_sym
    end
    
    alias text value
    
    # Gets the value of the attibute with the given +name+
    #
    # ==== Examples
    #
    #  script.alert Eschaton.element(:location_button).attibute(:class)
    def attribute(name)
      "#{self.variable}.attr(#{name.to_s.to_js})".to_sym
    end
    
    # Sets the attributes of the element from the given +attribute_hash+.
    #
    # ==== Example
    # 
    #  Eschaton.element('a.location_button').attibutes(:class => :location_button, :style => 'border: solid 1px #DDD')
    def set_attributes(attribute_hash)
      self << "#{self.variable}.attr(#{attribute_hash.to_js})"      
    end
    
    alias set_attribute set_attributes

    protected
      def determine_element_selector(options)
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