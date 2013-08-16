# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130816052703) do

  create_table "abstracts", :force => true do |t|
    t.string   "source"
    t.string   "url"
    t.string   "headline"
    t.text     "summary"
    t.integer  "category_id"
    t.datetime "article_published_at"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "abstracts", ["category_id"], :name => "index_abstracts_on_category_id"
  add_index "abstracts", ["source"], :name => "index_abstracts_on_source"

  create_table "assethost_contentasset", :force => true do |t|
    t.integer "content_id"
    t.integer "position",                           :default => 99
    t.integer "asset_id"
    t.text    "caption",      :limit => 2147483647,                 :null => false
    t.string  "content_type"
  end

  add_index "assethost_contentasset", ["content_id"], :name => "content_type_id"
  add_index "assethost_contentasset", ["content_id"], :name => "index_assethost_contentasset_on_content_id"
  add_index "assethost_contentasset", ["content_type", "content_id"], :name => "index_assethost_contentasset_on_content_type_and_content_id"
  add_index "assethost_contentasset", ["position"], :name => "index_assethost_contentasset_on_asset_order"

  create_table "auth_user", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "old_password"
    t.boolean  "can_login",       :null => false
    t.boolean  "is_superuser",    :null => false
    t.datetime "last_login"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "name"
  end

  add_index "auth_user", ["username", "can_login"], :name => "index_auth_user_on_username_and_can_login"

  create_table "bios_bio", :force => true do |t|
    t.integer  "user_id"
    t.string   "slug"
    t.text     "bio"
    t.string   "title"
    t.boolean  "is_public",      :default => false, :null => false
    t.string   "twitter_handle"
    t.integer  "asset_id"
    t.string   "short_bio"
    t.string   "phone_number"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "last_name"
  end

  add_index "bios_bio", ["is_public", "last_name"], :name => "index_bios_bio_on_is_public_and_last_name"
  add_index "bios_bio", ["is_public"], :name => "index_bios_bio_on_is_public"
  add_index "bios_bio", ["last_name"], :name => "index_bios_bio_on_last_name"
  add_index "bios_bio", ["slug"], :name => "index_bios_bio_on_slug"

  create_table "blogs_blog", :force => true do |t|
    t.string   "name"
    t.string   "slug",                :limit => 50
    t.text     "description",         :limit => 2147483647
    t.boolean  "is_active",                                 :default => false, :null => false
    t.boolean  "is_news",                                                      :null => false
    t.string   "teaser"
    t.integer  "missed_it_bucket_id"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.string   "twitter_handle"
  end

  add_index "blogs_blog", ["missed_it_bucket_id"], :name => "blogs_blog_d12628ce"
  add_index "blogs_blog", ["name"], :name => "name", :unique => true
  add_index "blogs_blog", ["slug"], :name => "slug", :unique => true

  create_table "blogs_blogauthor", :force => true do |t|
    t.integer  "blog_id",    :null => false
    t.integer  "author_id",  :null => false
    t.integer  "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "blogs_blogauthor", ["author_id"], :name => "blogs_blog_authors_64afdb51"
  add_index "blogs_blogauthor", ["blog_id", "author_id"], :name => "blogs_blog_authors_blog_id_579f20695740dd5e_uniq", :unique => true
  add_index "blogs_blogauthor", ["blog_id"], :name => "blogs_blog_authors_472bc96c"

  create_table "blogs_entry", :force => true do |t|
    t.string   "headline"
    t.string   "slug",              :limit => 50
    t.text     "body",              :limit => 2147483647
    t.integer  "blog_id"
    t.datetime "published_at"
    t.integer  "status",                                                     :null => false
    t.string   "blog_asset_scheme"
    t.string   "short_headline"
    t.text     "teaser",            :limit => 2147483647
    t.integer  "wp_id"
    t.integer  "dsq_thread_id"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
    t.integer  "category_id"
    t.boolean  "is_from_pij",                             :default => false, :null => false
  end

  add_index "blogs_entry", ["blog_id"], :name => "blogs_entry_blog_id"
  add_index "blogs_entry", ["category_id"], :name => "blogs_entry_42dc49bc"
  add_index "blogs_entry", ["status", "published_at"], :name => "index_blogs_entry_on_status_and_published_at"

  create_table "contentbase_category", :force => true do |t|
    t.string   "title"
    t.string   "slug",              :limit => 50
    t.boolean  "is_news",                         :default => true, :null => false
    t.integer  "comment_bucket_id"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  add_index "contentbase_category", ["comment_bucket_id"], :name => "contentbase_category_36c0cbca"
  add_index "contentbase_category", ["slug"], :name => "contentbase_category_a951d5d6"

  create_table "contentbase_contentalarm", :force => true do |t|
    t.integer  "content_id"
    t.datetime "fire_at"
    t.string   "content_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "contentbase_contentalarm", ["content_id"], :name => "index_contentbase_contentalarm_on_content_id"
  add_index "contentbase_contentalarm", ["content_type", "content_id"], :name => "index_contentbase_contentalarm_on_content_type_and_content_id"

  create_table "contentbase_contentbyline", :force => true do |t|
    t.integer  "content_id"
    t.integer  "user_id"
    t.string   "name",                        :null => false
    t.integer  "role",         :default => 0, :null => false
    t.string   "content_type"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "contentbase_contentbyline", ["content_id"], :name => "content_key"
  add_index "contentbase_contentbyline", ["content_id"], :name => "index_contentbase_contentbyline_on_content_id"
  add_index "contentbase_contentbyline", ["content_type", "content_id"], :name => "index_contentbase_contentbyline_on_content_type_and_content_id"
  add_index "contentbase_contentbyline", ["user_id"], :name => "contentbase_contentbyline_fbfc09f1"

  create_table "contentbase_contentshell", :force => true do |t|
    t.string   "headline"
    t.string   "site"
    t.text     "body",         :limit => 2147483647,                :null => false
    t.string   "url"
    t.integer  "status",                             :default => 0, :null => false
    t.datetime "published_at"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.integer  "category_id"
  end

  add_index "contentbase_contentshell", ["category_id"], :name => "contentbase_contentshell_42dc49bc"
  add_index "contentbase_contentshell", ["site"], :name => "index_contentbase_contentshell_on_site"
  add_index "contentbase_contentshell", ["status", "published_at"], :name => "index_contentbase_contentshell_on_status_and_published_at"

  create_table "contentbase_featuredcomment", :force => true do |t|
    t.integer  "bucket_id",                                         :null => false
    t.integer  "content_id"
    t.integer  "status",                             :default => 0, :null => false
    t.string   "username",                                          :null => false
    t.text     "excerpt",      :limit => 2147483647,                :null => false
    t.string   "content_type"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  add_index "contentbase_featuredcomment", ["bucket_id"], :name => "contentbase_featuredcomment_25ef9024"
  add_index "contentbase_featuredcomment", ["content_id"], :name => "index_contentbase_featuredcomment_on_content_id"
  add_index "contentbase_featuredcomment", ["content_type", "content_id"], :name => "index_contentbase_featuredcomment_on_content_type_and_content_id"
  add_index "contentbase_featuredcomment", ["status"], :name => "index_contentbase_featuredcomment_on_status"

  create_table "contentbase_featuredcommentbucket", :force => true do |t|
    t.string   "title",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contentbase_misseditbucket", :force => true do |t|
    t.string   "title",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contentbase_misseditcontent", :force => true do |t|
    t.integer  "bucket_id",                    :null => false
    t.integer  "content_id"
    t.integer  "position",     :default => 99, :null => false
    t.string   "content_type"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "contentbase_misseditcontent", ["bucket_id"], :name => "contentbase_misseditcontent_25ef9024"
  add_index "contentbase_misseditcontent", ["content_id"], :name => "index_contentbase_misseditcontent_on_content_id"
  add_index "contentbase_misseditcontent", ["content_type", "content_id"], :name => "index_contentbase_misseditcontent_on_content_type_and_content_id"

  create_table "data_points", :force => true do |t|
    t.string   "group_name"
    t.string   "data_key"
    t.string   "notes"
    t.text     "data_value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "title"
  end

  add_index "data_points", ["data_key"], :name => "index_data_points_on_data_key"
  add_index "data_points", ["group_name"], :name => "index_data_points_on_group"

  create_table "edition_slots", :force => true do |t|
    t.string   "item_type"
    t.integer  "item_id"
    t.integer  "edition_id"
    t.integer  "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "edition_slots", ["edition_id"], :name => "index_edition_slots_on_edition_id"
  add_index "edition_slots", ["item_type", "item_id"], :name => "index_edition_slots_on_item_type_and_item_id"
  add_index "edition_slots", ["position"], :name => "index_edition_slots_on_position"

  create_table "editions", :force => true do |t|
    t.integer  "status"
    t.datetime "published_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "editions", ["status", "published_at"], :name => "index_editions_on_status_and_published_at"

  create_table "events", :force => true do |t|
    t.string   "headline"
    t.string   "slug",                :limit => 50
    t.text     "body",                :limit => 2147483647
    t.string   "event_type"
    t.string   "sponsor"
    t.string   "sponsor_url"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "is_all_day",                                :default => false, :null => false
    t.string   "location_name"
    t.string   "location_url"
    t.string   "rsvp_url"
    t.boolean  "show_map",                                  :default => true,  :null => false
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.boolean  "is_kpcc_event",                             :default => false, :null => false
    t.text     "archive_description", :limit => 2147483647
    t.text     "teaser",              :limit => 2147483647
    t.string   "event_asset_scheme"
    t.integer  "kpcc_program_id"
    t.integer  "status",                                                       :null => false
    t.boolean  "is_from_pij"
    t.string   "hashtag"
  end

  add_index "events", ["event_type"], :name => "index_events_event_on_etype"
  add_index "events", ["kpcc_program_id"], :name => "events_event_7666a8c6"
  add_index "events", ["slug"], :name => "events_event_slug"
  add_index "events", ["starts_at", "ends_at"], :name => "index_events_event_on_starts_at_and_ends_at"
  add_index "events", ["status"], :name => "index_events_on_status"

  create_table "external_episode_segments", :force => true do |t|
    t.integer  "external_episode_id"
    t.integer  "external_segment_id"
    t.integer  "position"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "external_episode_segments", ["external_episode_id", "position"], :name => "external_episode_segments_episode_id_position"
  add_index "external_episode_segments", ["external_segment_id"], :name => "index_external_episode_segments_on_external_segment_id"

  create_table "external_episodes", :force => true do |t|
    t.string   "title"
    t.text     "summary"
    t.integer  "external_program_id"
    t.string   "external_id"
    t.datetime "air_date"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "external_episodes", ["air_date"], :name => "index_external_episodes_on_air_date"
  add_index "external_episodes", ["external_program_id", "external_id"], :name => "index_external_episodes_on_external_program_id_and_external_id"

  create_table "external_programs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.string   "title",                        :null => false
    t.text     "teaser"
    t.text     "description"
    t.string   "host"
    t.string   "organization",   :limit => 50
    t.string   "airtime"
    t.string   "air_status",                   :null => false
    t.string   "podcast_url"
    t.text     "sidebar"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "twitter_handle"
    t.string   "source"
    t.integer  "external_id"
  end

  add_index "external_programs", ["air_status"], :name => "index_external_programs_on_air_status"
  add_index "external_programs", ["slug"], :name => "index_external_programs_on_slug"
  add_index "external_programs", ["source", "external_id"], :name => "index_external_programs_on_source_and_external_id"
  add_index "external_programs", ["title"], :name => "index_external_programs_on_title"

  create_table "external_segments", :force => true do |t|
    t.string   "title"
    t.text     "teaser"
    t.integer  "external_program_id"
    t.string   "external_id"
    t.string   "external_url"
    t.datetime "published_at"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "external_segments", ["external_program_id", "external_id"], :name => "index_external_segments_on_external_program_id_and_external_id"
  add_index "external_segments", ["published_at"], :name => "index_external_segments_on_published_at"

  create_table "flatpages_flatpage", :force => true do |t|
    t.string   "url",          :limit => 100,                           :null => false
    t.string   "title",        :limit => 200,                           :null => false
    t.text     "content",      :limit => 2147483647,                    :null => false
    t.text     "extra_head",   :limit => 2147483647,                    :null => false
    t.text     "extra_tail",   :limit => 2147483647,                    :null => false
    t.datetime "updated_at"
    t.text     "description",  :limit => 2147483647,                    :null => false
    t.string   "redirect_url", :limit => 250
    t.boolean  "is_public",                          :default => false, :null => false
    t.datetime "created_at",                                            :null => false
    t.string   "template",     :limit => 10,                            :null => false
  end

  add_index "flatpages_flatpage", ["is_public"], :name => "index_flatpages_flatpage_on_is_public"
  add_index "flatpages_flatpage", ["url"], :name => "django_flatpage_url"

  create_table "layout_breakingnewsalert", :force => true do |t|
    t.string   "headline",                                                          :null => false
    t.string   "alert_type",                                                        :null => false
    t.boolean  "email_sent",                                     :default => false, :null => false
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
    t.text     "teaser",                   :limit => 2147483647,                    :null => false
    t.string   "alert_url",                :limit => 200,                           :null => false
    t.boolean  "send_email",                                     :default => false, :null => false
    t.boolean  "visible",                                                           :null => false
    t.boolean  "send_mobile_notification",                       :default => false, :null => false
    t.boolean  "mobile_notification_sent",                       :default => false, :null => false
    t.integer  "status"
    t.datetime "published_at"
  end

  add_index "layout_breakingnewsalert", ["status", "published_at"], :name => "index_layout_breakingnewsalert_on_status_and_published_at"
  add_index "layout_breakingnewsalert", ["visible"], :name => "index_layout_breakingnewsalert_on_visible"

  create_table "layout_homepage", :force => true do |t|
    t.string   "base"
    t.datetime "published_at"
    t.integer  "status",              :null => false
    t.integer  "missed_it_bucket_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "layout_homepage", ["missed_it_bucket_id"], :name => "layout_homepage_d12628ce"
  add_index "layout_homepage", ["status", "published_at"], :name => "index_layout_homepage_on_status_and_published_at"

  create_table "layout_homepagecontent", :force => true do |t|
    t.integer "homepage_id",                  :null => false
    t.integer "content_id"
    t.integer "position",     :default => 99, :null => false
    t.string  "content_type"
  end

  add_index "layout_homepagecontent", ["content_id"], :name => "index_layout_homepagecontent_on_content_id"
  add_index "layout_homepagecontent", ["content_type", "content_id"], :name => "index_layout_homepagecontent_on_content_type_and_content_id"
  add_index "layout_homepagecontent", ["homepage_id"], :name => "layout_homepagecontent_35da0e60"

  create_table "media_audio", :force => true do |t|
    t.integer  "size"
    t.integer  "duration"
    t.string   "enco_number"
    t.date     "enco_date"
    t.integer  "content_id"
    t.text     "description",  :limit => 2147483647
    t.string   "byline"
    t.integer  "position",                           :default => 0, :null => false
    t.string   "content_type"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.string   "external_url"
    t.string   "type"
    t.string   "mp3"
    t.integer  "status"
    t.string   "path"
  end

  add_index "media_audio", ["content_id"], :name => "index_media_audio_on_content_id"
  add_index "media_audio", ["content_id"], :name => "media_audio_content_type_id_569dcfe00f4d911"
  add_index "media_audio", ["content_type", "content_id"], :name => "index_media_audio_on_content_type_and_content_id"
  add_index "media_audio", ["mp3"], :name => "index_media_audio_on_mp3"
  add_index "media_audio", ["position"], :name => "index_media_audio_on_position"
  add_index "media_audio", ["status"], :name => "index_media_audio_on_status"
  add_index "media_audio", ["type"], :name => "index_media_audio_on_type"

  create_table "media_document", :force => true do |t|
    t.string   "document_file", :limit => 100,        :null => false
    t.string   "title",         :limit => 140,        :null => false
    t.text     "description",   :limit => 2147483647, :null => false
    t.string   "source",        :limit => 140,        :null => false
    t.datetime "uploaded_at",                         :null => false
  end

  create_table "media_image", :force => true do |t|
    t.text     "caption",    :limit => 2147483647, :null => false
    t.string   "credit",     :limit => 150,        :null => false
    t.datetime "created_at",                       :null => false
  end

  create_table "media_imageinstance", :force => true do |t|
    t.string  "image_file",     :limit => 100, :null => false
    t.string  "image_type",     :limit => 10,  :null => false
    t.integer "instance_of_id",                :null => false
  end

  add_index "media_imageinstance", ["instance_of_id"], :name => "media_imageinstance_29b6bd08"

  create_table "media_related", :force => true do |t|
    t.integer "content_id",                  :null => false
    t.integer "related_id",                  :null => false
    t.string  "content_type"
    t.string  "related_type"
    t.integer "position",     :default => 0, :null => false
  end

  add_index "media_related", ["content_id"], :name => "index_media_related_on_content_id"
  add_index "media_related", ["content_type", "content_id"], :name => "index_media_related_on_content_type_and_content_id"
  add_index "media_related", ["related_id"], :name => "index_media_related_on_related_id"
  add_index "media_related", ["related_type", "related_id"], :name => "index_media_related_on_related_type_and_related_id"

  create_table "news_story", :force => true do |t|
    t.string   "headline"
    t.string   "slug",               :limit => 50
    t.string   "news_agency"
    t.text     "teaser",             :limit => 2147483647
    t.text     "body",               :limit => 2147483647
    t.datetime "published_at"
    t.string   "source"
    t.string   "story_asset_scheme"
    t.string   "extra_asset_scheme"
    t.integer  "status",                                                      :null => false
    t.string   "short_headline"
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
    t.integer  "category_id"
    t.boolean  "is_from_pij",                              :default => false, :null => false
  end

  add_index "news_story", ["category_id"], :name => "news_story_42dc49bc"
  add_index "news_story", ["published_at"], :name => "news_story_published_at"
  add_index "news_story", ["status", "published_at"], :name => "index_news_story_on_status_and_published_at"

  create_table "permissions", :force => true do |t|
    t.string   "resource"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "permissions", ["resource"], :name => "index_permissions_on_resource_and_action"

  create_table "pij_query", :force => true do |t|
    t.string   "slug",         :limit => 50
    t.string   "headline"
    t.text     "teaser",       :limit => 2147483647
    t.text     "body",         :limit => 2147483647
    t.string   "query_type"
    t.datetime "published_at"
    t.boolean  "is_featured",                        :default => false, :null => false
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "pin_query_id"
    t.integer  "status"
  end

  add_index "pij_query", ["is_featured"], :name => "index_pij_query_on_is_featured"
  add_index "pij_query", ["published_at"], :name => "index_pij_query_on_is_active_and_published_at"
  add_index "pij_query", ["query_type"], :name => "index_pij_query_on_query_type"
  add_index "pij_query", ["slug"], :name => "slug", :unique => true
  add_index "pij_query", ["status"], :name => "index_pij_query_on_status"

  create_table "podcasts", :force => true do |t|
    t.string   "slug"
    t.string   "title"
    t.string   "url"
    t.string   "podcast_url"
    t.string   "itunes_url"
    t.text     "description"
    t.string   "image_url"
    t.string   "author"
    t.string   "keywords"
    t.string   "duration"
    t.boolean  "is_listed",   :default => false, :null => false
    t.integer  "source_id"
    t.integer  "category_id"
    t.string   "item_type"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "source_type"
  end

  add_index "podcasts", ["category_id"], :name => "podcasts_podcast_42dc49bc"
  add_index "podcasts", ["slug"], :name => "slug", :unique => true
  add_index "podcasts", ["source_id"], :name => "podcasts_podcast_7eef53e3"

  create_table "press_releases", :force => true do |t|
    t.string   "short_title"
    t.string   "slug"
    t.string   "title"
    t.text     "body",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "press_releases", ["slug"], :name => "press_releases_release_slug"

  create_table "programs_kpccprogram", :force => true do |t|
    t.string   "slug",                                   :null => false
    t.string   "title",                                  :null => false
    t.text     "teaser"
    t.text     "description"
    t.string   "host"
    t.string   "airtime"
    t.string   "air_status",                             :null => false
    t.string   "twitter_handle"
    t.text     "sidebar"
    t.boolean  "display_episodes",    :default => true,  :null => false
    t.boolean  "display_segments",    :default => true,  :null => false
    t.integer  "blog_id"
    t.string   "audio_dir"
    t.integer  "missed_it_bucket_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "image"
    t.boolean  "is_featured",         :default => false, :null => false
  end

  add_index "programs_kpccprogram", ["air_status"], :name => "index_programs_kpccprogram_on_air_status"
  add_index "programs_kpccprogram", ["blog_id"], :name => "programs_kpccprogram_472bc96c"
  add_index "programs_kpccprogram", ["is_featured"], :name => "index_programs_kpccprogram_on_is_featured"
  add_index "programs_kpccprogram", ["missed_it_bucket_id"], :name => "programs_kpccprogram_d12628ce"
  add_index "programs_kpccprogram", ["slug"], :name => "index_programs_kpccprogram_on_slug"

  create_table "recurring_schedule_rules", :force => true do |t|
    t.text     "schedule_hash"
    t.integer  "interval"
    t.string   "days"
    t.string   "start_time"
    t.string   "end_time"
    t.integer  "program_id"
    t.string   "program_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "recurring_schedule_rules", ["program_type", "program_id"], :name => "index_recurring_schedule_rules_on_program_type_and_program_id"

  create_table "related_links", :force => true do |t|
    t.string   "title",        :default => ""
    t.string   "url"
    t.string   "link_type"
    t.integer  "content_id"
    t.string   "content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "related_links", ["content_type", "content_id"], :name => "index_media_link_on_content_type_and_content_id"
  add_index "related_links", ["link_type"], :name => "index_related_links_on_link_type"

  create_table "remote_articles", :force => true do |t|
    t.string   "headline"
    t.text     "teaser",       :limit => 2147483647
    t.datetime "published_at"
    t.string   "url",          :limit => 200
    t.string   "article_id"
    t.boolean  "is_new",                             :default => true, :null => false
    t.string   "source"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  add_index "remote_articles", ["source", "article_id"], :name => "index_remote_articles_on_source_and_article_id"

  create_table "schedule_occurrences", :force => true do |t|
    t.string   "event_title"
    t.string   "info_url"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer  "program_id"
    t.string   "program_type"
    t.integer  "recurring_schedule_rule_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "schedule_occurrences", ["program_type", "program_id"], :name => "index_schedule_occurrences_on_program_type_and_program_id"
  add_index "schedule_occurrences", ["recurring_schedule_rule_id"], :name => "index_schedule_occurrences_on_recurring_schedule_rule_id"
  add_index "schedule_occurrences", ["starts_at", "ends_at"], :name => "index_schedule_occurrences_on_starts_at_and_ends_at"

  create_table "shows_episode", :force => true do |t|
    t.integer  "show_id",                            :null => false
    t.datetime "air_date"
    t.string   "headline"
    t.text     "body",         :limit => 2147483647
    t.datetime "published_at"
    t.integer  "status",                             :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "shows_episode", ["show_id"], :name => "shows_episode_show_id"
  add_index "shows_episode", ["status", "published_at"], :name => "index_shows_episode_on_status_and_published_at"

  create_table "shows_rundown", :force => true do |t|
    t.integer "episode_id", :null => false
    t.integer "segment_id", :null => false
    t.integer "position",   :null => false
  end

  add_index "shows_rundown", ["episode_id"], :name => "shows_rundown_episode_id"
  add_index "shows_rundown", ["position"], :name => "index_shows_rundown_on_segment_order"
  add_index "shows_rundown", ["segment_id"], :name => "shows_rundown_segment_id"

  create_table "shows_segment", :force => true do |t|
    t.integer  "show_id",                                    :null => false
    t.string   "headline"
    t.string   "slug",                 :limit => 50
    t.text     "teaser",               :limit => 2147483647
    t.text     "body",                 :limit => 2147483647
    t.datetime "created_at",                                 :null => false
    t.integer  "status",                                     :null => false
    t.string   "segment_asset_scheme"
    t.string   "short_headline"
    t.datetime "published_at"
    t.datetime "updated_at",                                 :null => false
    t.integer  "category_id"
    t.boolean  "is_from_pij"
  end

  add_index "shows_segment", ["category_id"], :name => "shows_segment_42dc49bc"
  add_index "shows_segment", ["show_id"], :name => "shows_segment_show_id"
  add_index "shows_segment", ["slug"], :name => "shows_segment_slug"
  add_index "shows_segment", ["status", "published_at"], :name => "index_shows_segment_on_status_and_published_at"

  create_table "taggit_tag", :force => true do |t|
    t.string  "name",  :limit => 100, :null => false
    t.string  "slug",  :limit => 100, :null => false
    t.integer "wp_id"
  end

  add_index "taggit_tag", ["slug"], :name => "slug", :unique => true

  create_table "taggit_taggeditem", :force => true do |t|
    t.integer "tag_id",                                                        :null => false
    t.integer "content_id",                                                    :null => false
    t.integer "django_content_type_id"
    t.string  "content_type",           :limit => 20, :default => "BlogEntry"
  end

  add_index "taggit_taggeditem", ["content_id"], :name => "index_taggit_taggeditem_on_content_id"
  add_index "taggit_taggeditem", ["content_id"], :name => "taggit_taggeditem_829e37fd"
  add_index "taggit_taggeditem", ["content_type", "content_id"], :name => "index_taggit_taggeditem_on_content_type_and_content_id"
  add_index "taggit_taggeditem", ["django_content_type_id"], :name => "taggit_taggeditem_e4470c6e"
  add_index "taggit_taggeditem", ["tag_id"], :name => "taggit_taggeditem_3747b463"

  create_table "tickets", :force => true do |t|
    t.integer  "user_id"
    t.string   "browser_info"
    t.string   "link"
    t.string   "summary"
    t.text     "description"
    t.integer  "status",       :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "tickets", ["status"], :name => "index_tickets_on_status"
  add_index "tickets", ["user_id"], :name => "index_tickets_on_user_id"

  create_table "user_permissions", :force => true do |t|
    t.integer  "admin_user_id"
    t.integer  "permission_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "user_permissions", ["admin_user_id"], :name => "index_admin_user_permissions_on_admin_user_id"
  add_index "user_permissions", ["permission_id"], :name => "index_admin_user_permissions_on_permission_id"

  create_table "users_userprofile", :force => true do |t|
    t.integer  "userid",                    :null => false
    t.string   "nickname",   :limit => 50,  :null => false
    t.string   "firstname",  :limit => 50
    t.string   "lastname",   :limit => 50
    t.string   "location",   :limit => 120
    t.string   "image_file", :limit => 100
    t.string   "email",      :limit => 75
    t.datetime "last_login"
  end

  add_index "users_userprofile", ["nickname"], :name => "nickname", :unique => true
  add_index "users_userprofile", ["userid"], :name => "userid", :unique => true

  create_table "versions", :force => true do |t|
    t.integer  "version_number"
    t.string   "versioned_type"
    t.integer  "versioned_id"
    t.string   "user_id"
    t.text     "description"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["user_id"], :name => "index_versions_on_user_id"
  add_index "versions", ["version_number"], :name => "index_versions_on_version_number"
  add_index "versions", ["versioned_type", "versioned_id"], :name => "index_versions_on_versioned_type_and_versioned_id"

end
