class Admin::PijQueriesController < Admin::ResourceController
  def preview
    @query = ContentBase.obj_by_key(params[:obj_key]) || PijQuery.new
    
    with_rollback @query do
      @query.assign_attributes(params[:pij_query])

      if @query.unconditionally_valid?
        @title = @query.to_title
        render "/pij_queries/_pij_query", layout: "/admin/preview/application", locals: { query: @query }
      else
        render_preview_validation_errors(@query)
      end
    end
  end
end
