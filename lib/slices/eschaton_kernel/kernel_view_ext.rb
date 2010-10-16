module KernelViewExt
  
  # Collects each argument and outputs the results
  #   collect stylesheet_link_tag('map_frame', :media => :all),
  #           javascript_include_tag('jquery'),
  #           some_other_stuff
  def collect(*args)
    args.compact.join("\n").html_safe
  end
    
  def javascript(&block)
    Eschaton.with_global_script(&block).to_s.html_safe
  end

  # Runs javascript by creating a script tag that will execute any script generated in the given +block+.
  # 
  # ==== Options:
  #
  # * +when_document_ready+ - Optional. Indicates if the javascript should run when the document is ready, defaulted to +true+.
  def run_javascript(options = {}, &block)
    options = options.prepare_options(:defaults => {:when_document_ready => true}) 

    Eschaton.with_global_script do |script|
      script << '<script type="text/javascript">'

      if options.when_document_ready?
        jQuery.document_ready(&block)
      else  
        script << Eschaton.script_from(&block)
      end

      script << '</script>'
    end
  end
  
  # Creates a hyper link that will execute the script generated from the given +block+.
  # 
  # ==== Options:
  #
  # * +text+ - Required. The text of the hyper link.
  #  
  # ==== Examples
  #
  #  link_to_eschaton_script :text => 'Close Info Window' do |script|
  #    script.map.close_info_window
  #  end
  #
  #  link_to_eschaton_script :text => 'Make it green' do |script|
  #    script.alert('Making the feedback div green')
  #    jQuery(:feedback).set_attribute :style => 'background-color: green'
  #  end
  def link_to_eschaton_script(options, &block)
    text = options[:text]
    element_id = Eschaton.random_id

    link_tag = "<a id='#{element_id}' href='#'>#{text}</a>"
    
    link_script = run_javascript do |script|
                    jQuery(:id => element_id).when_clicked(&block)
                  end

    collect link_tag, link_script
  end

end