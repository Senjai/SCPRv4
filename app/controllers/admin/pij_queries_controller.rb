class Admin::PijQueriesController < Admin::ResourceController
  #----------------
  # Outpost
  self.model = PijQuery

  define_list do
    list_default_order "published_at"
    list_default_sort_mode "desc"

    column :headline
    column :slug
    column :query_type, header: "Type"
    column :is_active, header: "Active?"
    column :is_featured, header: "Featured?"
    column :published_at, sortable: true, default_sort_mode: "desc"
    
    filter :query_type, title: "Type", collection: -> { PijQuery::QUERY_TYPES }
    filter :is_active, title: "Active?", collection: :boolean
    filter :is_featured, title: "Featured?", collection: :boolean
  end

  #----------------

  def preview
    @query = ContentBase.obj_by_key(params[:obj_key]) || PijQuery.new
    
    with_rollback @query do
      @query.assign_attributes(params[:pij_query])

      if @query.unconditionally_valid?
        @title = @query.to_title
        render "/pij_queries/_pij_query", layout: "admin/preview/application", locals: { query: @query }
      else
        render_preview_validation_errors(@query)
      end
    end
  end
end
