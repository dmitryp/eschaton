module Eschaton

  class Frameworks

    def self.detect_and_require_files!
      Eschaton.log_info "Running in framework => #{self.framework_name}."
      
      Eschaton.require_file "#{self.framework_path}/eschaton"
      Eschaton.require_files :in => "#{self.framework_path}/extensions"

      if self.running_in_rails?
        Eschaton.require_files :in => "#{self.rails_framework_path}/extensions"
      end
    end

    def self.detect_and_require_slice_files!
      Eschaton::SliceLoader.slice_paths.each do |slice_path|
        slice_frameworks_path = "#{slice_path}/frameworks"
        if File.exists?(slice_frameworks_path)
          self.frameworks.each do |framework|
            framework_directory = "#{slice_frameworks_path}/#{framework}"
            
            if File.exists?(framework_directory)
              Dir["#{framework_directory}/**/*.rb"].each do |framewok_file|
                Eschaton.require_file framewok_file
              end
            end
          end
        end
      end
    end

    def self.detect_and_require_files_for_tests!
      Eschaton.require_file "#{self.all_frameworks_path}/testing"
      Eschaton.require_file "#{self.framework_path}/testing"
    end

    def self.framework_name
      if self.running_in_rails_three?
        'rails_three'
      elsif self.running_in_rails_two?
        'rails_two'
      end
    end

    def self.frameworks
      frameworks = ['all']

      frameworks << self.framework_name

      if self.running_in_rails?
        frameworks << 'rails'
      end

      frameworks
    end

    def self.framework_path
      "#{File.dirname(__FILE__)}/frameworks/#{self.framework_name}"
    end

    def self.rails_framework_path
      "#{File.dirname(__FILE__)}/frameworks/rails"
    end

    def self.all_frameworks_path
      "#{File.dirname(__FILE__)}/frameworks/all"
    end

    def self.rails_major_version
      Rails::VERSION::MAJOR
    end

    def self.running_in_rails?
      Object.const_defined?("Rails")
    end

    def self.running_in_rails_three?
      self.running_in_rails? && self.rails_major_version == 3
    end

    def self.running_in_rails_two?
      self.running_in_rails? && self.rails_major_version == 2
    end

  end
  
end