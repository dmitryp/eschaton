require File.dirname(__FILE__) + '/test_helper'

class DomElementTest < Test::Unit::TestCase

  def setup
    @element = Eschaton::DomElement.new(:id => :feedback)
  end

  def test_calls
    with_eschaton do
      assert_eschaton_output :dom_element_calls do |script|
        script.element(:id => :one).when_clicked do |function_script|
          function_script << "// Testing"
          function_script.element(:id => :one).show!
          function_script.element(:id => :two).replace_html "This is two"
        end
      end
    end
  end

  def test_selector
    with_eschaton do |script|
      assert_eschaton_output "jQuery('#map_sidebar')", script.element(:id => 'map_sidebar').element
      assert_eschaton_output "jQuery('.map_sidebar')", script.element(:css_class => 'map_sidebar').element
      assert_eschaton_output "jQuery('div > a')", script.element(:selector => 'div > a').element
    end    
  end
  
  def test_replace_html
    with_eschaton do |script|
      assert_eschaton_output :dom_element_replace_html do
                               @element.replace_html 'Hello element ...'
                             end

      assert_eschaton_output :dom_element_replace_html_with_interpolated_javascript do
                              @element.replace_html "Latitude is #[location.lat()] | Logitude is #[location.lng()] "
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

  def test_when_clicked
    with_eschaton do |script|
      assert_eschaton_output :dom_element_when_clicked do
                              @element.when_clicked do |script|
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

end