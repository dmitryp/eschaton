module JavascriptGeneratorExt
  
  def alert(message)
    self << "alert(\"#{message}\");"
  end
  
end