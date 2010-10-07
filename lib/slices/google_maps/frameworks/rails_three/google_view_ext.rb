module GoogleViewExt
    
  # Works in exactly the same way as rails +form_remote_tag+ but provides some extra options. This would be used 
  # to create a remote form tag within an info window.
  #
  # ==== Options:
  #
  # * +include_location+ - Optional. Indicates if latitude and longitude +params+(if present) should be include in the +url+, defaulted to +true+.
  def info_window_form(options, &block) #TODO rename => info_window_form_tag
    prepare_info_window_options(options)
    
    #form_remote_tag options, &block
    raise 'Not Implemented for Rails 3 yet'
  end

  def info_window_form_for(model, model_instance, options, &block)
    prepare_info_window_options(options)
    
    #remote_form_for model, model_instance, options, &block
    raise 'Not Implemented for Rails 3 yet'
  end
  
end