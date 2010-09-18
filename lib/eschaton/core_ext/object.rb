class Object # :nodoc:
    
  def to_array
    if self.is_a?(Array)
      self
    else
      [self]
    end
  end
  
  def true?
    self == true
  end

  def false?
    self == false
  end

  def not_nil?
    !self.nil?
  end

  def not_blank?
    !self.blank?
  end

  def in?(*values)
    values.flatten.include?(self)
  end

  def quote
    self.to_s.quote
  end
    
  def interpolated_javascript
    self.to_js.interpolated_javascript
  end
  
end