class Admin::FlatpagesController < Admin::ResourceController
  #------------------
  # Outpost
  self.model = Flatpage

  define_list do
    list_default_order "url"
    list_default_sort_mode "asc"
    
    column :title
    column :url, sortable: true, default_sort_mode: "asc"
    column :redirect_url
    column :updated_at, sortable: true, default_sort_mode: "desc"
    column :is_public, header: "Public?"
    
    filter :is_public, title: "Public?", collection: :boolean
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
          render "/flatpages/_flatpage", layout: layout_template, locals: { flatpage: @flatpage }
        end
      else
        render_preview_validation_errors(@flatpage)
      end
    end
  end

  private

  def layout_template
    template = ::FlatpagesController::TEMPLATE_MAP[@flatpage.template]
    template = "application" if template.nil?
    template ? "admin/preview/#{template}" : false
  end
end
