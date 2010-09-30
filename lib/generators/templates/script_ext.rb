module <%= slice_class %>ScriptExt

  def map
    @map ||= Google::Map.existing(:variable => 'map')
  end

end