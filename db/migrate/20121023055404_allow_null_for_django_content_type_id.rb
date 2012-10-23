class AllowNullForDjangoContentTypeId < ActiveRecord::Migration
  def up
    change_column :ascertainment_ascertainmentrecord, :django_content_type_id, :integer, null: true
    change_column :assethost_contentasset, :django_content_type_id, :integer, null: true
    change_column :contentbase_contentalarm, :django_content_type_id, :integer, null: true
    change_column :contentbase_contentbyline, :django_content_type_id, :integer, null: true
    change_column :contentbase_contentcategory, :django_content_type_id, :integer, null: true
    change_column :contentbase_featuredcomment, :django_content_type_id, :integer, null: true
    change_column :contentbase_misseditcontent, :django_content_type_id, :integer, null: true
    change_column :layout_homepagecontent, :django_content_type_id, :integer, null: true
    change_column :media_audio, :django_content_type_id, :integer, null: true
    change_column :media_link, :django_content_type_id, :integer, null: true
    change_column :media_related, :django_content_type_id, :integer, null: true
    change_column :media_related, :rel_django_content_type_id, :integer, null: true
    change_column :taggit_taggeditem, :django_content_type_id, :integer, null: true
  end

  def down
    change_column :ascertainment_ascertainmentrecord, :django_content_type_id, :integer, null: false
    change_column :assethost_contentasset, :django_content_type_id, :integer, null: false
    change_column :contentbase_contentalarm, :django_content_type_id, :integer, null: false
    change_column :contentbase_contentbyline, :django_content_type_id, :integer, null: false
    change_column :contentbase_contentcategory, :django_content_type_id, :integer, null: false
    change_column :contentbase_featuredcomment, :django_content_type_id, :integer, null: false
    change_column :contentbase_misseditcontent, :django_content_type_id, :integer, null: false
    change_column :layout_homepagecontent, :django_content_type_id, :integer, null: false
    change_column :media_audio, :django_content_type_id, :integer, null: false
    change_column :media_link, :django_content_type_id, :integer, null: false
    change_column :media_related, :django_content_type_id, :integer, null: false
    change_column :media_related, :rel_django_content_type_id, :integer, null: false
    change_column :taggit_taggeditem, :django_content_type_id, :integer, null: false
  end
end
