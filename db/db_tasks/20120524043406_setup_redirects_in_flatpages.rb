class SetupRedirectsInFlatpages < ActiveRecord::Migration
  DefaultValues = { 
    enable_comments: false, 
    registration_required: false,
    render_as_template: false,
    enable_in_new_site: true,
    show_sidebar: true,
    template_name: "",
    title: "Redirect",
    description: "Redirect only",
    is_public: true
  }
  
  Redirects = [
    { url: "/forum/events/",         redirect_url: "http://scpr.org/events/forum/" },
    { url: "/forum/",                redirect_url: "http://scpr.org/events/forum/" },
    { url: "/crawfordfamilyforum/",  redirect_url: "http://scpr.org/events/forum/" },
    { url: "/podcast/",              redirect_url: "http://scpr.org/podcasts/" },
    { url: "/beta/",                 redirect_url: "http://scpr.org/"},
    { url: "/increase/",             redirect_url: "https://scprcontribute.publicradio.org/contribute.php?refId=sustup/" },
    { url: "/leadership/",           redirect_url: "https://scprcontribute.publicradio.org/contribute.php?refId=lcrenew/" },
    
    { url: "/careers/",              redirect_url: "http://scpr.org/about/jobs" },
    { url: "/jobs/",                 redirect_url: "http://scpr.org/about/jobs" },
    { url: "/benefits/",             redirect_url: "http://scpr.org/support/member_benefits_card/" },
    { url: "/car/",                  redirect_url: "http://scpr.org/support/car_donation/" },
    { url: "/cars/",                 redirect_url: "http://scpr.org/support/car_donation/" },
    { url: "/sustainer/",            redirect_url: "http://scpr.org/support/sustainer/" },
    { url: "/sustainingmembers/",    redirect_url: "http://scpr.org/support/sustaining_memberships/" },
      
    { url: "/news/local/",           redirect_url: "http://scpr.org/local/" },
    { url: "/news/us/",              redirect_url: "http://scpr.org/world/" },
    { url: "/news/world/",           redirect_url: "http://scpr.org/world/" },
    { url: "/news/politics/",        redirect_url: "http://scpr.org/politics/" },
    { url: "/news/economy/",         redirect_url: "http://scpr.org/money/" },
    { url: "/news/law/",             redirect_url: "http://scpr.org/crime/" },
    { url: "/news/education/",       redirect_url: "http://scpr.org/education/" },
    { url: "/news/health/",          redirect_url: "http://scpr.org/health/" },
    { url: "/news/environment/",     redirect_url: "http://scpr.org/environment/" },
    { url: "/news/science/",         redirect_url: "http://scpr.org/environment/" },
    { url: "/news/transportation/",  redirect_url: "http://scpr.org/local/" },
    { url: "/news/arts/",            redirect_url: "http://scpr.org/arts-life/" },
    { url: "/news/living/",          redirect_url: "http://scpr.org/culture/" },
    { url: "/news/opinion/",         redirect_url: "http://scpr.org/" }
  ]
  
  def up
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
  end

  def down
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
    
    Scprv4::Application.reload_routes!
  end
end
