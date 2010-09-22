module Eschaton
  
  class DomElement < JavascriptObject
    attr_accessor :id, :element
    
    def initialize(options)    
      self.determine_element_selector options
      self.var = self.element
    end

    def update_html(html)
      html = html.interpolate_javascript_variables

      self << "#{self.element}.html(#{html});"
    end

    alias replace_html update_html
    alias html= update_html

    def delete!
      self << "#{self.element}.remove();"
    end
    
    def when_clicked(&block)
      self.listen_to :event => :click, &block
    end
    
    # http://api.jquery.com/bind/
    def listen_to(options, &block)
      event = options[:event].to_jquery_event
      function = self.script.function(&block)
      
      self << "#{self.element}.bind('#{event}', #{function});"
    end

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