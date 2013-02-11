class Admin::ContentShellsController < Admin::ResourceController
  #----------------
  # Outpost
  self.model = ContentShell

  define_list do
    list_order "updated_at desc"
    
    column :headline
    column :site
    column :byline
    column :published_at
    column :status
    
    filter :site, collection: -> { ContentShell.select("distinct site").map { |c| c.site } }
    filter :status, collection: -> { ContentBase.status_text_collect }
  end

  #----------------

  private
  
  def search_params
    @search_params ||= {
      :order       => :published_at,
      :sort_mode   => :desc
    }
  end 
end
