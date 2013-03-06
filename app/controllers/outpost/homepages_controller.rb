class Outpost::HomepagesController < Outpost::ResourceController
  #--------------------
  # Outpost
  self.model = Homepage

  define_list do
    list_default_order "updated_at"
    list_default_sort_mode "desc"
    list_per_page 3

    column :published_at, sortable: true, default_sort_mode: "desc"
    column :status
    column :base, header: "Template"
    column :updated_at, header: "Last Updated", sortable: true, default_sort_mode: "desc"
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
