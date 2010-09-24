ActionController::Base.class_eval do

  def view_for_eschaton
    self.view_context
  end

end
