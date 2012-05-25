class EnableFlatpagesInNewSite < ActiveRecord::Migration
  # Before: Flatpage.count == 96
  # After: Flatpage.count == 145
  
  MercerPages = %w{ /405/ /about/jobs/ /boyleheights/ /laelections/ /lovela/ }
  
  def up
    Flatpage.unscoped.all.reject { |f| MercerPages.include? f.url}.each do |flatpage|
      if flatpage.update_attributes(enable_in_new_site: true)
        puts "(1) updated new_site bool for #{flatpage.url}"
      else
        puts "(2) failed: #{flatpage.url} (#{flatpage.errors.full_messages.join(", ")})"
      end
    end
    
    Scprv4::Application.reload_routes!
    puts "Reloaded routes, and finished! Total flatpages: #{Flatpage.unscoped.count}"
  end

  def down
    Scprv4::Application.reload_routes!
    puts "Can't do anything, you'll have to manually set back all the enabled_in_new_site bools. It's okay."
  end
end
