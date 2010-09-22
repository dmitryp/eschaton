require File.dirname(__FILE__) + '/test_helper'

class KernelGeneratorTest < Test::Unit::TestCase
  
  def test_if_statement
    with_eschaton do |script|
      assert_eschaton_output :if_statement do
                              script.if("x == 1"){
                                script.alert("x is 1!")
                              }
                            end


      assert_eschaton_output :if_statement_using_local_var do
                              script.if("local_var"){
                                script.alert("there was a local var")
                              }
                            end
    end
  end
  
  def test_if_statement
    with_eschaton do |script|
      assert_eschaton_output :unless_statement do
                              script.unless("x == 1"){
                                script.alert("x is not 1!")
                              }
                            end

      assert_eschaton_output :unless_statement_using_local_var do
                              script.unless("local_var"){
                                script.alert("there was a local var")
                              }
                            end
    end  
  end
  
end