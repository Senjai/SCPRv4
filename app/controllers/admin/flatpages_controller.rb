class Admin::FlatpagesController < Admin::ResourceController
  def preview
    @flatpage = ContentBase.obj_by_key!(params[:obj_key])

    with_rollback @flatpage do
      @flatpage.assign_attributes(params[:flatpage])

      layout_template = begin
        case @flatpage.template
          when "full"  then '/admin/preview/app_nosidebar'
          when "forum" then '/admin/preview/forum'
          when "none"  then false
          else '/admin/preview/application'
        end
      end

      render "/flatpages/_flatpage", layout: layout_template, locals: { flatpage: @flatpage }
    end
  end
end
