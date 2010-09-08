module Eschaton
  
  class SliceLoader # :nodoc:
  
    # Loads all slices found using slice_paths and extends relevant objects.
    def self.load!
      self.slice_paths.each do |slice_path|
        if Eschaton::Frameworks.running_in_rails_three?
          mixin_slice_extentions_for_rails_three slice_path
        elsif Eschaton::Frameworks.running_in_rails_two?
          mixin_slice_extentions_for_rails_two slice_path
        end
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

      def self.mixin_slice_extentions_for_rails_three(path)
        path = File.expand_path(path)

        Eschaton.log_info "loading slice '#{File.basename(path)}'"

        Eschaton.require_files :in => path

        # Generator extentions
        mixin_extentions :path => path, :pattern => /([a-z_\d]*_generator_ext).rb/,
                         :extend => ActionView::Helpers::PrototypeHelper::JavaScriptGenerator

        # View extentions
        mixin_extentions :path => path, :pattern => /([a-z_\d]*_view_ext).rb/,
                         :extend => ActionView::Base

        # Controller extentions
        mixin_extentions :path => path, :pattern => /([a-z_\d]*_controller_ext).rb/,
                         :extend => ActionController::Base                       
      end
    
      def self.mixin_slice_extentions_for_rails_two(path)
        path = File.expand_path(path)

        Eschaton.log_info "loading slice '#{File.basename(path)}'"
       
        Eschaton.dependencies.load_paths << path
        Dir["#{path}/*.rb"].each do |file|
          Eschaton.dependencies.require file
        end

        # Generator extentions
        mixin_extentions :path => path, :pattern => /([a-z_\d]*_generator_ext).rb/,
                         :extend => ActionView::Helpers::PrototypeHelper::JavaScriptGenerator

        # View extentions
        mixin_extentions :path => path, :pattern => /([a-z_\d]*_view_ext).rb/,
                         :extend => ActionView::Base

        # Controller extentions
        mixin_extentions :path => path, :pattern => /([a-z_\d]*_controller_ext).rb/,
                         :extend => ActionController::Base                       
      end

      def self.mixin_extentions(options)      
        Dir["#{options[:path]}/*.rb"].each do |file|
          if module_name = options[:pattern].match(file)
            options[:extend].extend_with_slice module_name[1].camelize.constantize
          end
        end
      end

  end

end