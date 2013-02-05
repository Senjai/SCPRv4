class Admin::BlogEntriesController < Admin::ResourceController  
  def preview
    @entry = ContentBase.obj_by_key(params[:obj_key]) || BlogEntry.new
    
    with_rollback @entry do
      @entry.assign_attributes(params[:blog_entry])

      if @entry.unconditionally_valid?
        @title = @entry.to_title
        render "/blogs/_entry", layout: "/admin/preview/application", locals: { entry: @entry, full: true }
      else
        render_preview_validation_errors(@entry)
      end
    end
  end
end
