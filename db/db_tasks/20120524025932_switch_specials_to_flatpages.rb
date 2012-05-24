class Special < ActiveRecord::Base
  self.table_name = 'specials_page'
end

class SwitchSpecialsToFlatpages < ActiveRecord::Migration
  def up
    Flatpage.unscoped.update_all(is_public: true)
    puts "Updated all flatpages to `is_public = true"
    
    Special.all.each do |page|
      flatpage = Flatpage.new({
                  url: "/specials/#{page.slug}/",
                  title: page.title,
                  content: page.body,
                  enable_comments: page.allow_comments,
                  template_name: page.template_name || "",
                  registration_required: false,
                  date_modified: Time.now,
                  render_as_template: false,
                  description: page.title,
                  enable_in_new_site: true,
                  show_sidebar: true,
                  is_public: page.is_public
                })
                
      if flatpage.save
        puts "(1) Converted Special to Flatpage : #{page.slug}"
      else
        puts "(2) Failed: #{page.slug}"
      end        
    end
  end

  def down
    # object.delete uses default_scope, but all of the specials pages have enable_in_new_site == true so it's okay
    Flatpage.where("url like ?", "/specials%").all.each do |flatpage|
      if flatpage.delete
        puts "(3) Removed specials flatpage #{flatpage.url}"
      else
        puts "(4) Failed: #{flatpage.url}"
      end
    end
    
    Scprv4::Application.reload_routes!
  end
end
