class Symbol
  
  def without_question_mark_or_exclamation_mark
    self.to_s.without_question_mark_or_exclamation_mark.to_sym
  end
  
end