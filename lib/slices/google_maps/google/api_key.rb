module Google
  
  # By default the 'config/eschaton_google_api_keys.yml' file is used to store key values.
  #
  # In the above file you can use keys for your environments(development, test and production) or you can specify 
  # keys for specific domain names(e.g. www.mydomain.org, testing.localhost). If a key is supplied for the domain that 
  # corresponds to your current domain it will honored over environment keys.
  class ApiKey
    cattr_accessor :key    

    def self.get(options = {})
      unless self.key
        config_file = options[:config_file] || "#{Rails.root}/config/eschaton_google_api_keys.yml"
        domain_name = options[:domain]

        self.key = if File.exists?(config_file)
                    api_keys = YAML.load_file(config_file)

                    api_keys[domain_name] || api_keys[Rails.env]
                  else
                    'ABQIAAAActtI8WkgLZcM_n8uvnIYsBTJQa0g3IQ9GZqIMmInSLzwtGDKaBT9A95dZjICm7SeC_GoxpzGlyCdQA'
                  end

        Eschaton.log_info "Using google api => #{self.key}"                  
      end
      
      self.key
    end

    def self.reset! # :nodoc:
      self.key = nil
    end

  end

end