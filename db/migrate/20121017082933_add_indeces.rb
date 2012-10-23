class AddIndeces < ActiveRecord::Migration
  def change
    add_index :admin_user_permissions, :admin_user_id
    add_index :admin_user_permissions, :permission_id
    
    add_index :assethost_contentasset, :asset_order
    
    add_index :blogs_entry, [:status, :published_at]
    add_index :shows_segment, [:status, :published_at]
    add_index :news_story, [:status, :published_at]
    add_index :shows_episode, [:status, :published_at]
    add_index :contentbase_contentshell, [:status, :published_at]
    add_index :contentbase_videoshell, [:status, :published_at]
    
    add_index :bios_bio, :slug
    add_index :bios_bio, :is_public
    
    add_index :events_event, [:starts_at, :ends_at]
    add_index :events_event, :etype
    
    add_index :flatpages_flatpage, :is_public
    
    add_index :layout_breakingnewsalert, :is_published
    add_index :layout_breakingnewsalert, :visible
    add_index :layout_homepage, [:status, :published_at]
    
    add_index :media_audio, :mp3
    add_index :media_audio, :position
    
    add_index :media_link, :sort_order
    
    add_index :permissions, [:resource, :action]
    
    add_index :pij_query, :is_featured
    add_index :pij_query, :query_type
    add_index :pij_query, [:is_active, :published_at]
    
    add_index :programs_kpccprogram, :air_status
    add_index :programs_otherprogram, :air_status
    
    add_index :schedule_program, [:day, :start_time, :end_time]
    
    add_index :section_blogs, :section_id
    add_index :section_blogs, :blog_id
    
    add_index :section_categories, :section_id
    add_index :section_categories, :category_id
    
    add_index :sections, :missed_it_bucket_id

    add_index :section_promotions, :section_id
    add_index :section_promotions, :promotion_id
    
    add_index :shows_rundown, :segment_order
    
    add_index :versions, :user_id
    add_index :versions, [:versioned_type, :versioned_id]
    add_index :versions, :version_number
  end
end
