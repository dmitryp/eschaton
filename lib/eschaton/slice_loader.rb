module Eschaton
  
  class SliceLoader # :nodoc:
  
    # Loads all slices found using slice_paths and extends relevant objects.
    def self.load!
      self.slice_paths.each do |slice_path|
        mixin_slice_extentions slice_path
      end
    end

    private
      def self.plugin_slice_path
        File.expand_path("#{File.dirname(__FILE__)}/../slices")
      end

      def self.application_slice_path
        "#{Rails.root}/lib/eschaton_slices"
      end

      def self.slice_paths
        paths = [self.plugin_slice_path, self.application_slice_path]

        paths.collect{|path|
          Dir["#{path}/*"]
        }.flatten
      end

      def self.mixin_slice_extentions(path)
        path = File.expand_path(path)

        Eschaton.log_info "loading slice '#{File.basename(path)}'"

        Eschaton.require_files :in => path

        # Generator extentions no longer supported and gives deprecation warning
        mixin_extentions :path => path, :pattern => /([a-z_\d]*_generator_ext).rb/,
                         :extend => Eschaton::Script,
                         :deprecation_warning => true

        # Script extentions
        mixin_extentions :path => path, :pattern => /([a-z_\d]*_script_ext).rb/,
                         :extend => Eschaton::Script

        # View extentions
        mixin_extentions :path => path, :pattern => /([a-z_\d]*_view_ext).rb/,
                         :extend => ActionView::Base

        # Controller extentions
        mixin_extentions :path => path, :pattern => /([a-z_\d]*_controller_ext).rb/,
                         :extend => ActionController::Base                       
      end

      def self.mixin_extentions(options)      
        options = options.prepare_options
        
        Dir["#{options.path}/*.rb"].each do |file|
          if module_name = options.pattern.match(file)
            module_name = module_name[1].camelize

            options.has_option?(:deprecation_warning) do 
              new_module_name = module_name.gsub('GeneratorExt', 'ScriptExt')
              old_file_name = file.gsub(Rails.root, '')
              new_file_name = old_file_name.gsub('generator_ext', 'script_ext')

              Eschaton::Deprecation.warning :message => "Please rename the module #{module_name} to #{new_module_name} and the file #{old_file_name} to #{new_file_name}",
                                            :include_called_from => false
            end
                        
            options[:extend].extend_with_eschaton_slice module_name.constantize
          end
        end
      end

  end

end