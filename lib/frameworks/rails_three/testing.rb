Rails.env = "test"
      
require 'rails/test_help'

Rails.application.routes.draw do |map|
  map.match ':controller(/:action(/:id(.:format)))'
end

class EschatonMockView
  include ActionDispatch::Routing::UrlFor
  include Rails.application.routes.url_helpers

  include Eschaton::MockView
end