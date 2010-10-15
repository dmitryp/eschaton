class String

  def to_jquery_event
    self.gsub('_', '')
  end

  def to_css_style
    self.gsub('_', '-')
  end
  
end

class Symbol

  def to_jquery_event
    self.to_s.to_jquery_event
  end

  def to_css_style
    self.to_s.to_css_style
  end
  
  
end
