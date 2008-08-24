require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)
    
class MapTest < Test::Unit::TestCase
  
  def test_map_initialize
    map = Google::Map.new :script => Eschaton.javascript_generator        
      
    assert_output_fixture :map_default, map.send(:script)

    map = Google::Map.new :center => {:latitude => -35.0, :longitude => 19.0}, 
                          :script => Eschaton.javascript_generator        
      
    assert_output_fixture :map_with_center, map.send(:script)
    
    map = Google::Map.new :center => {:latitude => -35.0, :longitude => 19.0},
                          :controls => [:small_map, :map_type],
                          :zoom => 12,
                          :type => :satellite,
                          :script => Eschaton.javascript_generator

    assert_output_fixture :map_with_args, map.send(:script)
  end

  def test_add_control
    Eschaton.with_global_script do |script|
      script.google_map_script do
        map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}

        assert_output_fixture 'map.addControl(new GSmallMapControl());', 
                               script.record_for_test {
                                 map.add_control :small_map
                               }

        assert_output_fixture 'map.addControl(new GSmallMapControl(), new GControlPosition(G_ANCHOR_TOP_RIGHT, new GSize(0, 0)));', 
                              script.record_for_test {
                                map.add_control :small_map, :position => {:anchor => :top_right}
                              }

        assert_output_fixture 'map.addControl(new GSmallMapControl(), new GControlPosition(G_ANCHOR_TOP_RIGHT, new GSize(50, 10)));',
                              script.record_for_test {
                                map.add_control :small_map, :position => {:anchor => :top_right, :offset => [50, 10]}
                              }

        assert_output_fixture 'map.addControl(new GSmallMapControl());', 
                               script.record_for_test {
                                 map.controls = :small_map
                               }

        assert_output_fixture :map_controls, 
                               script.record_for_test {
                                 map.controls = :small_map, :map_type
                               }
      end
    end
  end

  def test_open_info_window_output
    Eschaton.with_global_script do |script|
      script.google_map_script do
        map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      
        # With :url and :include_location params
        assert_output_fixture :map_open_info_window_url_center, 
                              script.record_for_test {
                                map.open_info_window :url => {:controller => :location, :action => :create}
                              }

        assert_output_fixture :map_open_info_window_url_center,
                              script.record_for_test {
                                map.open_info_window :location => :center, 
                                                     :url => {:controller => :location, :action => :create}
                              }


        assert_output_fixture :map_open_info_window_url_existing_location,
                              script.record_for_test {
                                map.open_info_window :location => :existing_location, 
                                                     :url => {:controller => :location, :action => :create}
                              }

        assert_output_fixture :map_open_info_window_url_location,
                              script.record_for_test {
                                map.open_info_window :location => {:latitude => -33.947, :longitude => 18.462}, 
                                                     :url => {:controller => :location, :action => :create}
                              }

        assert_output_fixture :map_open_info_window_url_no_location,
                              script.record_for_test {
                                map.open_info_window :location => {:latitude => -33.947, :longitude => 18.462}, 
                                                     :url => {:controller => :location, :action => :show, :id => 1},
                                                     :include_location => false
                              }

        assert_output_fixture 'map.openInfoWindow(new GLatLng(-33.947, 18.462), "<div id=\'info_window_content\'>" + "test output for render" + "</div>");', 
                              script.record_for_test {
                                map.open_info_window :location => {:latitude => -33.947, :longitude => 18.462}, :partial => 'create'
                              }

        assert_output_fixture 'map.openInfoWindow(new GLatLng(-33.947, 18.462), "<div id=\'info_window_content\'>" + "Testing text!" + "</div>");',
                              script.record_for_test {
                                map.open_info_window :location => {:latitude => -33.947, :longitude => 18.462}, :text => "Testing text!"
                              }
      end
    end    
  end
  
  def test_update_info_window
    Eschaton.with_global_script do |script|
      script.google_map_script do      
        map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}    
      
        assert_output_fixture 'map.openInfoWindow(map.getInfoWindow().getPoint(), "<div id=\'info_window_content\'>" + "Testing text!" + "</div>");',
                               script.record_for_test {
                                 map.update_info_window :text => "Testing text!"
                               }
      end
    end
  end
  
  def test_click_output
    Eschaton.with_global_script do |script|
      script.google_map_script do
        map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462} 

        # without body
        assert_output_fixture :map_click_no_body,
                              script.record_for_test {
                                map.click {}
                              }
    
        # With body
        assert_output_fixture :map_click_with_body, 
                              script.record_for_test {
                                map.click do |script, location|
                                  script.comment "This is some test code!"
                                  script.comment "'#{location}' is where the map was clicked!"
                                  script.alert("Hello from map click!")
                                end
                              }

        # Info window convenience
        assert_output_fixture :map_click_info_window,
                              script.record_for_test {
                                map.click :text => "This is a info window!"
                              }
      end
    end    
  end
  
  def test_add_marker
    Eschaton.with_global_script do
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      
      first_marker_location = {:latitude => -33.947, :longitude => 18.462}
      marker = map.add_marker :location => first_marker_location
    
      assert marker.is_a?(Google::Marker)
      assert marker.location.is_a?(Google::Location)
      assert_equal first_marker_location[:latitude], marker.location.latitude
      assert_equal first_marker_location[:longitude], marker.location.longitude      
    end
    
    # Now add multiple markers
    Eschaton.with_global_script do
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      
      first_marker_location = {:latitude => -33.947, :longitude => 18.462}
      second_marker_location = {:latitude => -34.947, :longitude => 18.462}
      
      markers = map.add_markers({:location => first_marker_location}, {:location => second_marker_location})
      
      assert markers.is_a?(Array)
      assert_equal 2, markers.size
      
      first_marker = markers[0]
      
      assert first_marker.is_a?(Google::Marker)
      assert first_marker.location.is_a?(Google::Location)
      assert_equal first_marker_location[:latitude], first_marker.location.latitude
      assert_equal first_marker_location[:longitude], first_marker.location.longitude
      
      second_marker = markers[1]
      
      assert second_marker.is_a?(Google::Marker)
      assert second_marker.location.is_a?(Google::Location)
      assert_equal second_marker_location[:latitude], second_marker.location.latitude
      assert_equal second_marker_location[:longitude], second_marker.location.longitude
    end
  end  

  def test_add_marker_output
    Eschaton.with_global_script do |script|
      script.google_map_script do
        map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      
        assert_output_fixture :map_add_marker,
                              script.record_for_test {
                                map.add_marker :location => {:latitude => -33.947, :longitude => 18.462}
                              }

        assert_output_fixture :map_add_markers,
                              script.record_for_test {
                                map.add_markers({:location => {:latitude => -33.947, :longitude => 18.462}},
                                                {:location => {:latitude => -34.947, :longitude => 19.462}})
                              }
      end
    end
  end

  def test_replace_marker
     Eschaton.with_global_script do
       map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}

       first_marker_location = {:latitude => -33.947, :longitude => 18.462}
       marker = map.replace_marker :location => first_marker_location

       assert marker.is_a?(Google::Marker)
       assert marker.location.is_a?(Google::Location)
       assert_equal first_marker_location[:latitude], marker.location.latitude
       assert_equal first_marker_location[:longitude], marker.location.longitude      
     end
  end

  def test_replace_marker_output
    Eschaton.with_global_script do |script|
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}

      assert_output_fixture :map_replace_marker,
                            script.record_for_test {
                              map.replace_marker :location => {:latitude => -33.947, :longitude => 18.462}
                            }
    end
  end

  def test_add_line
    Eschaton.with_global_script do |script|
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      line = map.add_line :vertices => {:latitude => -33.947, :longitude => 18.462}
      
      assert line.is_a?(Google::Line)
    end
  end

  def test_add_line_output
    Eschaton.with_global_script do |script|
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      
      assert_output_fixture :map_add_line_with_vertex, 
                            script.record_for_test {
                              map.add_line :vertices => {:latitude => -33.947, :longitude => 18.462}
                            }
                            
      assert_output_fixture :map_add_line_with_vertices, 
                            script.record_for_test {
                              map.add_line :vertices => [{:latitude => -33.947, :longitude => 18.462},
                                                         {:latitude => -34.0, :longitude => 19.0}]
                            }

      assert_output_fixture :map_add_line_with_from_and_to, 
                            script.record_for_test {
                              map.add_line :from => {:latitude => -33.947, :longitude => 18.462},
                                           :to =>  {:latitude => -34.0, :longitude => 19.0}
                            }

      assert_output_fixture :map_add_line_with_colour,
                            script.record_for_test {
                              map.add_line :from => {:latitude => -33.947, :longitude => 18.462},
                                           :to =>  {:latitude => -34.0, :longitude => 19.0},
                                           :colour => 'red'
                            }

      assert_output_fixture :map_add_line_with_colour_and_thickness,
                            script.record_for_test {
                              map.add_line :from => {:latitude => -33.947, :longitude => 18.462},
                                           :to =>  {:latitude => -34.0, :longitude => 19.0},
                                           :colour => 'red', :thickness => 10
                            }

      assert_output_fixture :map_add_line_with_style,
                            script.record_for_test {
                              map.add_line :from => {:latitude => -33.947, :longitude => 18.462},
                                           :to =>  {:latitude => -34.0, :longitude => 19.0},
                                           :colour => 'red', :thickness => 10, :opacity => 0.7
                            }

      markers = [Google::Marker.new(:location => {:latitude => -33.947, :longitude => 18.462}),
                 Google::Marker.new(:location => {:latitude => -34.0, :longitude => 19.0}),
                 Google::Marker.new(:location => {:latitude => -35.0, :longitude => 19.0})]

      assert_output_fixture :map_add_line_between_markers,
                            script.record_for_test {
                              map.add_line :between_markers => markers
                            }

      assert_output_fixture :map_add_line_between_markers_with_style,
                            script.record_for_test {
                              map.add_line :between_markers => markers,
                                           :colour => 'red', :weigth => 10, :opacity => 0.7
                            }                            
    end
  end

  def test_clear_output
    Eschaton.with_global_script do |script|
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      
      assert_output_fixture 'map.clearOverlays();',
                            script.record_for_test {
                              map.clear
                            }
    end
  end

  def test_show_map_blowup_output
    Eschaton.with_global_script do |script|
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      
      # Default with hash location
      assert_output_fixture 'map.showMapBlowup(new GLatLng(-33.947, 18.462), {});', 
                            script.record_for_test {
                              map.show_blowup :location => {:latitude => -33.947, :longitude => 18.462}
                            }

     # Default with existing_location
     assert_output_fixture 'map.showMapBlowup(existing_location, {});', 
                   script.record_for_test {
                     map.show_blowup :location => :existing_location
                   }
      
      # With :zoom_level
      assert_output_fixture 'map.showMapBlowup(new GLatLng(-33.947, 18.462), {zoomLevel: 12});', 
                            script.record_for_test {
                              map.show_blowup :location => {:latitude => -33.947, :longitude => 18.462},
                                              :zoom_level => 12
                            }

      # With :map_type
      assert_output_fixture 'map.showMapBlowup(new GLatLng(-33.947, 18.462), {mapType: G_SATELLITE_MAP});', 
                            script.record_for_test {
                              map.show_blowup :location => {:latitude => -33.947, :longitude => 18.462},
                                              :map_type => :satellite
                            }

      # With :zoom_level and :map_type
      assert_output_fixture 'map.showMapBlowup(new GLatLng(-33.947, 18.462), {mapType: G_SATELLITE_MAP, zoomLevel: 12});', 
                            script.record_for_test {
                              map.show_blowup :location => {:latitude => -33.947, :longitude => 18.462},
                                              :zoom_level => 12,
                                              :map_type => :satellite
                            }
    end
  end

  def test_remove_type
    Eschaton.with_global_script do |script|
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      
      assert_output_fixture 'map.removeMapType(G_SATELLITE_MAP);', 
                            script.record_for_test {
                              map.remove_type :satellite
                            }

      assert_output_fixture :map_remove_type,
                            script.record_for_test {
                              map.remove_type :normal, :satellite
                            }
   end
  end
  
  def test_best_fit_center
    Eschaton.with_global_script do |script|
      script.google_map_script do
        map = Google::Map.new :center => :best_fit

        map.add_marker :location => {:latitude => -33.0, :longitude => 18.0}
        map.add_marker :location => {:latitude => -33.5, :longitude => 18.5}      
      end
      
      assert_output_fixture :map_best_fit_center, script      
    end
  end

  def test_best_fit_center_and_zoom
    Eschaton.with_global_script do |script|
      script.google_map_script do
        map = Google::Map.new :center => :best_fit, :zoom => :best_fit

        map.add_marker :location => {:latitude => -33.0, :longitude => 18.0}
        map.add_marker :location => {:latitude => -33.5, :longitude => 18.5}
      end

      assert_output_fixture :map_best_fit_center_and_zoom, script
    end
  end

end
