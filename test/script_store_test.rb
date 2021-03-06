require File.dirname(__FILE__) + '/test_helper'

class MyStore 
  extend Eschaton::ScriptStore

  define :before_map_script
end

class ScriptStoreTest < Test::Unit::TestCase
  
  def test_normal_form
    assert_blank MyStore.before_map_script.to_s

    MyStore.before_map_script << 'var 1 = 1;'
    assert_eschaton_output 'var 1 = 1;', MyStore.before_map_script.to_s

    MyStore.before_map_script << 'var 2 = 2;'
    assert_eschaton_output 'var 1 = 1;
                           var 2 = 2;',
                          MyStore.before_map_script.to_s

    MyStore.clear(:before_map_script)

    assert_blank MyStore.before_map_script.to_s
  end

  def test_with_block
    assert_blank MyStore.before_map_script.to_s

    MyStore.before_map_script do |script|
      script.comment "This is before map script"
      script << 'var 1 = 1;'
    end

    assert_eschaton_output '/* This is before map script */
                           var 1 = 1;',
                          MyStore.before_map_script.to_s

    MyStore.clear(:before_map_script)

    assert_blank MyStore.before_map_script.to_s
  end    
    
end