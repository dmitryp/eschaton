module Eschaton
  
  class Slices # :nodoc:

    def self.load!
      self.slice_paths.each do |slice_path|
        mixin_slice_extentions slice_path
      end
      
      Eschaton::Frameworks.detect_and_require_slice_files!      
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

        Eschaton::Extensions.mixin :files_in => path, :matching => /([a-z_\d]*_generator_ext).rb/,
                                   :on => Eschaton::Script,
                                   :give_deprecation_warning => true

        # Script extentions
        Eschaton::Extensions.mixin :files_in => path, :matching => /([a-z_\d]*_script_ext).rb/,
                                   :on => Eschaton::Script
        
        # View extentions
        Eschaton::Extensions.mixin :files_in => path, :matching => /([a-z_\d]*_view_ext).rb/,
                                   :on => ActionView::Base

        # Controller extentions
        Eschaton::Extensions.mixin :files_in => path, :matching => /([a-z_\d]*_controller_ext).rb/,
                                   :on => ActionController::Base                       
      end
  end

end