class Admin::BlogEntriesController < Admin::ResourceController
  def preview
    @entry = ContentBase.obj_by_key!(params[:obj_key])
    @entry.attributes.merge!(params[:blog_entry])
    
    @blog  = @entry.blog
    @title = @entry.to_title
    
    render layout: "admin/preview", template: "/blogs/entry"
  end
end
