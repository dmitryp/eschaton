# Load up the entire host rails enviroment
require File.dirname(__FILE__) + '/../../../../config/environment'

Eschaton::Frameworks.detect_and_require_files_for_tests!

class Test::Unit::TestCase
  cattr_accessor :output_fixture_base
  
  def with_eschaton(&block)
    Eschaton.with_global_script(&block)
  end
  
  def assert_returned_javascript(return_value, javascript_call)
    assert_equal return_value.to_sym, javascript_call
  end
  
  def output_fixture_for_framework(output_to_compare)
    if output_to_compare.is_a?(Symbol)
      fixture_base = File.dirname(__FILE__)

      framework_specific_fixture_file = "#{fixture_base}/output_fixtures/#{Eschaton::Frameworks.framework_name}/#{output_to_compare}"

      fixture_file = if File.exists?(framework_specific_fixture_file)
                       framework_specific_fixture_file
                     else
                       "#{fixture_base}/output_fixtures/all_frameworks/#{output_to_compare}"
                    end

      File.read(fixture_file)
    else
      output_to_compare
    end    
  end
  
  def assert_eschaton_output(output_to_compare, generator = nil, message = nil, &block)  
    output_to_compare = output_fixture_for_framework(output_to_compare)

    output = if block_given?
               script = Eschaton.global_script || Eschaton.script

               script.record(&block).to_s
             else
               generator.to_s
             end

    output.strip_each_line!             
    output_to_compare.strip_each_line!
    
    if output_to_compare != output
      left_file = Tempfile.open "left_output"
      left_file << output_to_compare
      left_file.flush

      right_file = Tempfile.open "right_output"
      right_file << output
      right_file.flush

      diff = `diff -u #{left_file.path} #{right_file.path}`
      
      left_file.delete && right_file.delete
        
      flunk "Output difference, please review the below diff.\n\n#{diff}"
    else
      assert true
    end
  end

  def assert_empty(array, message = nil)
    assert array.empty?, message
  end

  def assert_not_empty(array, message = nil)
    assert array.not_empty?, message
  end  

  def assert_blank(value, message = nil)
    assert value.blank?, message
  end

  def assert_not_blank(value, message = nil)
    assert value.not_blank?, message
  end    

  def assert_error(message, exception_class = RuntimeError, &block)
    exception = assert_raise exception_class, &block
    assert_equal(message, exception.message) unless exception.nil? || message.blank?
  end

  def get_exception
    begin                    
      yield
    rescue => exception
    end

    exception
  end

  def assert_false(value)
    assert_equal false, value, "Expected '#{value}' to be false"
  end

  def assert_true(value)
    assert_equal true, value, "Expected '#{value}' to be true"
  end
  
  def assert_is_a(type_of_class, object)
    assert_true object.is_a?(type_of_class)
  end

end

Eschaton.current_view = EschatonMockView.new
