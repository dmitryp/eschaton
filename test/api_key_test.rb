require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class ApiKeyTest < Test::Unit::TestCase

  def setup
    @config_file = "#{File.dirname(__FILE__)}/test_api_keys.yml"
  end

  def test_get    
    assert_equal 'test_key', Google::ApiKey.get(:config_file => @config_file)

    Google::ApiKey.reset!
    assert_equal 'key_for_localhost', Google::ApiKey.get(:config_file => @config_file, :domain => 'localhost')

    Google::ApiKey.reset!    
    assert_equal 'key_for_test_localhost', Google::ApiKey.get(:config_file => @config_file, :domain => 'test.localhost') 

    Google::ApiKey.reset!    
    assert_equal 'ABQIAAAActtI8WkgLZcM_n8uvnIYsBTJQa0g3IQ9GZqIMmInSLzwtGDKaBT9A95dZjICm7SeC_GoxpzGlyCdQA', 
                 Google::ApiKey.get(:config_file => "no_such_file")
  end

end