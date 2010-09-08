module Eschaton
  
  class Frameworks
    
    def self.detect_and_require_files!
      Eschaton.require_file "#{self.framework_path}/init"
    end

    def self.detect_and_require_files_for_tests!
      Rails.env = "test"

      Eschaton.require_file "#{self.all_frameworks_path}/testing"
      Eschaton.require_file "#{self.framework_path}/testing"
    end

    def self.framework_path(options = {})
      version = if self.running_in_rails_three?
                  'rails_three'
                elsif self.running_in_rails_two?
                  'rails_two'
                end

      "#{File.dirname(__FILE__)}/frameworks/#{version}"
    end
    
    def self.all_frameworks_path
      "#{File.dirname(__FILE__)}/frameworks/all"
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