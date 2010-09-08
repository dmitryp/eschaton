class MapGenerator < Rails::Generators::Base
  attr_accessor :slice_class

  def self.source_root
    @source_root ||= "#{File.dirname(__FILE__)}/templates"
  end

  def copy_eschaton_files
    # Config file
    copy_file "eschaton_google_api_keys.yml", "config/eschaton_google_api_keys.yml"

    # Javascripts
    copy_file "jquery.js", "public/javascripts/jquery.js"
    copy_file "eschaton.js", "public/javascripts/eschaton.js"      

    # Controller and view files
    copy_file "map_controller.rb", "app/controllers/map_controller.rb"
    copy_file "map_helper.rb", "app/helpers/map_helper.rb"

    copy_file "map.erb", "app/views/layouts/map.erb"
    copy_file "index.erb", "app/views/map/index.erb"

    # Marker icons
    copy_file "blue.png", "public/images/blue.png"
    copy_file "red.png", "public/images/red.png"
    copy_file "yellow.png", "public/images/yellow.png"
    copy_file "green.png", "public/images/green.png"      
    copy_file "shadow.png", "public/images/shadow.png"

    # Eschaton application slice
    slice_name = File.basename(Rails.root).singularize.downcase
    self.slice_class = slice_name.classify
    slice_directory = "lib/eschaton_slices/#{slice_name}"

    template "generator_ext.rb", "#{slice_directory}/#{slice_name}_generator_ext.rb" 
    template "view_ext.rb", "#{slice_directory}/#{slice_name}_view_ext.rb"
  end

end