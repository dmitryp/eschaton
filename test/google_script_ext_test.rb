require File.dirname(__FILE__) + '/test_helper'
    
class GoogleScriptExtTest < Test::Unit::TestCase

  def test_global_map_var    
    with_eschaton do
      assert_eschaton_output "var map;
                             jQuery(document).ready(function() {
                             window.onunload = GUnload;
                             if (GBrowserIsCompatible()) {
                             track_bounds = new GLatLngBounds();                               
                             map_lines = new Array();
                             map = new GMap2(document.getElementById('map'));
                             map.setCenter(cape_town);
                             map.setZoom(9);
                             last_mouse_location = map.getCenter();
                             function map_mousemove(map){
                             return GEvent.addListener(map, \"mousemove\", function(location) {
                             last_mouse_location = location;
                             });
                             }
                             map_mousemove_event = map_mousemove(map);
                             map.addControl(new GLargeMapControl3D());
                             map.addControl(new GMapTypeControl());                             
                             } else { alert('Your browser be old, it cannot run google maps!');}
                             })" do |script|
                             script.google_map_script do
                               map = Google::Map.new :center => :cape_town, :zoom => 9
                             end                     
      end
    end
  end
  
  def test_mapping_scripts
    with_eschaton do
      assert_eschaton_output "/* Before 1 */
                             /* Before 2 */
                             jQuery(document).ready(function() {
                             window.onunload = GUnload;
                             if (GBrowserIsCompatible()) {
                             /* Map script */
                             } else { alert('Your browser be old, it cannot run google maps!');}
                             })
                             /* After 1 */
                             /* After 2 */" do |script|
                             script.google_map_script do |script|
                               Google::Scripts.before_map_script do |before_script|
                                 before_script.comment "Before 1"
                                 before_script.comment "Before 2"
                               end

                               Google::Scripts.after_map_script do |after_script|
                                 after_script.comment "After 1"
                                 after_script.comment "After 2"
                               end

                               script.comment "Map script"
                             end
      end
    end
  end  
  
  
  def test_google_map_script
    with_eschaton do |script|
      
      assert_eschaton_output :google_map_script_no_body do
                              script.google_map_script {}
                            end

      assert_eschaton_output :google_map_script_with_body do
                              script.google_map_script do
                                script.comment "This is some test code!"
                                script.alert("Hello!")
                              end
                            end
    end
  end
  
  def test_set_coordinate_elements
    with_eschaton do |script|
      
      assert_eschaton_output "jQuery('#latitude').val(location.lat());
                              jQuery('#longitude').val(location.lng());" do
                              script.set_coordinate_elements :location => :location
                            end
      
      map = Google::Map.new :center => {:latitude => -35.0, :longitude => 19.0}
      
      # Testing with map center
      assert_eschaton_output "jQuery('#latitude').val(map.getCenter().lat());
                              jQuery('#longitude').val(map.getCenter().lng());" do
                              script.set_coordinate_elements :location => map.center
                            end

      marker = map.add_marker(:variable => :marker, :location => map.center)
      
      # Testing with a marker location
      assert_eschaton_output "jQuery('#latitude').val(marker.getLatLng().lat());
                              jQuery('#longitude').val(marker.getLatLng().lng());" do
                              script.set_coordinate_elements :location => marker.location
                            end

      # With specific element names
      assert_eschaton_output "jQuery('#location_latitude').val(location.lat());
                              jQuery('#location_longitude').val(location.lng());" do
                              script.set_coordinate_elements :location => :location,
                                                             :latitude_element => :location_latitude,
                                                             :longitude_element => :location_longitude
                            end
    end    

  end

end
