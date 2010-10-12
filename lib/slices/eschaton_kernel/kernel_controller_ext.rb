module KernelControllerExt

  def run_javascript(&block)
    render :text => Eschaton.with_global_script(&block), :content_type => 'text/javascript'
  end

end