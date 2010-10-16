lib_directory = File.dirname(__FILE__)

require "#{lib_directory}/eschaton/eschaton"
require "#{lib_directory}/frameworks"
require "#{lib_directory}/extensions"
require "#{lib_directory}/eschaton/script_store"
require "#{lib_directory}/eschaton/javascript/javascript_object"

Dir["#{lib_directory}/eschaton/**/*.rb"].each do |file|
  Eschaton.dependencies.require file
end

Eschaton::Frameworks.detect_and_require_files!
Eschaton::Slices.load!