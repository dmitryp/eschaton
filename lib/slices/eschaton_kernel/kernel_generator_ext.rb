module KernelGeneratorExt

  # Evaluates the +script+ as javascript on the client.
  def eval(script)
    self << "eval(#{script.to_js});"
  end

  # Writes out a comment with the given +message+.
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

end