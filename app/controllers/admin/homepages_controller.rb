class Admin::HomepagesController < Admin::ResourceController
  #--------------------
  # Outpost
  self.model = Homepage

  define_list do
    column :published_at
    column :status
    column :base, header: "Base Template"
  end

  #--------------------

  def preview
    @homepage = ContentBase.obj_by_key(params[:obj_key]) || Homepage.new
    
    with_rollback @homepage do
      @homepage.assign_attributes(params[:homepage])

      if @homepage.unconditionally_valid?
        @title = @homepage.to_title
        render "/admin/homepages/previews/#{@homepage.base}", layout: "admin/preview/application", locals: { homepage: @homepage }
      else
        render_preview_validation_errors(@homepage)
      end
    end
  end
end
