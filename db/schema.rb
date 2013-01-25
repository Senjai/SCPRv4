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

ActiveRecord::Schema.define(:version => 20130125010349) do

  create_table "about_town_feature", :force => true do |t|
    t.string   "slug",          :limit => 50,         :null => false
    t.string   "title",         :limit => 140,        :null => false
    t.text     "body",          :limit => 2147483647, :null => false
    t.string   "thumbnail",     :limit => 100,        :null => false
    t.string   "author",        :limit => 80,         :null => false
    t.string   "author_link",   :limit => 200,        :null => false
    t.string   "categories",    :limit => 180,        :null => false
    t.string   "location_name", :limit => 140,        :null => false
    t.string   "location_link", :limit => 200,        :null => false
    t.string   "address_1",     :limit => 140,        :null => false
    t.string   "address_2",     :limit => 140,        :null => false
    t.string   "city",          :limit => 140,        :null => false
    t.string   "state",         :limit => 2,          :null => false
    t.integer  "zip_code",                            :null => false
    t.datetime "published_at",                        :null => false
  end

  add_index "about_town_feature", ["slug"], :name => "about_town_feature_slug"

  create_table "admin_user_permissions", :force => true do |t|
    t.integer  "admin_user_id"
    t.integer  "permission_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "admin_user_permissions", ["admin_user_id"], :name => "index_admin_user_permissions_on_admin_user_id"
  add_index "admin_user_permissions", ["permission_id"], :name => "index_admin_user_permissions_on_permission_id"

  create_table "ascertainment_ascertainmentrecord", :force => true do |t|
    t.integer "django_content_type_id"
    t.integer "content_id",                            :null => false
    t.string  "locations",              :limit => 200
    t.string  "asc_types",              :limit => 200
    t.string  "verticals",              :limit => 200
    t.string  "content_type",           :limit => 20
  end

  add_index "ascertainment_ascertainmentrecord", ["django_content_type_id"], :name => "ascertainment_ascertainmentrecord_e4470c6e"

  create_table "assethost_contentasset", :force => true do |t|
    t.integer "django_content_type_id"
    t.integer "content_id",                                                   :null => false
    t.integer "asset_order",                                  :default => 99, :null => false
    t.integer "asset_id",                                                     :null => false
    t.text    "caption",                :limit => 2147483647,                 :null => false
    t.string  "content_type",           :limit => 20
  end

  add_index "assethost_contentasset", ["asset_order"], :name => "index_assethost_contentasset_on_asset_order"
  add_index "assethost_contentasset", ["content_id"], :name => "index_assethost_contentasset_on_content_id"
  add_index "assethost_contentasset", ["content_type", "content_id"], :name => "index_assethost_contentasset_on_content_type_and_content_id"
  add_index "assethost_contentasset", ["django_content_type_id", "content_id"], :name => "content_type_id"
  add_index "assethost_contentasset", ["django_content_type_id"], :name => "assethost_contentasset_e4470c6e"

  create_table "auth_group", :force => true do |t|
    t.string "name", :limit => 80, :null => false
  end

  add_index "auth_group", ["name"], :name => "name", :unique => true

  create_table "auth_group_permissions", :force => true do |t|
    t.integer "group_id",      :null => false
    t.integer "permission_id", :null => false
  end

  add_index "auth_group_permissions", ["group_id", "permission_id"], :name => "group_id", :unique => true
  add_index "auth_group_permissions", ["permission_id"], :name => "permission_id_refs_id_4de83ca7792de1"

  create_table "auth_message", :force => true do |t|
    t.integer "user_id",                       :null => false
    t.text    "message", :limit => 2147483647, :null => false
  end

  add_index "auth_message", ["user_id"], :name => "auth_message_user_id"

  create_table "auth_permission", :force => true do |t|
    t.string  "name",            :limit => 50,  :null => false
    t.integer "content_type_id",                :null => false
    t.string  "codename",        :limit => 100, :null => false
  end

  add_index "auth_permission", ["content_type_id", "codename"], :name => "content_type_id", :unique => true
  add_index "auth_permission", ["content_type_id"], :name => "auth_permission_content_type_id"

  create_table "auth_user", :force => true do |t|
    t.string   "username",     :limit => 30,  :null => false
    t.string   "first_name",   :limit => 30,  :null => false
    t.string   "last_name",    :limit => 30,  :null => false
    t.string   "email",        :limit => 75,  :null => false
    t.string   "password",     :limit => 128, :null => false
    t.boolean  "is_staff",                    :null => false
    t.boolean  "is_active",                   :null => false
    t.boolean  "is_superuser",                :null => false
    t.datetime "last_login",                  :null => false
    t.datetime "date_joined",                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "auth_user", ["username"], :name => "username", :unique => true

  create_table "auth_user_groups", :force => true do |t|
    t.integer "user_id",  :null => false
    t.integer "group_id", :null => false
  end

  add_index "auth_user_groups", ["group_id"], :name => "group_id_refs_id_321a8efef0ee9890"
  add_index "auth_user_groups", ["user_id", "group_id"], :name => "user_id", :unique => true

  create_table "auth_user_user_permissions", :force => true do |t|
    t.integer "user_id",       :null => false
    t.integer "permission_id", :null => false
  end

  add_index "auth_user_user_permissions", ["permission_id"], :name => "permission_id_refs_id_6d7fb3c2067e79cb"
  add_index "auth_user_user_permissions", ["user_id", "permission_id"], :name => "user_id", :unique => true

  create_table "bios_bio", :force => true do |t|
    t.integer  "user_id"
    t.string   "slug",         :limit => 50
    t.text     "bio",          :limit => 2147483647
    t.string   "title"
    t.boolean  "is_public",                          :default => false, :null => false
    t.string   "feed_url",     :limit => 200
    t.string   "twitter"
    t.integer  "asset_id"
    t.string   "short_bio"
    t.string   "phone_number"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "last_name"
  end

  add_index "bios_bio", ["is_public", "last_name"], :name => "index_bios_bio_on_is_public_and_last_name"
  add_index "bios_bio", ["is_public"], :name => "index_bios_bio_on_is_public"
  add_index "bios_bio", ["last_name"], :name => "index_bios_bio_on_last_name"
  add_index "bios_bio", ["slug"], :name => "index_bios_bio_on_slug"
  add_index "bios_bio", ["user_id"], :name => "user_id_refs_id_1277bd7cd84326f2"

  create_table "blogs_blog", :force => true do |t|
    t.string   "name"
    t.string   "slug",                :limit => 50
    t.text     "description",         :limit => 2147483647
    t.boolean  "is_active",                                 :default => false, :null => false
    t.string   "feed_url",            :limit => 200
    t.boolean  "is_remote",                                                    :null => false
    t.string   "custom_url",          :limit => 200
    t.boolean  "is_news",                                                      :null => false
    t.string   "teaser"
    t.integer  "missed_it_bucket_id"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
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

  create_table "blogs_blogcategory", :force => true do |t|
    t.integer  "blog_id",                                                     :null => false
    t.string   "title"
    t.string   "slug",       :limit => 50
    t.datetime "created_at",               :default => '2012-06-08 02:03:41', :null => false
    t.datetime "updated_at",               :default => '2012-06-08 02:03:41', :null => false
    t.integer  "wp_id"
  end

  add_index "blogs_blogcategory", ["blog_id"], :name => "blogs_blogcategory_472bc96c"
  add_index "blogs_blogcategory", ["slug"], :name => "blogs_blogcategory_a951d5d6"

  create_table "blogs_entry", :force => true do |t|
    t.string   "headline"
    t.string   "slug",              :limit => 50
    t.text     "body",              :limit => 2147483647
    t.integer  "blog_id",                                                    :null => false
    t.datetime "published_at"
    t.integer  "status"
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

  create_table "blogs_entryblogcategory", :force => true do |t|
    t.integer  "entry_id",                                            :null => false
    t.integer  "blog_category_id",                                    :null => false
    t.boolean  "is_primary",       :default => false,                 :null => false
    t.datetime "created_at",       :default => '2012-06-08 02:03:41', :null => false
    t.datetime "updated_at",       :default => '2012-06-08 02:03:41', :null => false
  end

  add_index "blogs_entryblogcategory", ["blog_category_id"], :name => "blogs_entryblogcategory_c81f43a6"
  add_index "blogs_entryblogcategory", ["entry_id"], :name => "blogs_entryblogcategory_38a62041"

  create_table "blogs_entrycategories", :force => true do |t|
    t.integer "entry_id",    :null => false
    t.integer "category_id", :null => false
    t.boolean "is_primary",  :null => false
  end

  add_index "blogs_entrycategories", ["category_id"], :name => "blogs_entrycategories_category_id"
  add_index "blogs_entrycategories", ["entry_id"], :name => "blogs_entrycategories_entry_id"

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
    t.integer  "django_content_type_id"
    t.integer  "content_id",                           :null => false
    t.datetime "fire_at"
    t.string   "content_type",           :limit => 20
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "contentbase_contentalarm", ["content_id"], :name => "index_contentbase_contentalarm_on_content_id"
  add_index "contentbase_contentalarm", ["content_type", "content_id"], :name => "index_contentbase_contentalarm_on_content_type_and_content_id"
  add_index "contentbase_contentalarm", ["django_content_type_id"], :name => "contentbase_contentalarm_e4470c6e"

  create_table "contentbase_contentbyline", :force => true do |t|
    t.integer  "django_content_type_id"
    t.integer  "content_id",                                          :null => false
    t.integer  "user_id"
    t.string   "name",                   :limit => 50,                :null => false
    t.integer  "role",                                 :default => 0, :null => false
    t.string   "content_type",           :limit => 20
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
  end

  add_index "contentbase_contentbyline", ["content_id"], :name => "index_contentbase_contentbyline_on_content_id"
  add_index "contentbase_contentbyline", ["content_type", "content_id"], :name => "index_contentbase_contentbyline_on_content_type_and_content_id"
  add_index "contentbase_contentbyline", ["django_content_type_id", "content_id"], :name => "content_key"
  add_index "contentbase_contentbyline", ["django_content_type_id"], :name => "contentbase_contentbyline_e4470c6e"
  add_index "contentbase_contentbyline", ["user_id"], :name => "contentbase_contentbyline_fbfc09f1"

  create_table "contentbase_contentcategory", :force => true do |t|
    t.integer  "category_id",                          :null => false
    t.integer  "django_content_type_id"
    t.integer  "content_id",                           :null => false
    t.string   "content_type",           :limit => 20
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "contentbase_contentcategory", ["category_id"], :name => "contentbase_contentcategory_42dc49bc"
  add_index "contentbase_contentcategory", ["content_id"], :name => "index_contentbase_contentcategory_on_content_id"
  add_index "contentbase_contentcategory", ["content_type", "content_id"], :name => "index_contentbase_contentcategory_on_content_type_and_content_id"
  add_index "contentbase_contentcategory", ["django_content_type_id", "content_id"], :name => "content_key", :unique => true
  add_index "contentbase_contentcategory", ["django_content_type_id"], :name => "contentbase_contentcategory_e4470c6e"

  create_table "contentbase_contentshell", :force => true do |t|
    t.string   "headline",     :limit => 200,                            :null => false
    t.string   "site",         :limit => 50,         :default => "KPCC", :null => false
    t.text     "body",         :limit => 2147483647,                     :null => false
    t.string   "url",          :limit => 150,                            :null => false
    t.integer  "status",                             :default => 0,      :null => false
    t.datetime "published_at"
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.integer  "category_id"
  end

  add_index "contentbase_contentshell", ["category_id"], :name => "contentbase_contentshell_42dc49bc"
  add_index "contentbase_contentshell", ["status", "published_at"], :name => "index_contentbase_contentshell_on_status_and_published_at"

  create_table "contentbase_featuredcomment", :force => true do |t|
    t.integer  "bucket_id",                                                   :null => false
    t.integer  "django_content_type_id"
    t.integer  "content_id",                                                  :null => false
    t.integer  "status",                                       :default => 0, :null => false
    t.datetime "published_at"
    t.string   "username",               :limit => 50,                        :null => false
    t.text     "excerpt",                :limit => 2147483647,                :null => false
    t.string   "content_type",           :limit => 20
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
  end

  add_index "contentbase_featuredcomment", ["bucket_id"], :name => "contentbase_featuredcomment_25ef9024"
  add_index "contentbase_featuredcomment", ["content_id"], :name => "index_contentbase_featuredcomment_on_content_id"
  add_index "contentbase_featuredcomment", ["content_type", "content_id"], :name => "index_contentbase_featuredcomment_on_content_type_and_content_id"
  add_index "contentbase_featuredcomment", ["django_content_type_id"], :name => "contentbase_featuredcomment_e4470c6e"

  create_table "contentbase_featuredcommentbucket", :force => true do |t|
    t.string   "title",      :limit => 50, :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "contentbase_misseditbucket", :force => true do |t|
    t.string   "title",      :limit => 50, :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "contentbase_misseditcontent", :force => true do |t|
    t.integer  "bucket_id",                                            :null => false
    t.integer  "django_content_type_id"
    t.integer  "content_id",                                           :null => false
    t.integer  "position",                             :default => 99, :null => false
    t.string   "content_type",           :limit => 20
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  add_index "contentbase_misseditcontent", ["bucket_id"], :name => "contentbase_misseditcontent_25ef9024"
  add_index "contentbase_misseditcontent", ["content_id"], :name => "index_contentbase_misseditcontent_on_content_id"
  add_index "contentbase_misseditcontent", ["content_type", "content_id"], :name => "index_contentbase_misseditcontent_on_content_type_and_content_id"
  add_index "contentbase_misseditcontent", ["django_content_type_id"], :name => "contentbase_misseditcontent_e4470c6e"

  create_table "contentbase_videoshell", :force => true do |t|
    t.string   "headline",     :limit => 200,                                           :null => false
    t.text     "body",         :limit => 2147483647,                                    :null => false
    t.integer  "status",                             :default => 0,                     :null => false
    t.datetime "published_at",                       :default => '2012-03-02 15:14:07', :null => false
    t.string   "slug",         :limit => 50,                                            :null => false
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
    t.integer  "category_id"
  end

  add_index "contentbase_videoshell", ["category_id"], :name => "contentbase_videoshell_42dc49bc"
  add_index "contentbase_videoshell", ["slug"], :name => "contentbase_videoshell_a951d5d6"
  add_index "contentbase_videoshell", ["status", "published_at"], :name => "index_contentbase_videoshell_on_status_and_published_at"

  create_table "data_points", :force => true do |t|
    t.string   "group_name"
    t.string   "data_key"
    t.string   "notes"
    t.text     "data_value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "data_points", ["data_key"], :name => "index_data_points_on_data_key"
  add_index "data_points", ["group_name"], :name => "index_data_points_on_group"

  create_table "distinct_schedule_slots", :force => true do |t|
    t.string   "title"
    t.string   "info_url"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "distinct_schedule_slots", ["ends_at"], :name => "index_distinct_schedule_slots_on_ends_at"
  add_index "distinct_schedule_slots", ["starts_at"], :name => "index_distinct_schedule_slots_on_starts_at"

  create_table "django_admin_log", :force => true do |t|
    t.datetime "action_time",                           :null => false
    t.integer  "user_id",                               :null => false
    t.integer  "content_type_id"
    t.text     "object_id",       :limit => 2147483647
    t.string   "object_repr",     :limit => 200,        :null => false
    t.integer  "action_flag",     :limit => 2,          :null => false
    t.text     "change_message",  :limit => 2147483647, :null => false
  end

  add_index "django_admin_log", ["content_type_id"], :name => "django_admin_log_content_type_id"
  add_index "django_admin_log", ["user_id"], :name => "django_admin_log_user_id"

  create_table "django_content_type", :force => true do |t|
    t.string "name",      :limit => 100, :null => false
    t.string "app_label", :limit => 100, :null => false
    t.string "model",     :limit => 100, :null => false
  end

  add_index "django_content_type", ["app_label", "model"], :name => "app_label", :unique => true

  create_table "django_session", :primary_key => "session_key", :force => true do |t|
    t.text     "session_data", :limit => 2147483647, :null => false
    t.datetime "expire_date",                        :null => false
  end

  create_table "events_event", :force => true do |t|
    t.string   "headline"
    t.string   "slug",                :limit => 50
    t.text     "body",                :limit => 2147483647
    t.string   "etype"
    t.string   "sponsor"
    t.string   "sponsor_link",        :limit => 200
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "is_all_day",                                :default => false, :null => false
    t.string   "location_name"
    t.string   "location_link",       :limit => 200
    t.string   "rsvp_link",           :limit => 200
    t.boolean  "show_map",                                  :default => true,  :null => false
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.boolean  "kpcc_event",                                :default => false, :null => false
    t.text     "archive_description", :limit => 2147483647
    t.string   "old_audio",           :limit => 100
    t.boolean  "is_published",                              :default => false, :null => false
    t.boolean  "show_comments",                             :default => false, :null => false
    t.text     "teaser",              :limit => 2147483647
    t.string   "event_asset_scheme"
    t.integer  "kpcc_program_id"
  end

  add_index "events_event", ["etype"], :name => "index_events_event_on_etype"
  add_index "events_event", ["kpcc_program_id"], :name => "events_event_7666a8c6"
  add_index "events_event", ["slug"], :name => "events_event_slug"
  add_index "events_event", ["starts_at", "ends_at"], :name => "index_events_event_on_starts_at_and_ends_at"

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

  create_table "jobs_department", :force => true do |t|
    t.string "slug",       :limit => 150, :null => false
    t.string "name",       :limit => 150, :null => false
    t.float  "dept_total",                :null => false
  end

  add_index "jobs_department", ["slug"], :name => "slug", :unique => true

  create_table "jobs_employee", :force => true do |t|
    t.string  "job_title",     :limit => 150, :null => false
    t.float   "salary",                       :null => false
    t.integer "department_id",                :null => false
    t.string  "dept_name",     :limit => 150, :null => false
    t.string  "dept_slug",     :limit => 150, :null => false
  end

  add_index "jobs_employee", ["department_id"], :name => "jobs_employee_2ae7390"

  create_table "layout_breakingnewsalert", :force => true do |t|
    t.string   "headline",     :limit => 140,                           :null => false
    t.time     "alert_time"
    t.string   "alert_type",   :limit => 5,                             :null => false
    t.boolean  "is_published",                       :default => true,  :null => false
    t.boolean  "email_sent",                         :default => false, :null => false
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.text     "teaser",       :limit => 2147483647,                    :null => false
    t.string   "alert_link",   :limit => 200,                           :null => false
    t.boolean  "send_email",                                            :null => false
    t.boolean  "visible",                                               :null => false
  end

  add_index "layout_breakingnewsalert", ["is_published"], :name => "index_layout_breakingnewsalert_on_is_published"
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
    t.integer "homepage_id",                                          :null => false
    t.integer "django_content_type_id"
    t.integer "content_id",                                           :null => false
    t.integer "position",                             :default => 99, :null => false
    t.string  "content_type",           :limit => 20
  end

  add_index "layout_homepagecontent", ["content_id"], :name => "index_layout_homepagecontent_on_content_id"
  add_index "layout_homepagecontent", ["content_type", "content_id"], :name => "index_layout_homepagecontent_on_content_type_and_content_id"
  add_index "layout_homepagecontent", ["django_content_type_id"], :name => "layout_homepagecontent_e4470c6e"
  add_index "layout_homepagecontent", ["homepage_id"], :name => "layout_homepagecontent_35da0e60"

  create_table "letters_letter", :force => true do |t|
    t.integer "letter_number",                                :null => false
    t.integer "original_letter_number",                       :null => false
    t.text    "description",            :limit => 2147483647, :null => false
    t.integer "total_pages"
  end

  create_table "letters_page", :force => true do |t|
    t.integer "letter_id",                    :null => false
    t.integer "letter_number",                :null => false
    t.integer "total_letters",                :null => false
    t.integer "page_number",                  :null => false
    t.integer "total_pages"
    t.string  "full_url",      :limit => 350, :null => false
    t.string  "viewer_url",    :limit => 350, :null => false
    t.string  "thumb_url",     :limit => 350, :null => false
  end

  add_index "letters_page", ["letter_id"], :name => "letters_page_letter_id"

  create_table "media_audio", :force => true do |t|
    t.string   "django_mp3"
    t.integer  "size"
    t.integer  "duration"
    t.string   "enco_number"
    t.date     "enco_date"
    t.integer  "django_content_type_id"
    t.integer  "content_id",                                                  :null => false
    t.text     "description",            :limit => 2147483647
    t.string   "byline"
    t.integer  "position",                                     :default => 0, :null => false
    t.string   "content_type"
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
    t.string   "filename"
    t.string   "store_dir"
    t.string   "mp3_path"
    t.string   "type"
    t.string   "mp3"
  end

  add_index "media_audio", ["content_id"], :name => "index_media_audio_on_content_id"
  add_index "media_audio", ["content_type", "content_id"], :name => "index_media_audio_on_content_type_and_content_id"
  add_index "media_audio", ["django_content_type_id", "content_id"], :name => "media_audio_content_type_id_569dcfe00f4d911"
  add_index "media_audio", ["django_content_type_id"], :name => "media_audio_e4470c6e"
  add_index "media_audio", ["mp3"], :name => "index_media_audio_on_mp3"
  add_index "media_audio", ["position"], :name => "index_media_audio_on_position"

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

  create_table "media_link", :force => true do |t|
    t.string  "title",                  :limit => 150, :default => "", :null => false
    t.string  "link",                   :limit => 300,                 :null => false
    t.string  "link_type",              :limit => 10,                  :null => false
    t.string  "sort_order",             :limit => 2,   :default => "", :null => false
    t.integer "django_content_type_id"
    t.integer "content_id",                                            :null => false
    t.string  "content_type",           :limit => 20
  end

  add_index "media_link", ["content_id"], :name => "index_media_link_on_content_id"
  add_index "media_link", ["content_type", "content_id"], :name => "index_media_link_on_content_type_and_content_id"
  add_index "media_link", ["django_content_type_id", "content_id"], :name => "media_link_content_type_id_41947a9a86b99b7a"
  add_index "media_link", ["django_content_type_id"], :name => "media_link_content_type_id"
  add_index "media_link", ["sort_order"], :name => "index_media_link_on_sort_order"

  create_table "media_related", :force => true do |t|
    t.integer "django_content_type_id"
    t.integer "content_id",                                              :null => false
    t.integer "rel_django_content_type_id"
    t.integer "related_id",                                              :null => false
    t.string  "content_type",               :limit => 20
    t.string  "related_type",               :limit => 20
    t.integer "position",                                 :default => 0, :null => false
  end

  add_index "media_related", ["content_id"], :name => "index_media_related_on_content_id"
  add_index "media_related", ["content_type", "content_id"], :name => "index_media_related_on_content_type_and_content_id"
  add_index "media_related", ["django_content_type_id"], :name => "media_related_e4470c6e"
  add_index "media_related", ["rel_django_content_type_id"], :name => "media_related_76fb6e42"
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
    t.string   "lead_asset_scheme",  :limit => 10
    t.integer  "status"
    t.string   "short_headline"
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
    t.integer  "category_id"
    t.boolean  "is_from_pij",                              :default => false, :null => false
  end

  add_index "news_story", ["category_id"], :name => "news_story_42dc49bc"
  add_index "news_story", ["published_at"], :name => "news_story_published_at"
  add_index "news_story", ["status", "published_at"], :name => "index_news_story_on_status_and_published_at"

  create_table "npr_npr_story", :force => true do |t|
    t.string   "headline",     :limit => 140,        :null => false
    t.text     "teaser",       :limit => 2147483647, :null => false
    t.datetime "published_at",                       :null => false
    t.string   "link",         :limit => 200,        :null => false
    t.string   "npr_id",       :limit => 20,         :null => false
    t.boolean  "new",                                :null => false
  end

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
    t.integer  "form_height"
    t.string   "query_url",    :limit => 200
    t.boolean  "is_active",                          :default => false, :null => false
    t.datetime "published_at"
    t.datetime "expires_at"
    t.boolean  "is_featured",                        :default => false, :null => false
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
  end

  add_index "pij_query", ["is_active", "published_at"], :name => "index_pij_query_on_is_active_and_published_at"
  add_index "pij_query", ["is_featured"], :name => "index_pij_query_on_is_featured"
  add_index "pij_query", ["query_type"], :name => "index_pij_query_on_query_type"
  add_index "pij_query", ["slug"], :name => "slug", :unique => true

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
    t.string   "slug",                :limit => 40,                           :null => false
    t.string   "title",               :limit => 60,                           :null => false
    t.text     "teaser",              :limit => 2147483647
    t.text     "description",         :limit => 2147483647
    t.string   "host",                :limit => 150
    t.string   "airtime",             :limit => 300
    t.string   "air_status",          :limit => 10,                           :null => false
    t.string   "podcast_url",         :limit => 200
    t.string   "rss_url",             :limit => 200
    t.string   "twitter_url",         :limit => 300
    t.string   "facebook_url",        :limit => 200
    t.text     "sidebar",             :limit => 2147483647
    t.boolean  "display_episodes",                          :default => true, :null => false
    t.boolean  "display_segments",                          :default => true, :null => false
    t.integer  "blog_id"
    t.string   "video_player",        :limit => 20
    t.string   "audio_dir",           :limit => 50
    t.integer  "missed_it_bucket_id"
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
  end

  add_index "programs_kpccprogram", ["air_status"], :name => "index_programs_kpccprogram_on_air_status"
  add_index "programs_kpccprogram", ["blog_id"], :name => "programs_kpccprogram_472bc96c"
  add_index "programs_kpccprogram", ["missed_it_bucket_id"], :name => "programs_kpccprogram_d12628ce"
  add_index "programs_kpccprogram", ["slug"], :name => "slug", :unique => true
  add_index "programs_kpccprogram", ["title"], :name => "title", :unique => true

  create_table "programs_otherprogram", :force => true do |t|
    t.string   "slug",        :limit => 40,         :null => false
    t.string   "title",       :limit => 60,         :null => false
    t.text     "teaser",      :limit => 2147483647
    t.text     "description", :limit => 2147483647
    t.string   "host",        :limit => 150
    t.string   "produced_by", :limit => 50
    t.string   "airtime",     :limit => 300
    t.string   "air_status",  :limit => 10,         :null => false
    t.string   "web_url",     :limit => 200
    t.string   "podcast_url", :limit => 200
    t.string   "rss_url",     :limit => 200
    t.text     "sidebar",     :limit => 2147483647
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "programs_otherprogram", ["air_status"], :name => "index_programs_otherprogram_on_air_status"
  add_index "programs_otherprogram", ["slug"], :name => "slug", :unique => true
  add_index "programs_otherprogram", ["title"], :name => "title", :unique => true

  create_table "promotions", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.integer  "asset_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "rails_content_map", :id => false, :force => true do |t|
    t.integer "django_content_type_id", :null => false
    t.string  "rails_class_name",       :null => false
  end

  create_table "recurring_schedule_slots", :force => true do |t|
    t.integer  "program_id"
    t.string   "program_type"
    t.integer  "start_time"
    t.integer  "end_time"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "recurring_schedule_slots", ["program_id", "program_type"], :name => "index_recurring_schedule_slots_on_program_id_and_program_type"
  add_index "recurring_schedule_slots", ["start_time", "end_time"], :name => "index_recurring_schedule_slots_on_start_time_and_end_time"

  create_table "schedule_program", :force => true do |t|
    t.integer  "day",                             :null => false
    t.integer  "kpcc_program_id"
    t.integer  "other_program_id"
    t.string   "program",          :limit => 150, :null => false
    t.string   "url",              :limit => 200, :null => false
    t.time     "start_time",                      :null => false
    t.time     "end_time",                        :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "schedule_program", ["day", "start_time", "end_time"], :name => "index_schedule_program_on_day_and_start_time_and_end_time"
  add_index "schedule_program", ["kpcc_program_id"], :name => "schedule_program_kpcc_program_id"
  add_index "schedule_program", ["other_program_id"], :name => "schedule_program_other_program_id"

  create_table "section_blogs", :force => true do |t|
    t.integer  "section_id"
    t.integer  "blog_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "section_blogs", ["blog_id"], :name => "index_section_blogs_on_blog_id"
  add_index "section_blogs", ["section_id"], :name => "index_section_blogs_on_section_id"

  create_table "section_categories", :force => true do |t|
    t.integer  "section_id"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "section_categories", ["category_id"], :name => "index_section_categories_on_category_id"
  add_index "section_categories", ["section_id"], :name => "index_section_categories_on_section_id"

  create_table "section_promotions", :force => true do |t|
    t.integer  "section_id"
    t.integer  "promotion_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "section_promotions", ["promotion_id"], :name => "index_section_promotions_on_promotion_id"
  add_index "section_promotions", ["section_id"], :name => "index_section_promotions_on_section_id"

  create_table "sections", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "missed_it_bucket_id"
  end

  add_index "sections", ["missed_it_bucket_id"], :name => "index_sections_on_missed_it_bucket_id"

  create_table "shows_episode", :force => true do |t|
    t.integer  "show_id",                            :null => false
    t.date     "air_date"
    t.string   "headline"
    t.text     "body",         :limit => 2147483647
    t.datetime "published_at"
    t.integer  "status"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "category_id"
  end

  add_index "shows_episode", ["category_id"], :name => "shows_episode_42dc49bc"
  add_index "shows_episode", ["show_id"], :name => "shows_episode_show_id"
  add_index "shows_episode", ["status", "published_at"], :name => "index_shows_episode_on_status_and_published_at"

  create_table "shows_rundown", :force => true do |t|
    t.integer "episode_id",    :null => false
    t.integer "segment_id",    :null => false
    t.integer "segment_order", :null => false
  end

  add_index "shows_rundown", ["episode_id"], :name => "shows_rundown_episode_id"
  add_index "shows_rundown", ["segment_id"], :name => "shows_rundown_segment_id"
  add_index "shows_rundown", ["segment_order"], :name => "index_shows_rundown_on_segment_order"

  create_table "shows_segment", :force => true do |t|
    t.integer  "show_id",                                    :null => false
    t.string   "headline"
    t.string   "slug",                 :limit => 50
    t.text     "teaser",               :limit => 2147483647
    t.text     "body",                 :limit => 2147483647
    t.datetime "created_at",                                 :null => false
    t.integer  "status"
    t.string   "segment_asset_scheme"
    t.string   "short_headline"
    t.datetime "published_at"
    t.datetime "updated_at",                                 :null => false
    t.integer  "category_id"
  end

  add_index "shows_segment", ["category_id"], :name => "shows_segment_42dc49bc"
  add_index "shows_segment", ["show_id"], :name => "shows_segment_show_id"
  add_index "shows_segment", ["slug"], :name => "shows_segment_slug"
  add_index "shows_segment", ["status", "published_at"], :name => "index_shows_segment_on_status_and_published_at"

  create_table "south_migrationhistory", :force => true do |t|
    t.string   "app_name",  :null => false
    t.string   "migration", :null => false
    t.datetime "applied",   :null => false
  end

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
    t.integer  "status"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "tickets", ["status"], :name => "index_tickets_on_status"
  add_index "tickets", ["user_id"], :name => "index_tickets_on_user_id"

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
    t.text     "object_yaml"
    t.datetime "created_at"
  end

  add_index "versions", ["user_id"], :name => "index_versions_on_user_id"
  add_index "versions", ["version_number"], :name => "index_versions_on_version_number"
  add_index "versions", ["versioned_type", "versioned_id"], :name => "index_versions_on_versioned_type_and_versioned_id"

end
