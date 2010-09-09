Rails.env = "test"
      
require 'rails/test_help'

Rails.application.routes.draw do |map|
  map.create_marker '/marker/create/:id', :controller => :marker, :action => :create
end

class EschatonMockView
  include ActionDispatch::Routing::UrlFor
  include Rails.application.routes.url_helpers

  include Eschaton::MockView
end