require File.dirname(__FILE__) + '/test_helper'

class DomElementTest < Test::Unit::TestCase

  def setup
    @element = Eschaton::DomElement.new(:id => :feedback)
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