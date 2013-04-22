class RenameFrozenObjectField < ActiveRecord::Migration
  def up
    add_column :versions, :object_changes, :text

    add_column :news_story, :locale, :string
    add_column :news_story, :lead_asset_scheme, :string
    add_column :programs_kpccprogram, :quick_slug, :string
    add_column :auth_user, :first_name, :string
    add_column :auth_user, :last_name, :string
    add_column :auth_user, :is_staff, :boolean
    add_column :auth_user, :is_active, :boolean
    add_column :auth_user, :date_joined, :datetime
    add_column :blogs_entry, :blog_slug, :string
    add_column :shows_segment, :locale, :string
    add_column :flatpages_flatpage, :enable_comments, :boolean
    add_column :flatpages_flatpage, :registration_required, :boolean
    add_column :press_releases, :published_at, :datetime
    add_column :events, :etype, :string
    add_column :events, :sponsor_link, :string
    add_column :events, :rsvp_link, :string
    add_column :events, :location_link, :string
    add_column :events, :kpcc_event, :boolean
    add_column :events, :old_audio, :string
    add_column :events, :is_published, :boolean
    add_column :events, :show_comments, :boolean
    add_column :contentbase_featuredcomment, :django_content_type_id, :integer
    add_column :contentbase_featuredcomment, :published_at, :datetime

    NewsStory

    Secretary::Version.where("object_yaml is null").find_in_batches do |group|
      group.each do |version|
        obj = version.frozen_object
        prev_obj = version.previous_version.try(:frozen_object) || obj.class.new

        changes = nil

        ActiveRecord::Base.transaction do
          prev_obj.assign_attributes(obj.attributes)
          changes = prev_obj.changes
          raise ActiveRecord::Rollback
        end

        version.object_changes = changes
        version.save!
      end
    end

    remove_column :news_story, :locale
    remove_column :news_story, :lead_asset_scheme
    remove_column :programs_kpccprogram, :quick_slug
    remove_column :auth_user, :first_name
    remove_column :auth_user, :last_name
    remove_column :auth_user, :is_staff
    remove_column :auth_user, :is_active
    remove_column :auth_user, :date_joined
    remove_column :blogs_entry, :blog_slug
    remove_column :shows_segment, :locale
    remove_column :flatpages_flatpage, :enable_comments
    remove_column :flatpages_flatpage, :registration_required
    remove_column :press_releases, :published_at
    remove_column :events, :etype
    remove_column :events, :sponsor_link
    remove_column :events, :rsvp_link
    remove_column :events, :location_link
    remove_column :events, :kpcc_event
    remove_column :events, :old_audio
    remove_column :events, :is_published
    remove_column :events, :show_comments
    remove_column :contentbase_featuredcomment, :django_content_type_id
    remove_column :contentbase_featuredcomment, :published_at

    remove_column :versions, :object_yaml
  end



  def down
    add_column :versions, :object_yaml, :text
    remove_column :version, :object_changes
  end
end
