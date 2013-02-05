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
  # based on permissions. If the user has permission
  # to manage the resource, show the block.
  # Otherwise, display the message (or nil by default).
  #
  # Usage:
  #
  #   <%= guard NewsStory, "You do not have permission to view this" do %>
  #     <%= @news_story.headline %>
  #   <% end %>
  #
  def guard(resource, message=nil, &block)
    if admin_user.can_manage?(resource)
      capture(&block)
    else
      message
    end
  end

  #----------------
  # Conditionally link text based on permissions.
  # If the user has permission to manage the resource,
  # link to it. Otherwise, just show the text.
  #
  # The first argument is the resource to guard.
  # All other arguments are passed as-is to +link_to+
  #
  # Usage:
  #
  #   <%= guarded_link_to NewsStory, @news_story.headline, edit_news_story_path(@news_story) %>
  #
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
  # Place a modal anywhere with a button to toggle it
  #
  # Takes a hash of options and a block with the content
  #
  def modal_toggle(options={}, &block)
    render "/admin/shared/modal", options: options, body: capture(&block)
  end

  #----------------
  # Render the submit row.
  def submit_row(record, persisted_record)
    render('admin/shared/submit_row', record: record, persisted_record: persisted_record)
  end
  
  #----------------
  # Render the index header
  def index_header(resource_class)
    render('admin/shared/index_header', resource_class: resource_class)
  end
end
