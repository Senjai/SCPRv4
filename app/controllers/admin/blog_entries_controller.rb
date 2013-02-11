class Admin::BlogEntriesController < Admin::ResourceController
  #----------------
  # Outpost
  self.model = BlogEntry
  
  define_list do
    list_order "updated_at desc"
    
    column :headline
    column :blog
    column :byline
    column :published_at, sortable: true, default_sort_mode: "desc"
    column :status
    
    filter :blog_id, collection: -> { Blog.select_collection }
    filter :bylines, collection: -> { Bio.select_collection }
    filter :status, collection: -> { ContentBase.status_text_collect }
  end

  #----------------

  def preview
    @entry = ContentBase.obj_by_key(params[:obj_key]) || BlogEntry.new
    
    with_rollback @entry do
      @entry.assign_attributes(params[:blog_entry])

      if @entry.unconditionally_valid?
        @title = @entry.to_title
        render "/blogs/_entry", layout: "admin/preview/application", locals: { entry: @entry, full: true }
      else
        render_preview_validation_errors(@entry)
      end
    end
  end

  #----------------

  private

  def search_params
    @search_params ||= {
      :order       => order_attribute ||= :published_at,
      :sort_mode   => sort_mode ||= :desc
    }
  end
end
