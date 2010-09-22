module Eschaton
  
  module ScriptStore # :nodoc:

    def define(*names)
      names.each do |name|
        self.send(:cattr_writer, name)
      
        thread_key = self.thread_key(name)
        class_eval "
          def self.#{name}
            script = Thread.current['#{thread_key}'] ||= Eschaton::Script.new
            
            if block_given?
              Eschaton.with_global_script(script) do
                yield script
              end
            end

            script
          end
        "
      end
    end

    def clear(*names)
      names.each do |name|
        thread_key = self.thread_key(name)

        Thread.current[thread_key] = nil
      end
    end

    def extract(name)
      existing_value = self.send(name)
      self.clear name

      existing_value
    end
  
    protected
      def thread_key(name)
        "eschaton_#{self.to_s.downcase}_#{name}"
      end

  end

end