require File.dirname(__FILE__) + '/test_helper'

class ScriptTest < Test::Unit::TestCase

  def test_adding_javascript    
    assert_eschaton_output 'Line One
                            Line Two' do |script|
                              script << 'Line One'
                              script << 'Line Two'
                            end
  end
  
  def test_raw_javascript
    assert_eschaton_output 'Line One
                            Line Two' do |script|
                              script.raw_javascript 'Line One
                                                     Line Two'
                            end
  end
  
  def test_record
    script = Eschaton.script

    script << 'This is before recording'

    record = script.record do
               script << 'This is within recording'
               script << 'Still within recording'
             end

    script << 'This is after recording'

    assert_eschaton_output 'This is before recording
                            This is within recording
                            Still within recording
                            This is after recording',
                            script

    assert_eschaton_output 'This is within recording
                            Still within recording', 
                            record
  end

  def test_output_methods
    script = Eschaton.script

    script << 'Line One'
    script << 'Line Two'

    output = 'Line One
              Line Two'

    assert_eschaton_output output, script.to_s
    assert_eschaton_output output, script.inspect
  end

end