require File.dirname(__FILE__) + '/test_helper'

class ApiKeyTest < Test::Unit::TestCase

  def setup
    @config_file = "#{File.dirname(__FILE__)}/test_api_keys.yml"
        
    Google::ApiKey.reset!
  end

  def test_key_from_rails_environment
    assert_equal 'test_key', Google::ApiKey.get(:config_file => @config_file)
  end

  def test_with_host_name
    assert_equal 'key_for_localhost', Google::ApiKey.get(:config_file => @config_file, :domain => 'localhost')
   end

  def test_with_domain_name
    assert_equal 'key_for_test_localhost', Google::ApiKey.get(:config_file => @config_file, :domain => 'test.localhost.net') 
  end
  
  def test_with_non_existent_config_file
    assert_equal 'ABQIAAAActtI8WkgLZcM_n8uvnIYsBTJQa0g3IQ9GZqIMmInSLzwtGDKaBT9A95dZjICm7SeC_GoxpzGlyCdQA', 
                 Google::ApiKey.get(:config_file => "no_such_file")
  end
  
  def test_no_such_domain_in_config_file
    assert_equal 'test_key', Google::ApiKey.get(:domain => 'no_such_domain_in_config_file', :config_file => @config_file)  
  end

end