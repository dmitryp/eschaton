require File.dirname(__FILE__) + '/test_helper'

class Store
  extend Eschaton::ScriptStore

  define :before_map_script
  
end

class ExpanderTest < Test::Unit::TestCase

  def test_expander_with_scriptstore    
    generator = Eschaton.script

    generator << "Before expander"
    generator << Store.before_map_script
    generator << "After expander"    
    
    Store.before_map_script << "Before Map Script"
    Store.before_map_script.comment "This is before the map script!"
    
    Store.clear(:before_map_script)
    
    assert_eschaton_output 'Before expander
                           Before Map Script
                           /* This is before the map script! */
                           After expander',
                           generator
  end

end