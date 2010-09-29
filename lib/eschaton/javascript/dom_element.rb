module Eschaton
  
  class DomElement < JavascriptObject
    attr_accessor :id, :element
    
    def initialize(options)
      self.determine_element_selector options

      self.variable = self.element
      
      super :var => self.variable 
    end

    def update_html(html)
      html = html.interpolate_javascript_variables

      self << "#{self.variable}.html(#{html});"
    end

    alias replace_html update_html
    alias html= update_html

    def delete!
      self << "#{self.variable}.remove();"
    end
    
    def when_clicked(&block)
      self.listen_to :event => :click, &block
    end
    
    # http://api.jquery.com/bind/
    def listen_to(options, &block)
      event = options[:event].to_jquery_event
      function = self.script.function(&block)
      
      self << "#{self.variable}.bind('#{event}', #{function});"
    end
    
    def value=(value)
      self << "#{self.variable}.val(#{value.to_js});"
    end

    alias text= value=

    def value
      "#{self.variable}.val()".to_sym
    end
    
    alias text value

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
      
        self.element = "jQuery('#{selector}')"
      end    
  end

end