class Symbol
  
  def without_the_question_mark
    self.to_s.without_the_question_mark.to_sym
  end
  
end