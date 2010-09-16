require File.dirname(__FILE__) + '/test_helper'

class MapObjectTest < Test::Unit::TestCase

  def setup
    @script = Eschaton.script
    Eschaton.global_script = @script

    @map_object = Google::MapObject.new(:var => 'test_object')
  end
  
  def test_listen_to_with
    # With no parameters in :with
    @map_object.listen_to :event => :dragging do |*parameters|
      assert_equal 1, parameters.length
      assert_is_a Eschaton::Script, parameters.first
    end

    # With a single parameter 
    @map_object.listen_to :event => :drag_end, :with => [:end_location] do |*parameters|
      assert_equal 2, parameters.length
      assert_is_a Eschaton::Script, parameters.first
      assert_equal :end_location, parameters.second
    end

    # With multiple parameters
    @map_object.listen_to :event => :drag_end, :with => [:start_location, :end_location] do |*parameters|
      assert_equal 3, parameters.length
      assert_is_a Eschaton::Script, parameters.first
      assert_equal :start_location, parameters.second
      assert_equal :end_location, parameters.third
    end
  end

  def test_listen_to_with_yield_order
    @map_object.listen_to :event => :click, :with => [:overlay, :location],
                               :yield_order => [:location, :overlay] do |*parameters|
      assert_equal 3, parameters.length
      assert_is_a Eschaton::Script, parameters.first
      assert_equal :location, parameters.second
      assert_equal :overlay, parameters.third
    end
  end
  
  def test_map_object_listen_to_no_parameters
    @map_object.listen_to :event => :click do
    end

    assert_eschaton_output :map_object_listen_to_no_parameters, @script
  end

  def test_map_object_listen_to_with_parameters
    @map_object.listen_to :event => :click, :with => [:overlay, :location] do
    end

    assert_eschaton_output :map_object_listen_to_with_parameters, @script
  end

  def test_map_object_listen_to_with_body
    @map_object.listen_to :event => :click, :with => [:location] do |script, location|
      script.comment "This is some test code!"
      script << "var current_location = #{location};"
      script.alert("Hello from test Object!")
    end
    
    assert_eschaton_output :map_object_listen_to_with_body, @script
  end

end
