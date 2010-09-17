module JavascriptGeneratorExt
  
  def alert(message)
    self << "alert(\"#{message}\");"
  end

  def function(options = {}, &block)
    Eschaton::JavascriptFunction.from_block options, &block
  end

end