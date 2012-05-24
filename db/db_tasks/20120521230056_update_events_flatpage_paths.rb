class UpdateEventsFlatpagePaths < ActiveRecord::Migration
  DefaultValues = { 
    enable_comments: false, 
    registration_required: false,
    render_as_template: false,
    enable_in_new_site: true,
    show_sidebar: true,
    template_name: "",
    title: "Redirect",
    description: "Redirect only"
  }
    
  def up
    # create returns the object no matter what
    # update_attribute does not run validations so is only useful if the database is enforcing data integrity
    
    Flatpage.unscoped.where("url LIKE ?", "/forum%").all.each do |old_forum_flatpage|
      old_url = old_forum_flatpage.url
      
      if old_forum_flatpage.update_attributes(url: "/events#{old_url}")
        puts "(3) updated forum url to #{old_forum_flatpage.url}"
      else
        puts "(4) failed: #{old_forum_flatpage.url} (#{old_forum_flatpage.errors.full_messages.join(", ")})"
      end
        
      new_forum_redirect = Flatpage.new({ url: old_url, redirect_url: "/events#{old_url}" }.reverse_merge!(DefaultValues))
      if new_forum_redirect.save
        puts "(5) created forum redirect at #{new_forum_redirect.url}"
      else
        puts "(6) failed: #{new_forum_redirect.url} (#{new_forum_redirect.errors.full_messages.join(", ")})"
      end
    end
  end

  def down
    # note: object.delete uses the default_scope in its query, so we need to put the update_all call at the end  
    
    Flatpage.unscoped.where("url LIKE ?", "/forum%").all.each do |old_forum_redirect|
      if old_forum_redirect.delete
        puts "(13) deleted forum redirect : #{old_forum_redirect.url}"
      else
        puts "(14) failed: #{old_forum_redirect.url} (#{old_forum_redirect.errors.full_messages.join(", ")})"
      end
    end
    
    Flatpage.unscoped.where("url LIKE ?", "/events%").all.each do |old_forum_flatpage|
      old_url = old_forum_flatpage.url.gsub("/events", "")
      if old_forum_flatpage.update_attributes(url: old_url)
        puts "(11) downdated forum url to #{old_forum_flatpage.url}"
      else
        puts "(12) failed: #{old_forum_flatpage.url} (#{old_forum_flatpage.errors.full_messages.join(", ")})"
      end
    end
    
    Scprv4::Application.reload_routes!
    puts "Reloaded Routes and done. Total flatpages: #{Flatpage.unscoped.count}"
  end
end
