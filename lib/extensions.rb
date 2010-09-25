module Eschaton

  class Extensions

    def self.extend_rails_controllers(&block)
      self.extend_object :object => ActionController::Base, :extension_block => block
    end
    
    def self.extend_eschaton(&block)
      self.extend_object :object => Eschaton, :extension_block => block
    end
    
    def self.mixin(options)      
      options = options.prepare_options

      directory = options.files_in
      pattern = options.matching
      object = options.on

      Dir["#{directory}/*.rb"].each do |file|
        if module_name = pattern.match(file)
          module_name = module_name[1].camelize
          extension_module = module_name.constantize

          options.has_option?(:give_deprecation_warning) do 
            new_module_name = module_name.gsub('GeneratorExt', 'ScriptExt')
            old_file_name = file.gsub(Rails.root, '')
            new_file_name = old_file_name.gsub('generator_ext', 'script_ext')

            Eschaton::Deprecation.warning :message => "Please rename the module #{module_name} to #{new_module_name} and the file #{old_file_name} to #{new_file_name}",
                                          :include_called_from => false
          end

          self.extend_object :object => object, :with_module => extension_module
        end
      end
    end

    def self.extend_object(options)
      object = options[:object]
      extension_block = options[:extension_block]
      extension_module = options[:with_module]

      if extension_block.not_nil?
        object.class_eval &extension_block
      elsif extension_module.not_nil?
        object.class_eval do
          include extension_module
        end
      end
    end

  end

end