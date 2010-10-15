require File.dirname(__FILE__) + '/test_helper'

class JavascriptFunctionTest < Test::Unit::TestCase
      
  def test_function
    with_eschaton do |script|
      function = javascript.function do |function|
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
                              function = javascript.function(:name => :hello_world) do |function|
                                           function.alert("hello world!")
                                         end

                              assert_false function.anonymous?
                            end
    end
  end

  def test_call
    with_eschaton do |script|                 
      function = javascript.function do |function|
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
      function = javascript.function(:name => :hello_world) do |function|
                   function.alert("hello world!")
                 end      

      assert_eschaton_output 'helloWorld();' do |script|
                              function.call!                                        
                            end
    end
  end
  
  def test_named_function_script_added_after_function_is_returned_is_added_to_the_body_of_the_function
    with_eschaton do |script|
      
      assert_eschaton_output 'function helloWorld(){
                                alert("hello world!");
                                hello
                                good bye
                                /* This is a comment */
                              }' do |script|
                                   named_function = javascript.function(:name => :hello_world) do |function|
                                                      function.alert("hello world!")
                                                    end

                                   named_function << "hello"
                                   named_function << "good bye"
                                   named_function.comment "This is a comment"
                              end
    end
  end
  
      
  def test_anonymous_function_script_added_after_function_is_returned_is_added_to_the_body_of_the_function
    with_eschaton do |script|
      anonymous_function = javascript.function do |function|
                             function.alert("hello world!")
                           end

      anonymous_function << "hello"
      anonymous_function << "good bye"
      anonymous_function.comment "This is a comment"
      
      assert_eschaton_output 'function(){
                                alert("hello world!");
                                hello
                                good bye
                                /* This is a comment */
                              }', anonymous_function
    end
  end
  
end
