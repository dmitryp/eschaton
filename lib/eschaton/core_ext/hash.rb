class Hash # :nodoc:
  alias extract delete

  alias has_option? has_key?

  # Defaults key values in a hash that are not present. Works like #merge but does not overwrite
  # existing keys. This is useful when using options arguments.
  def default!(defaults = {})
    replace(defaults.merge(self))
  end

  # Prepares a Hash as MethodOptions. See MethodOptions for details
  def prepare_options(options = {})
    merged_options = self.merge(options)

    method_options = Eschaton::PreparedOptions.new(merged_options)
  
    yield method_options if block_given?

    method_options
  end

  def sorted
    string_keys = self.stringify_keys
    string_keys.keys.sort.each do |key|
      yield key, string_keys[key]
    end
  end

  def to_css_styles
    css_styles = {}

    self.each do |style, value|
      css_styles[style.to_css_style] = value
    end

    css_styles.to_js  
  end

end
