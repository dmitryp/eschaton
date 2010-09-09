module Eschaton
  
  def self.add_to_load_path(path)
    Eschaton.dependencies.autoload_paths << path
  end

end