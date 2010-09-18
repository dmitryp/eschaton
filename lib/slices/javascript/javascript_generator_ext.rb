module JavascriptGeneratorExt
  
  def alert(message)
    self << "alert(\"#{message}\");"
  end

  def function(options = {}, &block)
    Eschaton::JavascriptFunction.from_block options, &block
  end

  def variable(name)
    Eschaton::JavascriptObject.existing(:var => name)
  end

end