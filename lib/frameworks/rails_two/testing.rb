require 'test_help'

class EschatonMockView
  include ActionController::UrlWriter

  default_url_options[:only_path] = true

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