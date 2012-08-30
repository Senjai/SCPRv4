module AdminHelper
  def flash_alert_type(name)
    name_bootstrap_map = {
      notice: "success",
      alert:  "error"
    }
    
    name_bootstrap_map[name.to_sym] || name.to_s
  end
  
  # Render the block inside of the fieldset template
  def form_block(title, &block)
    render "/admin/shared/form_block", title: title, body: capture(&block)
  end
  
  # Render the default fields, plus any extra fields
  def section(partial, f, record, option={}, &block)
    render "/admin/shared/sections/#{partial}", f: f, record: record, extra: block_given? ? capture(&block) : ""
  end
end