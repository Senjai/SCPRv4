class Outpost::BlogEntriesController < Outpost::ResourceController
  outpost_controller

  define_list do |l|
    l.default_order = "updated_at"
    l.default_sort_mode = "desc"
    
    l.column :headline
    l.column :blog
    l.column :byline
    l.column :published_at, sortable: true, default_sort_mode: "desc"
    l.column :status
    l.column :updated_at, header: "Last Updated", sortable: true, default_sort_mode: "desc"

    l.filter :blog_id, collection: -> { Blog.select_collection }
    l.filter :bylines, collection: -> { Bio.select_collection }
    l.filter :status, collection: -> { ContentBase.status_text_collect }
  end

  #----------------

  def preview
    @entry = Outpost.obj_by_key(params[:obj_key]) || BlogEntry.new
    
    with_rollback @entry do
      @entry.assign_attributes(params[:blog_entry])

      if @entry.unconditionally_valid?
        @title = @entry.to_title
        render "/blogs/_entry", layout: "outpost/preview/application", locals: { entry: @entry, full: true }
      else
        render_preview_validation_errors(@entry)
      end
    end
  end
end
