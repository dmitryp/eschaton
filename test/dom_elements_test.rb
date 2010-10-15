require File.dirname(__FILE__) + '/test_helper'

class DomElementsTest < Test::Unit::TestCase

  def setup
    @element = Eschaton.element(:feedback)
  end

  def test_calls
    with_eschaton do
      assert_eschaton_output :dom_element_calls do |script|
        script.element(:id => :one).click do |function_script|
          function_script << "// Testing"
          function_script.element(:id => :one).show!
          function_script.element(:id => :two).replace_html "This is two"
        end
      end
    end
  end

  def test_selectors
    with_eschaton do |script|
      assert_eschaton_output "jQuery('#map_sidebar')", script.element(:id => 'map_sidebar').variable
      assert_eschaton_output "jQuery('.map_sidebar')", script.element(:css_class => 'map_sidebar').variable
      assert_eschaton_output "jQuery('div > a')", script.element(:selector => 'div > a').variable      
      
      assert_eschaton_output "jQuery('#map_sidebar')", script.element(:map_sidebar).variable
      assert_eschaton_output "jQuery('div > a')", script.element('div > a').variable
    end    
  end
  
  def test_update_html
    with_eschaton do |script|
      assert_eschaton_output :dom_element_update_html do
                               @element.update_html 'Hello element ...'
                             end

      assert_eschaton_output :dom_element_update_html_with_interpolated_javascript do
                              @element.update_html "Latitude is #[location.lat()] | Logitude is #[location.lng()] "
                             end                            
    end 
  end
  
  def test_delete!
    with_eschaton do |script|
      assert_eschaton_output "jQuery('#feedback').remove();" do
                               @element.delete!
                             end
    end
  end

  def test_click
    with_eschaton do |script|
      assert_eschaton_output :dom_element_click do
                              @element.click do |script|
                                script.alert('You clicked the Feedback element')
                              end
                            end
    end    
  end
  
  def test_listen_to
    with_eschaton do |script|  
      assert_eschaton_output :dom_element_listen_to_focus do
                              @element.listen_to :event => :focus do |script|
                                script.alert('You are focussed')  
                              end
                            end      
      
      assert_eschaton_output :dom_element_listen_to_mouse_leave do
                              @element.listen_to :event => :mouse_leave do |script|
                                script.alert('Your mouse left')  
                              end
                            end
    end
  end
  
  def test_setting_value
    with_eschaton do |script|
      assert_eschaton_output "jQuery('#feedback').val(\"Hello world\");" do
                                @element.value = 'Hello world'
                              end

      assert_eschaton_output "jQuery('#marker_count').val(12);" do
                                script.element(:marker_count).value = 12
                              end
    end
  end

  def test_value
    with_eschaton do |script|
      assert_eschaton_output "jQuery('#feedback').val()",
                              @element.value
      
    end
  end

  def test_attribute
    with_eschaton do |script|
      assert_eschaton_output "jQuery('#feedback').attr(\"name\")",
                              @element.attribute(:name)
      
    end
  end

  def test_set_attributes
    with_eschaton do |script|
      assert_eschaton_output 'jQuery(\'#feedback\').attr({"class": "location_button", "style": "border: solid 1px #DDD"})' do
                                @element.set_attributes(:class => :location_button, :style => 'border: solid 1px #DDD')
                              end
      
    end
  end
  
  def test_set_styles
    with_eschaton do |script|
      assert_eschaton_output 'jQuery(\'#feedback\').css({"background-color": "green", "border": "solid 1px black"})' do
                                @element.set_styles 'background-color' => 'green', :border => 'solid 1px black'
                              end
      
    end
  end
  
end