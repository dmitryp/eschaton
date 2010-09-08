require "#{File.dirname(__FILE__)}/frameworks"
require "#{File.dirname(__FILE__)}/eschaton/eschaton"
require "#{File.dirname(__FILE__)}/eschaton/script_store"
require "#{File.dirname(__FILE__)}/eschaton/javascript/javascript_object"

Dir["#{File.dirname(__FILE__)}/eschaton/**/*.rb"].each do |file|
  Eschaton.dependencies.require file
end

Eschaton::SliceLoader.load!
Eschaton::Frameworks.detect_and_load!

