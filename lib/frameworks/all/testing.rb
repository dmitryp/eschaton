module Eschaton
  
  module MockView
    
    def self.included(base)
      base.default_url_options[:only_path] = true
    end

    def render(options)
      if options.is_a?(String)
        options
      else
        "test output for render"
      end
    end

    def method_missing(method_id, *args)
    end

  end

end