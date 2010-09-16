module KernelViewExt
  
  # Collects each argument and outputs the results
  #   collect stylesheet_link_tag('map_frame', :media => :all),
  #           javascript_include_tag('jquery'),
  #           some_other_stuff
  def collect(*args)
    args.compact.join("\n")
  end
  
  def javascript(&block)
    update_page do |script|
      Eschaton.with_global_script script, &block
    end
  end
  
  def in_script_tag(options = {}, &block)
    options = options.prepare_options(:defaults => {:when_document_ready => false}) 

    Eschaton.with_global_script do |script|
      script << '<script type="text/javascript">'
      
      if options.when_document_ready?
        script.when_document_ready(&block)
      else  
        script << Eschaton.script_from(&block)
      end

      script << '</script>'
    end
  end

  alias run_javascript in_script_tag

end