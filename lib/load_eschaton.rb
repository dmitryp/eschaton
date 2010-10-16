require "#{File.dirname(__FILE__)}/eschaton/eschaton"
require "#{File.dirname(__FILE__)}/frameworks"
require "#{File.dirname(__FILE__)}/extensions"
require "#{File.dirname(__FILE__)}/eschaton/script_store"
require "#{File.dirname(__FILE__)}/eschaton/javascript/javascript_object"

Dir["#{File.dirname(__FILE__)}/eschaton/**/*.rb"].each do |file|
  Eschaton.dependencies.require file
end

Eschaton::Frameworks.detect_and_require_files!
Eschaton::Slices.load!