class FixTypeColumnLengths < ActiveRecord::Migration
  def up
    change_column :assethost_contentasset, :content_type, :string
    change_column :assethost_contentasset, :content_id, :integer, null: true
    change_column :assethost_contentasset, :position, :integer, null: true
    change_column :assethost_contentasset, :asset_id, :integer, null: true

    change_column :contentbase_contentalarm, :content_type, :string
    change_column :contentbase_contentalarm, :content_id, :integer, null: true

    change_column :contentbase_contentbyline, :content_type, :string
    change_column :contentbase_contentbyline, :content_id, :integer, null: true
    change_column :contentbase_contentbyline, :name, :string

    change_column :contentbase_misseditbucket, :title, :string

    change_column :contentbase_misseditcontent, :content_type, :string
    change_column :contentbase_misseditcontent, :content_id, :integer, null: true

    change_column :contentbase_featuredcommentbucket, :title, :string

    change_column :contentbase_featuredcomment, :content_type, :string
    change_column :contentbase_featuredcomment, :username, :string
    change_column :contentbase_featuredcomment, :content_id, :integer, null: true

    change_column :layout_breakingnewsalert, :headline, :string
    change_column :layout_breakingnewsalert, :alert_type, :string

    change_column :layout_homepagecontent, :content_type, :string
    change_column :layout_homepagecontent, :content_id, :integer, null: true

    change_column :media_related, :content_type, :string
    change_column :media_related, :related_type, :string

    change_column :media_audio, :content_id, :integer, null: true
    change_column :media_audio, :position, :integer
  end

  def down
  end
end
