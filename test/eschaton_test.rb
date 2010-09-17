require File.dirname(__FILE__) + '/test_helper'

class TestJavascriptObject

  def self.write_one
    Eschaton.global_script << "One!"
  end

  def write_two
    Eschaton.global_script << "Two!"    
  end

end

class EschatonTest < Test::Unit::TestCase
  
  def teardown
    Eschaton.global_script = nil
  end
  
  def test_current_view
    assert_not_nil Eschaton.current_view
  end

  def test_write_to_global_script    
    with_eschaton do |script|
      assert_eschaton_output 'One!
                             Two!' do
                               TestJavascriptObject.write_one
                               TestJavascriptObject.new.write_two
                             end
    end
  end

  def test_get_global_script
    assert_nil Eschaton.global_script

    global_script = Eschaton.script
    Eschaton.global_script = global_script

    assert_equal global_script, Eschaton.global_script

    Eschaton.global_script do |script|
      assert_not_nil script
      assert_equal script, Eschaton.global_script
    end
  end

  def test_global_script_with_no_script
    assert_nil Eschaton.global_script

    return_script = with_eschaton do |script|
                      assert_not_nil script
                      assert_not_nil Eschaton.global_script
                      assert_equal script, Eschaton.global_script         
                    end

    assert_nil Eschaton.global_script
    assert_not_nil return_script
  end
  
  def test_global_script_with_script
     generator = Eschaton.script

     assert_nil Eschaton.global_script
          
     return_script = Eschaton.with_global_script(generator) do |script|
                       assert_not_nil script
                       assert_not_nil Eschaton.global_script
       
                       assert_equal generator, script
                       assert_equal generator, Eschaton.global_script
                       assert_equal script, Eschaton.global_script
                     end
     
     assert_nil Eschaton.global_script
     assert_equal generator, return_script
  end  
  
  
  def test_interpolate_javascript_variables
    assert_equal '"There is no interpolation in this string."', 
                 "There is no interpolation in this string.".interpolate_javascript_variables

    assert_equal '"This is my " + name + ""', "This is my #[name]".interpolate_javascript_variables
    assert_equal '"Latitude is " + location.lat() + " and Logitude is " + location.lng() + ""', 
                 "Latitude is #[location.lat()] and Logitude is #[location.lng()]".interpolate_javascript_variables
    assert_equal '"From hash " + hash.field_one + " and " + hash.field_two + ""', 
                 "From hash #[hash.field_one] and #[hash.field_two]".interpolate_javascript_variables
  end

  def test_url_for
    assert_equal "'/posts/create'", Eschaton.url_for_javascript(:controller => :posts, :action => :create)
    assert_equal "'/posts/update/1'", Eschaton.url_for_javascript(:controller => :posts, :action => :update, :id => 1)
    
    assert_equal "'/marker/create?longitude=' + location.lng() + '&latitude=' + location.lat() + ''",
                 Eschaton.url_for_javascript(:controller => :marker, :action => :create, :latitude => '#location.lat()', 
                                             :longitude => '#location.lng()')
    
    assert_eschaton_output :create_marker_url_for_javascript,
                           Eschaton.url_for_javascript(:controller => :marker, :action => :create, :id => '#marker.id', 
                                                       :title => '#marker.title', :name => 'My Marker')
  end
  
end