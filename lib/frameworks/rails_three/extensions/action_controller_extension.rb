Eschaton::Extensions.extend_rails_controllers do

  def view_for_eschaton
    self.view_context
  end

end
