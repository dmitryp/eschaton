class String
  
  def to_icon
    Google::Icon.new(:image => self)
  end
    
end

class Symbol

  def to_icon
    Google::Icon.new(:image => self)
  end
  
  def to_location
    self
  end

  def to_google_control_class
    "G#{self.to_s.classify}Control".to_sym
  end

  def to_map_type
    "G_#{self.to_s.upcase}_MAP".to_sym
  end
    
end

class Hash
  
  def to_google_options
    args = self.collect do |key, value|
      key = key.to_js_method.to_sym
      "#{key}: #{value.to_js}"
    end

    "{#{args.join(', ')}}"
  end
  
  def to_location
    Google::Location.new(self)
  end
  
  def to_marker
    Google::Marker.new(self)
  end
  
end
