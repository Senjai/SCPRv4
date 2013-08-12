class Outpost::PijQueriesController < Outpost::ResourceController
  outpost_controller

  define_list do |l|
    l.default_order       = "published_at"
    l.default_sort_mode   = "desc"

    l.column :headline
    l.column :slug
    l.column :query_type, header: "Type"
    l.column :is_featured, header: "Featured?"
    l.column :status
    l.column :published_at, sortable: true, default_sort_mode: "desc"
    l.column :pin_query_id

    l.filter :status,
      :title      => "Status",
      :collection => -> { PijQuery.status_select_collection }

    l.filter :query_type,
      :title      => "Type",
      :collection => -> { PijQuery::QUERY_TYPES }

    l.filter :is_featured, title: "Featured?", collection: :boolean
  end

  #----------------

  def preview
    @query = Outpost.obj_by_key(params[:obj_key]) || PijQuery.new

    with_rollback @query do
      @query.assign_attributes(params[:pij_query])

      if @query.unconditionally_valid?
        @title = @query.to_title

        render "/pij_queries/_pij_query",
          :layout => "outpost/preview/application",
          :locals => { query: @query }

      else
        render_preview_validation_errors(@query)
      end
    end
  end
end
