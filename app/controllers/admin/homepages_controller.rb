class Admin::HomepagesController < Admin::ResourceController
  def preview
    @homepage = ContentBase.obj_by_key!(params[:obj_key])
    @homepage.assign_attributes(params[:homepage])
    @title = @homepage.to_title
    
    render "/admin/homepages/previews/#{@homepage.base}", layout: "/admin/preview", locals: { homepage: @homepage }
  end
end
