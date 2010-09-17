module Eschaton
  
  class DomElement < JavascriptObject
    attr_accessor :id, :element
    
    def initialize(options)    
      self.determine_element_selector options
    end

    def update_html(html)
      html = html.interpolate_javascript_variables

      self << "#{self.element}.html(#{html});"
    end

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

    alias replace_html update_html
    
    protected
      def determine_element_selector(options)
        options = options.prepare_options(:rename => {:id => :element_id})

        selector = if options.has_option?(:element_id)
                     "##{options.element_id}"
                    elsif options.has_option?(:css)
                      ".#{options.css}"
                    elsif options.has_option?(:path)
                      options.path
                    end
      
        self.element = "jQuery('#{selector}')"
      end    
  end

end