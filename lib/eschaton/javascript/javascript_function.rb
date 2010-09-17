module Eschaton

  class JavascriptFunction < JavascriptObject

    def self.from_block(&block)
      script = Eschaton.script

      script << "function(){"
      yield script
      script << "}"

      Eschaton::JavascriptFunction.new(:script => script)
    end

    def to_s
      self.script.to_s
    end

  end

end