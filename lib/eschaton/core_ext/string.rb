class String # :nodoc:

  def quote
    "\"#{self}\""
  end

  def strip_each_line!
    self.gsub!(/^\s+|\s+$/, '')
  end
  
  def interpolated_javascript
    "#[#{self}]"
  end

  # Escapes +self+ and returns the escaped string.
  def escape
    CGI.escape self
  end
 
  def ends_with?(word)
    (self =~ /#{word}$/).not_nil?
  end
   
  def without_question_mark_or_exclamation_mark
    if self =~ /\?|\!$/
      self.chop
    else
      self
    end
  end

  alias without_last_character chop

end