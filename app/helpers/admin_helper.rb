module AdminHelper
  def flash_alert_type(name)
    name_bootstrap_map = {
      notice: "success",
      alert:  "error"
    }
    
    name_bootstrap_map[name.to_sym] || name.to_s
  end

  #----------------
  # Use this to block out whole chunks of code 
  # based on permissions
  def guard(resource, message=nil, &block)
    if admin_user.can_manage?(resource)
      capture(&block)
    else
      message
    end
  end

  #----------------
  # Use this if you want to conditionally link
  # text based on permissions
  def guarded_link_to(*args)
    resource = args.shift
    if admin_user.can_manage?(resource)
      link_to *args
    else
      args[0] # Just the link title
    end
  end
  
  #----------------
  # Render the block inside of the fieldset template
  def form_block(title=nil, &block)
    render "/admin/shared/form_block", title: title, body: capture(&block)
  end
  
  #----------------
  # Render the default fields, plus any extra fields
  def section(partial, f, record, option={}, &block)
    render "/admin/shared/sections/#{partial}", f: f, record: record, extra: block_given? ? capture(&block) : ""
  end
end
