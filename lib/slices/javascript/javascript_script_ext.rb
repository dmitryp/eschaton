module JavascriptScriptExt
  
  # Pops up an alert message box
  #
  # ==== Example:
  #  
  #   script.alert "Hello world!"
  def alert(message)
    self << "alert(\"#{message}\");"
  end
  
  # Pops up a confimation message box. Any code generated within the block will be run if the user confirms.
  #
  # ==== Example:
  #
  #  script.confirm("Are you sure you want to?") do |script|
  #    script.alert('You have confirmed')
  #  end
  def confirm(message, &block)
    self.if "confirm(\"#{message}\")", &block
  end
  
  # Evaluates the +script+ as javascript in the browser.
  #
  # ==== Example
  #
  # 
  # script.eval "1 == 1"
  def eval(script)
    self << "eval(#{script.to_js});"
  end

  # Writes out a javascript comment with the given +message+.
  #
  # ==== Examples:
  #
  #  comment 'this code is awesome!' #=> '/* this code is awesome! */'
  def comment(message)
    self << "/* #{message} */"
  end
  
  # Writes out a javascript "if" statement using the given +condition+. Any code generated within the block will be placed
  # inside the "if" statement.
  #
  #  ==== Examples:
  #
  #  script.if("x == 1") do
  #    script.alert("x is 1!")
  #  end
  def if(condition)
    self << "if(#{condition}){"
    
    yield self
    
    self << "}"
  end

  # Writes out a javascript "unless" statement using the given +condition+. Any code generated within the block will be placed
  # inside the "unless" statement.
  #
  #  ==== Examples:
  #
  #  script.unless("x == 1") do
  #    script.alert("x is not 1!")
  #  end
  def unless(condition)
    self << "if(!(#{condition})){"
    
    yield self

    self << "}"
  end  
  
  # Returns a JavascriptFunction with the given +options+ which can be anything Eschaton::JavascriptFunction#from_block supports.  
  def function(options = {}, &block)
    Eschaton::JavascriptFunction.from_block options, &block
  end

  def variable(name)
    Eschaton::JavascriptObject.existing(:var => name)
  end

end