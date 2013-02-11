class Admin::FlatpagesController < Admin::ResourceController
  #------------------
  # Outpost
  self.model = Flatpage

  define_list do
    list_order "updated_at desc"
    list_per_page 50
    
    column :url
    column :is_public, header: "Public?"
    column :redirect_url
    column :title
    column :updated_at
    
    filter :is_public, collection: :boolean
  end

  #------------------

  def preview
    @flatpage = ContentBase.obj_by_key(params[:obj_key]) || Flatpage.new

    with_rollback @flatpage do
      @flatpage.assign_attributes(params[:flatpage])

      if @flatpage.unconditionally_valid?
        @title = @flatpage.to_title

        if @flatpage.is_redirect?
          render '/admin/shared/_notice', layout: "admin/minimal", 
            locals: { message: "This flatpage will redirect to <strong>#{@flatpage.redirect_url}</strong>".html_safe }
        else
          layout_template = begin
            case @flatpage.template
              when "full"  then 'admin/preview/app_nosidebar'
              when "forum" then 'admin/preview/forum'
              when "none"  then false
              else 'admin/preview/application'
            end
          end

          render "/flatpages/_flatpage", layout: layout_template, locals: { flatpage: @flatpage }
        end
      else
        render_preview_validation_errors(@flatpage)
      end
    end
  end
end
