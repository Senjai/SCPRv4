class Admin::BlogEntriesController < Admin::ResourceController  
  def preview
    @entry = ContentBase.obj_by_key!(params[:obj_key])
    @entry.assign_attributes(params[:blog_entry])
    @title = @entry.to_title
    
    render "/blogs/_entry", layout: "/admin/preview", locals: { entry: @entry, full: true }
  end
end
