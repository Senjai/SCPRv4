class Admin::PijQueriesController < Admin::ResourceController
  def preview
    @query = ContentBase.obj_by_key!(params[:obj_key])
    
    with_rollback @query do
      @query.assign_attributes(params[:pij_query])
      @title = @query.to_title
      render "/pij_queries/_pij_query", layout: "/admin/preview", locals: { query: @query }
    end
  end
end
