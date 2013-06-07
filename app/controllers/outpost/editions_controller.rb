class Outpost::EditionsController < Outpost::ResourceController
  outpost_controller

  define_list do |l|
    l.default_order = "published_at"
    l.default_sort_mode = "desc"
    
    l.column :published_at, sortable: true, default_sort_mode: "desc"
    l.column :status
    l.column :updated_at, header: "Last Updated", sortable: true, default_sort_mode: "desc"

    l.filter :status, collection: -> { Edition.status_text_collection }
  end

  private

  def search
    # TODO - not this.
    #
    # This is a hack so the search form doesn't show up.
    # Outpost checks the controllers action methods for #search.
    # ResourceController defines that method (via Searchable module).
    # So by overriding #search as a private method, it won't be 
    # considered an action method and therefore won't be in the
    # action_methods array.
  end
end
