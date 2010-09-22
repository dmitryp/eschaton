module <%= slice_class %>ScriptExt

  def map
    @map ||= Google::Map.existing(:var => 'map')
  end

end