Eschaton::Extensions.extend_rails_controllers do
  
  before_filter :set_current_view

  def set_current_view
    Eschaton.current_view = self.view_for_eschaton
  end
  
end
