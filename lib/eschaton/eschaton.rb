module Eschaton
  include Eschaton::Events
  
  def self.random_id
    "_#{rand(4000)}"
  end  
    
  def self.current_view=(view)
    @@current_view = view
  end

  def self.current_view
    @@current_view
  end

  def self.dependencies
    if defined?(ActiveSupport::Dependencies)
      ActiveSupport::Dependencies
    else
      Dependencies
    end
  end
  
  def self.logger
    Rails.logger
  end
  
  def self.log_info(message)
    self.logger.info("eschaton: #{message}")
  end  

  def self.try_and_require(file)
    begin
      self.require_file file
    rescue MissingSourceFile
    end
  end

  def self.require_file(file)
    self.dependencies.require file
  end

  def self.require_files(options)
    path = options[:in]
    pattern = "#{options[:in]}/*.rb"

    Eschaton.add_to_load_path path

    Dir[pattern].each do |file|
      self.require_file file
    end
  end

  def self.url_for_javascript(options)
    url = self.current_view.url_for(options)

    interpolate_symbol, brackets = '#', '()'
    url.scan(/#{interpolate_symbol.escape}[\-\d\w\.#{brackets.escape}]+/).each do |javascript_variable|
      interpolation = javascript_variable.gsub(interpolate_symbol.escape, '')
      interpolation.gsub!(brackets.escape, brackets)

      url.gsub!(javascript_variable, "' + #{interpolation} + '")
    end

    url.gsub!('&amp;', '&')

    "'#{url}'"
  end

  def self.script
    script = Eschaton::Script.new

    if block_given?
      yield script
    end

    script
  end
  
  # Finds Eschaton::DomElements with the given +options+.
  # Eschaton::DomElements can be found using the +id+, +css_class+ or a +selector+.
  #
  # As a convenience, if a symbol is supplied as +options+ it will be treated as the +id+ and
  # if a string is supplied it is treated as the +selector+.
  #
  # ==== Options:
  #
  # * +id+ - Optional. Finds elements by their id.
  # * +css_class+ - Optional. Finds elements by their css class.
  # * +selector+ - Optional. Finds elements using a jQuery selector.
  #
  # ==== Examples
  #
  #  feedback_element = Eschaton.element(:feedback) 
  #
  #  feedback_element = Eschaton.element(:id => :feedback)
  #
  #  anchors_in_divs = Eschaton.element('div > a')
  #
  #  anchors_in_divs = Eschaton.element(:selector => 'div > a')
  #
  #  selected_elements = Eschaton.element(:css_class => 'selected')
  def self.element(options)
    dom_elements = Eschaton::DomElements.new(options)

    yield dom_elements if block_given?

    dom_elements
  end
  
  def self.function(options = {}, &block)
    Eschaton::JavascriptFunction.from_block options, &block
  end

  def self.variable(name)
    Eschaton::JavascriptObject.existing(:variable => name)
  end
  
  def self.with_global_script(script = Eschaton.script, options = {})
    options.default! :reset_after => false

    previous_script = unless options[:reset_after]
                        self.global_script
                      end

    self.global_script = script

    yield script

    self.global_script = previous_script

    script
  end
  
  def self.script_from(&block)
    self.with_global_script &block
  end

  def self.global_script=(script)
    Thread.current[:eschaton_global_script] = script
  end

  def self.global_script
    global_script = Thread.current[:eschaton_global_script]

    yield global_script if block_given?

    global_script
  end

end