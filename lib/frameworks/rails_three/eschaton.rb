Eschaton::Extensions.extend_eschaton do

  def self.add_to_load_path(path)
    Eschaton.dependencies.autoload_paths << path
  end

end