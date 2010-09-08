module Eschaton
  
  class Frameworks
    
    def self.detect_and_load!
      if self.running_in_rails_three?
        self.load_for_framework 'rails_three'
      elsif self.running_in_rails_two?
        self.load_for_framework 'rails_two'
      else        
        puts 'plain old ruby'
      end
    end

    def self.load_for_framework(framework)
      require "#{File.dirname(__FILE__)}/frameworks/#{framework}"
    end

    def self.running_in_rails?
      Object.const_defined?("Rails")
    end

    def self.rails_version
      major, minor, release = Rails.version.split('.')

      return major.to_i, minor.to_i, release.to_i
    end

    def self.rails_major_version
      self.rails_version.first
    end

    def self.running_in_rails_three?
      self.running_in_rails? && self.rails_major_version == 3
    end

    def self.running_in_rails_two?
      self.running_in_rails? && self.rails_major_version == 2
    end

  end
  
end