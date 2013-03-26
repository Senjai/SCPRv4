class RemoveDjangoContentIdColumns < ActiveRecord::Migration
  def up
    remove_column :ascertainment_ascertainmentrecord, :django_content_type_id
    remove_column :assethost_contentasset, :django_content_type_id
    remove_column :contentbase_contentalarm, :django_content_type_id
    remove_column :contentbase_contentbyline, :django_content_type_id
    remove_column :contentbase_contentcategory, :django_content_type_id
    remove_column :contentbase_featuredcomment, :django_content_type_id
    remove_column :contentbase_misseditcontent, :django_content_type_id
    remove_column :layout_homepagecontent, :django_content_type_id
    remove_column :media_audio, :django_content_type_id
    remove_column :media_related, :django_content_type_id
    remove_column :media_related, :rel_django_content_type_id
    
    remove_column :media_audio, :django_mp3

    remove_table :rails_content_map
  end

  def down
    add_column :ascertainment_ascertainmentrecord, :django_content_type_id, :integer
    add_column :assethost_contentasset, :django_content_type_id, :integer
    add_column :contentbase_contentalarm, :django_content_type_id, :integer
    add_column :contentbase_contentbyline, :django_content_type_id, :integer
    add_column :contentbase_contentcategory, :django_content_type_id, :integer
    add_column :contentbase_featuredcomment, :django_content_type_id, :integer
    add_column :contentbase_misseditcontent, :django_content_type_id, :integer
    add_column :layout_homepagecontent, :django_content_type_id, :integer
    add_column :media_audio, :django_content_type_id, :integer
    add_column :media_related, :django_content_type_id, :integer
    add_column :media_related, :rel_django_content_type_id, :integer

    add_column :media_audio, :django_mp3, :string
    
    create_table :rails_content_map do |t|
      t.integer :django_content_type_id
      t.string :rails_class_name
    end
  end
end
