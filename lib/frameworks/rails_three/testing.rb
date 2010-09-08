require 'rails/test_help'

class EschatonMockView
  include ActionDispatch::Routing::UrlFor
  include Rails.application.routes.url_helpers

  include Eschaton::MockView
end