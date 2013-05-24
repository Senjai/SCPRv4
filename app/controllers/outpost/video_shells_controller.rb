class Outpost::VideoShellsController < Outpost::ResourceController
  #---------------
  # Outpost
  self.model = VideoShell

  define_list do
    list_default_order "published_at"
    list_default_sort_mode "desc"

    column :headline
    column :slug
    column :byline
    column :published_at, sortable: true, default_sort_mode: "desc"
    column :status

    filter :status, collection: -> { ContentBase.status_text_collect }
    filter :bylines, collection: -> { Bio.select_collection }
  end

  private

  def search
    # hack attack
  end
end
