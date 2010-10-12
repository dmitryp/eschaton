module GoogleViewExt
    
  # Creates an ajax form that will post to the given +url+. When the form is posted the location of the info window is included and
  # is accessable using <b><i>params[:location]</b></i> in your action.
  #
  # ==== Options:
  #
  # * +url+ - Required. The url the form will post to.
  # * +form_attributes+ - Optional. Any addtional attributes of the form.
  #
  # ==== Examples:
  #
  #  <%= info_window_form :url => {:controller => :location, :action => :add} do
  #    ...
  #    <%= label_tag :location_name %>
  #    <%= text_field_tag :location_name %>
  #    ...
  #  <% end %>
  #
  #  <%= info_window_form :url => {:controller => :location, :action => :add}, :form_attributes => {:class => :location_form} do ...
  def info_window_form(options, &block)
    prepare_info_window_options(options)

    form_tag options[:url], options[:form_attributes], &block
  end
  
  # Creates an ajax form for the given +model+. When the form is posted the location of the info window is included and
  # is accessable using <b><i>params[:location]</b></i> in your action.
  #
  # ==== Options:
  #
  # * +model+ - Required. The model that the form will use, can be an instance variable, string or symbol.
  # * +url+ - Optional. The url the form will post to.
  # * +form_attributes+ - Optional. Any addtional attributes of the form.
  #
  # ==== Examples:
  #
  #  <%= info_window_form_for :model => @location do |form|
  #    <%= form.label :name %>
  #    <%= form.text_field :name %>
  #  <% end %>
  #
  #  <%= info_window_form_for :model => @location, :form_attributes => {:class => :location_form} do |form| ...
  def info_window_form_for(options, &block)        
    prepare_info_window_options(options)

    model = options.extract(:model)

    options[:html] = options.extract(:form_attributes)

    form_for model, options, &block
  end  
  
  protected
    def prepare_info_window_options(options) #:nodoc:
      options.default! :form_attributes => {}

      options[:form_attributes].default! :class => :info_window_form
      options[:form_attributes][:remote] = true

      if params[:location].not_blank?
        options[:url][:location] = params[:location]
      end
    end  
  
end