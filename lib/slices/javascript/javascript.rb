Eschaton::Extensions.make_globally_available do

  def javascript
    Eschaton::Javascript
  end

end


module Eschaton
  
  class Javascript
 
     def self.function(options = {}, &block)
       Eschaton::JavascriptFunction.from_block options, &block
     end

     def self.object(name)
       Eschaton::JavascriptObject.existing :variable => name
     end
     
     # Evaluates the +script+ as javascript in the browser.
     #
     # ==== Example
     #
     # script.eval "1 == 1"
     #
     # script.eval "alert('this was evaluated)"
     def self.evaluate(script)
       self << "eval(#{script.to_js});"
     end    
     
  end
  
end