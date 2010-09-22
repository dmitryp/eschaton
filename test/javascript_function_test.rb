require File.dirname(__FILE__) + '/test_helper'

class JavascriptFunctionTest < Test::Unit::TestCase
      
  def test_function
    with_eschaton do |script|
      function = script.function do |function|
                   function.alert("hello world!")
                 end

      assert_true function.anonymous?

      assert_eschaton_output 'function(){
                                alert("hello world!");
                              }', 
                             function
    end
  end

  def test_function_with_name
    with_eschaton do |script|                 
      assert_eschaton_output 'function helloWorld(){
                                alert("hello world!");
                              }' do |script|
                              function = script.function(:name => :hello_world) do |function|
                                           function.alert("hello world!")
                                         end

                              assert_false function.anonymous?
                            end
    end
  end

  def test_call
    with_eschaton do |script|                 
      function = script.function do |function|
                   function.alert("hello world!")
                 end

      assert_eschaton_output '(function(){
                                alert("hello world!");
                              }).call();' do |script|
                              function.call!                                        
                            end
    end    
  end
  
  def test_call_on_named_function
    with_eschaton do |script|                 
      function = script.function(:name => :hello_world) do |function|
                   function.alert("hello world!")
                 end      

      assert_eschaton_output 'helloWorld();' do |script|
                              function.call!                                        
                            end
    end    
  end
 
end
