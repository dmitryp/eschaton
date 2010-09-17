class String

  def to_jquery_event
    self.gsub('_', '')
  end
  
end

class Symbol
  
  def to_jquery_event
    self.to_s.to_jquery_event
  end
  
end
