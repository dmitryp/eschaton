module KernelControllerExt

  def run_javascript(&block)
    render :js => Eschaton.with_global_script(&block)
  end

end