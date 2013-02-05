class Admin::FlatpagesController < Admin::ResourceController
  def preview
    @flatpage = ContentBase.obj_by_key!(params[:obj_key])
    
    layout_template = begin
      case @flatpage.template
        when "full"  then 'preview_nosidebar'
        when "forum" then "preview_forum"
        when "none"  then false
        else 'preview'
      end
    end

    with_rollback @flatpage do
      @flatpage.assign_attributes(params[:flatpage])
      render "/flatpages/_flatpage", layout: "/admin/preview/#{layout_template}", locals: { flatpage: @flatpage }
    end
  end
end
