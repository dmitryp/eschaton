module Google

  class Location < MapObject
    attr_accessor :latitude, :longitude
  
    def initialize(options)
      super options

      self.latitude = options[:latitude]
      self.longitude = options[:longitude]
    end
    
    def latitude
      if self.existing_variable?
        "#{self.variable}.lat()".to_sym
      else
        @latitude
      end
    end
    
    def longitude
      if self.existing_variable?
        "#{self.variable}.lng()".to_sym
      else
        @longitude
      end
    end    
    
    def to_s
      if self.create_variable?
        "new GLatLng(#{self.latitude}, #{self.longitude})"
      else
        self.variable.to_s
      end
    end
    
    def to_js
      self.to_s
    end
    
    def to_hash
      {:latitude => self.latitude, :longitude => self.longitude}
    end

  end

end