class UpdateEventsFlatpagePaths < ActiveRecord::Migration
  # Before: Flatpage.count == 96
  # After: Flatpage.count == 127
  MercerPages = %w{ /405/ /about/jobs/ /boyleheights/ /careers/ /laelections/ /lovela/ }
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
  
  Redirects = [
    { url: "/forum/events/",         redirect_url: "/events/forum/" },
    { url: "/forum/",                redirect_url: "/events/forum/" },
    { url: "/crawfordfamilyforum/",  redirect_url: "/events/forum/" },
      
    { url: "/podcast/",              redirect_url: "/podcasts/" },
      
    { url: "/increase/",             redirect_url: "https://scprcontribute.publicradio.org/contribute.php?refId=sustup/" },
    { url: "/leadership/",           redirect_url: "https://scprcontribute.publicradio.org/contribute.php?refId=lcrenew/" },
      
    { url: "/benefits/",             redirect_url: "/support/member_benefits_card/" },
    { url: "/car/",                  redirect_url: "/support/car_donation/" },
    { url: "/cars/",                 redirect_url: "/support/car_donation/" },
    { url: "/sustainer/",            redirect_url: "/support/sustainer/" },
    { url: "/sustainingmembers/",    redirect_url: "/support/sustaining_memberships/" },
      
    { url: "/news/local/",           redirect_url: "/local/" },
    { url: "/news/us/",              redirect_url: "/world/" },
    { url: "/news/world/",           redirect_url: "/world/" },
    { url: "/news/politics/",        redirect_url: "/politics/" },
    { url: "/news/economy/",         redirect_url: "/money/" },
    { url: "/news/law/",             redirect_url: "/crime/" },
    { url: "/news/education/",       redirect_url: "/education/" },
    { url: "/news/health/",          redirect_url: "/health/" },
    { url: "/news/environment/",     redirect_url: "/environment/" },
    { url: "/news/science/",         redirect_url: "/environment/" },
    { url: "/news/transportation/",  redirect_url: "/local/" },
    { url: "/news/arts/",            redirect_url: "/arts-life/" },
    { url: "/news/living/",          redirect_url: "/culture/" },
    { url: "/news/opinion/",         redirect_url: "/" }
  ]
  
  FlatpageCount = Flatpage.unscoped.count
  
  def up
    # create returns the object no matter what
    # update_attribute does not run validations so is only useful if the database is enforcing data integrity
    
    Flatpage.unscoped.all.reject { |f| MercerPages.include? f.url}.each do |flatpage|
      if flatpage.update_attributes(enable_in_new_site: true)
        puts "(1) updated new_site bool for #{flatpage.url}"
      else
        puts "(2) failed: #{flatpage.url} (#{flatpage.errors.full_messages.join(", ")})"
      end
    end
    
    Flatpage.unscoped.where("url LIKE ?", "/forum%").all.each do |old_forum_flatpage|
      old_url = old_forum_flatpage.url
      
      if old_forum_flatpage.update_attributes(url: "/events#{old_url}")
        puts "(3) updated url to #{old_forum_flatpage.url}"
      else
        puts "(4) failed: #{old_forum_flatpage.url} (#{old_forum_flatpage.errors.full_messages.join(", ")})"
      end
        
      new_forum_redirect = Flatpage.new({ url: old_url, redirect_url: "/events#{old_url}" }.reverse_merge!(DefaultValues))
      if new_forum_redirect.save
        puts "(5) created redirect at #{new_forum_redirect.url}"
      else
        puts "(6) failed: #{new_forum_redirect.url} (#{new_forum_redirect.errors.full_messages.join(", ")})"
      end
    end
    
    Redirects.each do |attributes|
      existing_flatpages = Flatpage.unscoped.where(url: attributes[:url])
      if existing_flatpages.present?
        existing_flatpages.each do |existing_flatpage|
          if existing_flatpage.update_attributes(redirect_url: attributes[:redirect_url])
            puts "(15) changed to redirect #{existing_flatpage.url}"
          else
            puts "(16) failed: #{existing_flatpage.url} (#{existing_flatpage.errors.full_messages.join(", ")})"
          end
        end
      else
        redirect_flatpage = Flatpage.new(attributes.reverse_merge!(DefaultValues))
        if redirect_flatpage.save
          puts "(7) created #{redirect_flatpage.url}"
        else
          puts "(8) failed: #{redirect_flatpage.url} (#{redirect_flatpage.errors.full_messages.join(", ")})"
        end
      end
    end
    
    puts "Finished - Total Flatpages: #{Flatpage.unscoped.count} (before migration was #{FlatpageCount})"
  end

  def down
    # note: object.delete uses the default_scope in its query, so we need to put the update_all call at the end
    
    Redirects.each do |attributes|
      Flatpage.unscoped.where(url: attributes[:url]).each do |old_redirect|
        if old_redirect.content.present? or old_redirect.title != "Redirect"
          if old_redirect.update_attributes(redirect_url: nil)
            puts "(17) changed to flatpage #{old_redirect.url}"
          else
            puts "(18) failed: #{old_redirect.url} (#{old_redirect.errors.full_messages.join(", ")})"
          end
        else
          if old_redirect.delete
            puts "(9) deleted #{old_redirect.url}"
          else
            puts "(10) failed: #{old_redirect.url} (#{old_redirect.errors.full_messages.join(", ")})"
          end
        end
      end
    end    
    
    Flatpage.unscoped.where("url LIKE ?", "/forum%").all.each do |old_forum_redirect|
      if old_forum_redirect.delete
        puts "(13) deleted #{old_forum_redirect.url}"
      else
        puts "(14) failed: #{old_forum_redirect.url} (#{old_forum_redirect.errors.full_messages.join(", ")})"
      end
    end
    
    Flatpage.unscoped.where("url LIKE ?", "/events%").all.each do |old_forum_flatpage|
      old_url = old_forum_flatpage.url.gsub("/events", "")
      if old_forum_flatpage.update_attributes(url: old_url)
        puts "(11) downdated url to #{old_forum_flatpage.url}"
      else
        puts "(12) failed: #{old_forum_flatpage.url} (#{old_forum_flatpage.errors.full_messages.join(", ")})"
      end
    end
    
    puts "disabling all existing flatpages in new site..."
    # Flatpage.unscoped.update_all(enable_in_new_site: false)
    puts "Finished - Total Flatpages: #{Flatpage.unscoped.count} (before migration was #{FlatpageCount})"
  end
end
