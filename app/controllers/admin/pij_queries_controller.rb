class Admin::PijQueriesController < Admin::ResourceController
  #----------------
  # Outpost
  self.model = PijQuery

  define_list do
    column :headline
    column :slug
    column :query_type
    column :is_active, header: "Active?"
    column :is_featured, header: "Featured?"
    column :published_at
    
    filter :query_type, collection: -> { PijQuery::QUERY_TYPES }
    filter :is_active, collection: :boolean
    filter :is_featured, collection: :boolean
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
