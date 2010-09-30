require File.dirname(__FILE__) + '/test_helper'

class LocationTest < Test::Unit::TestCase
  
  def test_new_location
    with_eschaton do |script|
      latitude, longitude = -34.947, 19.462 
      location = Google::Location.new(:latitude => latitude, :longitude => longitude)

      assert_equal latitude, location.latitude
      assert_equal longitude, location.longitude
      assert_eschaton_output "new GLatLng(-34.947, 19.462)", location.to_s
    end
  end

  def test_existing_location
    with_eschaton do |script|
      location = Google::Location.existing(:variable => :map_center)

      assert_eschaton_output 'map_center', location.to_js
      assert_eschaton_output 'map_center.lat()', location.latitude
      assert_eschaton_output 'map_center.lng()', location.longitude

      location = Google::Location.existing(:variable => 'marker.getLatLng()')
  
      assert_eschaton_output 'marker.getLatLng()', location.to_js
      assert_eschaton_output 'marker.getLatLng().lat()', location.latitude
      assert_eschaton_output 'marker.getLatLng().lng()', location.longitude
    end
  end

end