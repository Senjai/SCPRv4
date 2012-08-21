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

ActiveRecord::Schema.define(:version => 20120806171758) do

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

  create_table "ascertainment_ascertainmentrecord", :force => true do |t|
    t.integer "content_type_id",                :null => false
    t.integer "object_id",                      :null => false
    t.string  "locations",       :limit => 200
    t.string  "asc_types",       :limit => 200
    t.string  "verticals",       :limit => 200
  end

  add_index "ascertainment_ascertainmentrecord", ["content_type_id"], :name => "ascertainment_ascertainmentrecord_e4470c6e"

  create_table "assethost_contentasset", :force => true do |t|
    t.integer "django_content_type_id",                                       :null => false
    t.integer "content_id",                                                   :null => false
    t.integer "asset_order",                                  :default => 99, :null => false
    t.integer "asset_id",                                                     :null => false
    t.text    "caption",                :limit => 2147483647,                 :null => false
    t.string  "content_type",           :limit => 20
  end

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

  create_table "bios_award", :force => true do |t|
    t.integer "reporter_id",                :null => false
    t.integer "year",                       :null => false
    t.string  "award_name",  :limit => 250, :null => false
  end

  add_index "bios_award", ["reporter_id"], :name => "bios_award_reporter_id"

  create_table "bios_bio", :force => true do |t|
    t.integer "user_id",                                            :null => false
    t.string  "name",         :limit => 200,                        :null => false
    t.string  "last_name",    :limit => 100,        :default => "", :null => false
    t.string  "slugged_name", :limit => 50,         :default => "", :null => false
    t.text    "bio",          :limit => 2147483647,                 :null => false
    t.string  "title",        :limit => 200,        :default => "", :null => false
    t.string  "email",        :limit => 200,                        :null => false
    t.boolean "is_public",                                          :null => false
    t.string  "feed_url",     :limit => 200,        :default => "", :null => false
    t.string  "twitter",      :limit => 30,                         :null => false
    t.integer "asset_id"
    t.string  "short_bio",    :limit => 200,                        :null => false
    t.string  "phone_number", :limit => 30,                         :null => false
  end

  add_index "bios_bio", ["user_id"], :name => "user_id", :unique => true

  create_table "blogs_blog", :force => true do |t|
    t.string   "name",                :limit => 140,                           :null => false
    t.string   "slug",                :limit => 50,                            :null => false
    t.text     "description",         :limit => 2147483647,                    :null => false
    t.string   "head_image",          :limit => 200,        :default => "",    :null => false
    t.boolean  "is_active",                                 :default => false, :null => false
    t.string   "feed_url",            :limit => 200,        :default => "",    :null => false
    t.boolean  "is_remote",                                                    :null => false
    t.string   "custom_url",          :limit => 140,                           :null => false
    t.boolean  "is_news",                                                      :null => false
    t.string   "teaser",              :limit => 115,                           :null => false
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
    t.integer  "position",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "blogs_blogauthor", ["author_id"], :name => "blogs_blog_authors_64afdb51"
  add_index "blogs_blogauthor", ["blog_id", "author_id"], :name => "blogs_blog_authors_blog_id_579f20695740dd5e_uniq", :unique => true
  add_index "blogs_blogauthor", ["blog_id"], :name => "blogs_blog_authors_472bc96c"

  create_table "blogs_blogcategory", :force => true do |t|
    t.integer  "blog_id",                                                      :null => false
    t.string   "title",      :limit => 140,                                    :null => false
    t.string   "slug",       :limit => 50,                                     :null => false
    t.datetime "created_at",                :default => '2012-06-08 02:03:41', :null => false
    t.datetime "updated_at",                :default => '2012-06-08 02:03:41', :null => false
    t.integer  "wp_id"
  end

  add_index "blogs_blogcategory", ["blog_id"], :name => "blogs_blogcategory_472bc96c"
  add_index "blogs_blogcategory", ["slug"], :name => "blogs_blogcategory_a951d5d6"

  create_table "blogs_entry", :force => true do |t|
    t.string   "headline",          :limit => 140,                        :null => false
    t.string   "slug",              :limit => 50,                         :null => false
    t.text     "body",              :limit => 2147483647,                 :null => false
    t.integer  "author_id"
    t.integer  "blog_id",                                                 :null => false
    t.string   "blog_slug",         :limit => 50,         :default => "", :null => false
    t.datetime "published_at",                                            :null => false
    t.integer  "status",                                                  :null => false
    t.string   "blog_asset_scheme", :limit => 10
    t.string   "short_headline",    :limit => 100
    t.text     "teaser",            :limit => 2147483647
    t.integer  "wp_id"
    t.integer  "dsq_thread_id"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
  end

  add_index "blogs_entry", ["author_id"], :name => "blogs_entry_author_id"
  add_index "blogs_entry", ["blog_id"], :name => "blogs_entry_blog_id"

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
    t.string  "category",          :limit => 50,                   :null => false
    t.string  "slug",              :limit => 50,                   :null => false
    t.boolean "is_news",                         :default => true, :null => false
    t.integer "comment_bucket_id"
  end

  add_index "contentbase_category", ["comment_bucket_id"], :name => "contentbase_category_36c0cbca"
  add_index "contentbase_category", ["slug"], :name => "contentbase_category_a951d5d6"

  create_table "contentbase_contentalarm", :force => true do |t|
    t.integer  "content_type_id",                                    :null => false
    t.integer  "object_id",                                          :null => false
    t.integer  "action",                                             :null => false
    t.datetime "fire_at",         :default => '2011-09-20 15:15:06', :null => false
    t.boolean  "has_fired",       :default => false,                 :null => false
  end

  add_index "contentbase_contentalarm", ["content_type_id"], :name => "contentbase_contentalarm_e4470c6e"

  create_table "contentbase_contentbyline", :force => true do |t|
    t.integer "django_content_type_id",                              :null => false
    t.integer "content_id",                                          :null => false
    t.integer "user_id"
    t.string  "name",                   :limit => 50,                :null => false
    t.integer "role",                                 :default => 0, :null => false
    t.string  "content_type",           :limit => 20
  end

  add_index "contentbase_contentbyline", ["content_id"], :name => "index_contentbase_contentbyline_on_content_id"
  add_index "contentbase_contentbyline", ["content_type", "content_id"], :name => "index_contentbase_contentbyline_on_content_type_and_content_id"
  add_index "contentbase_contentbyline", ["django_content_type_id", "content_id"], :name => "content_key"
  add_index "contentbase_contentbyline", ["django_content_type_id"], :name => "contentbase_contentbyline_e4470c6e"
  add_index "contentbase_contentbyline", ["user_id"], :name => "contentbase_contentbyline_fbfc09f1"

  create_table "contentbase_contentcategory", :force => true do |t|
    t.integer "category_id",     :null => false
    t.integer "content_type_id", :null => false
    t.integer "object_id",       :null => false
  end

  add_index "contentbase_contentcategory", ["category_id"], :name => "contentbase_contentcategory_42dc49bc"
  add_index "contentbase_contentcategory", ["content_type_id", "object_id"], :name => "content_key", :unique => true
  add_index "contentbase_contentcategory", ["content_type_id"], :name => "contentbase_contentcategory_e4470c6e"

  create_table "contentbase_contentshell", :force => true do |t|
    t.string   "headline",     :limit => 200,                                           :null => false
    t.string   "site",         :limit => 50,         :default => "KPCC",                :null => false
    t.text     "body",         :limit => 2147483647,                                    :null => false
    t.string   "url",          :limit => 150,                                           :null => false
    t.integer  "status",                             :default => 0,                     :null => false
    t.datetime "published_at",                       :default => '2011-11-21 11:07:11', :null => false
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
  end

  create_table "contentbase_featuredcomment", :force => true do |t|
    t.integer  "bucket_id",                                                                :null => false
    t.integer  "content_type_id",                                                          :null => false
    t.integer  "object_id",                                                                :null => false
    t.integer  "status",                                :default => 0,                     :null => false
    t.datetime "published_at",                          :default => '2012-01-11 12:35:43', :null => false
    t.string   "username",        :limit => 50,                                            :null => false
    t.text     "excerpt",         :limit => 2147483647,                                    :null => false
  end

  add_index "contentbase_featuredcomment", ["bucket_id"], :name => "contentbase_featuredcomment_25ef9024"
  add_index "contentbase_featuredcomment", ["content_type_id"], :name => "contentbase_featuredcomment_e4470c6e"

  create_table "contentbase_featuredcommentbucket", :force => true do |t|
    t.string "title", :limit => 50, :null => false
  end

  create_table "contentbase_misseditbucket", :force => true do |t|
    t.string "title", :limit => 50, :null => false
  end

  create_table "contentbase_misseditcontent", :force => true do |t|
    t.integer "bucket_id",                       :null => false
    t.integer "content_type_id",                 :null => false
    t.integer "object_id",                       :null => false
    t.integer "position",        :default => 99, :null => false
  end

  add_index "contentbase_misseditcontent", ["bucket_id"], :name => "contentbase_misseditcontent_25ef9024"
  add_index "contentbase_misseditcontent", ["content_type_id"], :name => "contentbase_misseditcontent_e4470c6e"

  create_table "contentbase_videoshell", :force => true do |t|
    t.string   "headline",     :limit => 200,                                           :null => false
    t.text     "body",         :limit => 2147483647,                                    :null => false
    t.integer  "status",                             :default => 0,                     :null => false
    t.datetime "published_at",                       :default => '2012-03-02 15:14:07', :null => false
    t.string   "slug",         :limit => 50,                                            :null => false
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
  end

  add_index "contentbase_videoshell", ["slug"], :name => "contentbase_videoshell_a951d5d6"

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
    t.string   "headline",            :limit => 140,                           :null => false
    t.string   "slug",                :limit => 50,                            :null => false
    t.text     "body",                :limit => 2147483647,                    :null => false
    t.string   "etype",               :limit => 4,                             :null => false
    t.string   "sponsor",             :limit => 140,                           :null => false
    t.string   "sponsor_link",        :limit => 200,                           :null => false
    t.datetime "starts_at",                                                    :null => false
    t.datetime "ends_at"
    t.boolean  "is_all_day",                                                   :null => false
    t.string   "location_name",       :limit => 140,                           :null => false
    t.string   "location_link",       :limit => 200,                           :null => false
    t.string   "rsvp_link",           :limit => 200,                           :null => false
    t.boolean  "show_map",                                                     :null => false
    t.string   "address_1",           :limit => 140,                           :null => false
    t.string   "address_2",           :limit => 140,                           :null => false
    t.string   "city",                :limit => 140,                           :null => false
    t.string   "state",               :limit => 2
    t.integer  "zip_code"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.boolean  "kpcc_event",                                :default => false, :null => false
    t.string   "for_program",         :limit => 20,         :default => "",    :null => false
    t.text     "archive_description", :limit => 2147483647,                    :null => false
    t.string   "audio",               :limit => 100,        :default => "",    :null => false
    t.boolean  "is_published",                                                 :null => false
    t.boolean  "show_comments",                                                :null => false
    t.text     "teaser",              :limit => 2147483647,                    :null => false
    t.string   "event_asset_scheme",  :limit => 10
  end

  add_index "events_event", ["slug"], :name => "events_event_slug"

  create_table "flatpages_flatpage", :force => true do |t|
    t.string   "url",                   :limit => 100,        :null => false
    t.string   "title",                 :limit => 200,        :null => false
    t.text     "content",               :limit => 2147483647, :null => false
    t.text     "extra_head",            :limit => 2147483647, :null => false
    t.text     "extra_tail",            :limit => 2147483647, :null => false
    t.boolean  "enable_comments",                             :null => false
    t.boolean  "registration_required",                       :null => false
    t.datetime "updated_at"
    t.text     "description",           :limit => 2147483647, :null => false
    t.string   "redirect_url",          :limit => 250
    t.boolean  "is_public",                                   :null => false
    t.datetime "created_at",                                  :null => false
    t.string   "template",              :limit => 10,         :null => false
  end

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

  create_table "layout_homepage", :force => true do |t|
    t.string   "base",                :limit => 10, :null => false
    t.datetime "published_at",                      :null => false
    t.integer  "status",                            :null => false
    t.integer  "missed_it_bucket_id"
  end

  add_index "layout_homepage", ["missed_it_bucket_id"], :name => "layout_homepage_d12628ce"

  create_table "layout_homepagecontent", :force => true do |t|
    t.integer "homepage_id",                     :null => false
    t.integer "content_type_id",                 :null => false
    t.integer "object_id",                       :null => false
    t.integer "position",        :default => 99, :null => false
  end

  add_index "layout_homepagecontent", ["content_type_id"], :name => "layout_homepagecontent_e4470c6e"
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
    t.string  "mp3",             :limit => 100
    t.integer "size"
    t.integer "duration"
    t.integer "enco_number"
    t.date    "enco_date"
    t.integer "content_type_id",                                           :null => false
    t.integer "object_id",                                                 :null => false
    t.text    "description",     :limit => 2147483647
    t.string  "byline",          :limit => 150,        :default => "KPCC", :null => false
    t.integer "position",                              :default => 0,      :null => false
  end

  add_index "media_audio", ["content_type_id", "object_id"], :name => "media_audio_content_type_id_569dcfe00f4d911"
  add_index "media_audio", ["content_type_id"], :name => "media_audio_e4470c6e"

  create_table "media_document", :force => true do |t|
    t.string   "document_file", :limit => 100,        :null => false
    t.string   "title",         :limit => 140,        :null => false
    t.text     "description",   :limit => 2147483647, :null => false
    t.string   "source",        :limit => 140,        :null => false
    t.datetime "uploaded_at",                         :null => false
  end

  create_table "media_encoaudio", :force => true do |t|
    t.integer "enco_number",                 :null => false
    t.string  "url",          :limit => 250, :null => false
    t.date    "publish_date",                :null => false
    t.string  "notes",        :limit => 100
    t.integer "size"
    t.integer "duration"
  end

  add_index "media_encoaudio", ["enco_number", "publish_date"], :name => "media_encoaudio_enco_number_6948cf1d7886f6e3_uniq", :unique => true

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
    t.string  "title",           :limit => 150, :default => "", :null => false
    t.string  "link",            :limit => 300,                 :null => false
    t.string  "link_type",       :limit => 10,                  :null => false
    t.string  "sort_order",      :limit => 2,   :default => "", :null => false
    t.integer "content_type_id",                                :null => false
    t.integer "object_id",                                      :null => false
  end

  add_index "media_link", ["content_type_id", "object_id"], :name => "media_link_content_type_id_41947a9a86b99b7a"
  add_index "media_link", ["content_type_id"], :name => "media_link_content_type_id"

  create_table "media_programaudio", :force => true do |t|
    t.string  "name",         :limit => 140, :null => false
    t.string  "slug",         :limit => 50,  :null => false
    t.string  "url",          :limit => 250, :null => false
    t.date    "publish_date",                :null => false
    t.string  "notes",        :limit => 100, :null => false
    t.integer "duration"
    t.integer "size"
  end

  add_index "media_programaudio", ["slug", "publish_date"], :name => "media_programaudio_slug_3ba28574ecbcfebe_uniq", :unique => true

  create_table "media_related", :force => true do |t|
    t.integer "content_type_id",                    :null => false
    t.integer "object_id",                          :null => false
    t.integer "rel_content_type_id",                :null => false
    t.integer "rel_object_id",                      :null => false
    t.integer "flag",                :default => 0, :null => false
  end

  add_index "media_related", ["content_type_id"], :name => "media_related_e4470c6e"
  add_index "media_related", ["rel_content_type_id"], :name => "media_related_76fb6e42"

  create_table "media_uploadedaudio", :force => true do |t|
    t.string  "mp3_file",        :limit => 100,        :null => false
    t.text    "description",     :limit => 2147483647, :null => false
    t.string  "source",          :limit => 150,        :null => false
    t.boolean "allow_download",                        :null => false
    t.string  "sort_order",      :limit => 2,          :null => false
    t.integer "content_type_id",                       :null => false
    t.integer "object_id",                             :null => false
    t.integer "duration"
    t.integer "size"
  end

  add_index "media_uploadedaudio", ["content_type_id", "object_id"], :name => "media_uploadedaudio_content_type_id_229fd3799cc99e4f"
  add_index "media_uploadedaudio", ["content_type_id"], :name => "media_uploadedaudio_content_type_id"

  create_table "news_story", :force => true do |t|
    t.string   "headline",           :limit => 200,                        :null => false
    t.string   "slug",               :limit => 50,         :default => "", :null => false
    t.string   "news_agency",        :limit => 50
    t.text     "teaser",             :limit => 2147483647,                 :null => false
    t.text     "body",               :limit => 2147483647,                 :null => false
    t.string   "locale",             :limit => 5,          :default => "", :null => false
    t.integer  "enco_number"
    t.date     "audio_date"
    t.datetime "published_at",                                             :null => false
    t.string   "source",             :limit => 20
    t.string   "story_asset_scheme", :limit => 10
    t.string   "extra_asset_scheme", :limit => 10
    t.string   "lead_asset_scheme",  :limit => 10
    t.integer  "status",                                                   :null => false
    t.string   "short_headline",     :limit => 100
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
  end

  add_index "news_story", ["published_at"], :name => "news_story_published_at"

  create_table "npr_npr_story", :force => true do |t|
    t.string   "headline",     :limit => 140,        :null => false
    t.text     "teaser",       :limit => 2147483647, :null => false
    t.datetime "published_at",                       :null => false
    t.string   "link",         :limit => 200,        :null => false
    t.string   "npr_id",       :limit => 20,         :null => false
    t.boolean  "new",                                :null => false
  end

  create_table "pij_query", :force => true do |t|
    t.string   "slug",         :limit => 50,         :null => false
    t.string   "headline",     :limit => 200,        :null => false
    t.text     "teaser",       :limit => 2147483647, :null => false
    t.text     "body",         :limit => 2147483647, :null => false
    t.string   "query_type",   :limit => 20,         :null => false
    t.integer  "form_height",                        :null => false
    t.string   "query_url",    :limit => 200,        :null => false
    t.boolean  "is_active",                          :null => false
    t.datetime "published_at",                       :null => false
    t.datetime "expires_at"
    t.boolean  "is_featured",                        :null => false
  end

  add_index "pij_query", ["slug"], :name => "slug", :unique => true

  create_table "podcasts_category", :force => true do |t|
    t.string  "name",      :limit => 140, :null => false
    t.integer "parent_id"
  end

  add_index "podcasts_category", ["parent_id"], :name => "podcasts_category_parent_id"

  create_table "podcasts_episode", :force => true do |t|
    t.integer  "show_id",                                            :null => false
    t.string   "title",        :limit => 140,                        :null => false
    t.text     "summary",      :limit => 2147483647,                 :null => false
    t.string   "url",          :limit => 250,        :default => "", :null => false
    t.string   "mp3_url",      :limit => 250,                        :null => false
    t.integer  "mp3_size",                                           :null => false
    t.datetime "published_at",                                       :null => false
    t.string   "guid",         :limit => 150,        :default => "", :null => false
  end

  add_index "podcasts_episode", ["show_id"], :name => "podcasts_episode_show_id"

  create_table "podcasts_news", :force => true do |t|
    t.integer  "category_id",                                        :null => false
    t.string   "title",        :limit => 140,                        :null => false
    t.text     "summary",      :limit => 2147483647,                 :null => false
    t.string   "url",          :limit => 250,        :default => "", :null => false
    t.string   "mp3_url",      :limit => 250
    t.integer  "mp3_size"
    t.datetime "published_at",                                       :null => false
    t.integer  "story_id"
    t.integer  "encoaudio_id"
  end

  add_index "podcasts_news", ["category_id"], :name => "podcasts_news_category_id"
  add_index "podcasts_news", ["encoaudio_id"], :name => "podcasts_news_220021d6"
  add_index "podcasts_news", ["story_id"], :name => "podcasts_news_f5ae222e"

  create_table "podcasts_podcast", :force => true do |t|
    t.string  "slug",        :limit => 40,                            :null => false
    t.string  "title",       :limit => 140,                           :null => false
    t.string  "link",        :limit => 250,                           :null => false
    t.string  "podcast_url", :limit => 250,        :default => "",    :null => false
    t.string  "itunes_url",  :limit => 250,        :default => "",    :null => false
    t.text    "description", :limit => 2147483647,                    :null => false
    t.string  "image_url",   :limit => 250,                           :null => false
    t.string  "author",      :limit => 140,                           :null => false
    t.string  "keywords",    :limit => 200,                           :null => false
    t.string  "duration",    :limit => 10,                            :null => false
    t.boolean "is_listed",                         :default => false, :null => false
    t.integer "program_id"
    t.integer "category_id"
    t.string  "item_type",   :limit => 10
  end

  add_index "podcasts_podcast", ["category_id"], :name => "podcasts_podcast_42dc49bc"
  add_index "podcasts_podcast", ["program_id"], :name => "podcasts_podcast_7eef53e3"
  add_index "podcasts_podcast", ["slug"], :name => "slug", :unique => true

  create_table "podcasts_show_categories", :force => true do |t|
    t.integer "show_id",     :null => false
    t.integer "category_id", :null => false
  end

  add_index "podcasts_show_categories", ["category_id"], :name => "category_id_refs_id_27ff6d7cb17b0c56"
  add_index "podcasts_show_categories", ["show_id", "category_id"], :name => "show_id", :unique => true

  create_table "podcasts_topic", :force => true do |t|
    t.string  "slug",        :limit => 40,                            :null => false
    t.string  "title",       :limit => 140,                           :null => false
    t.string  "link",        :limit => 250,                           :null => false
    t.string  "podcast_url", :limit => 250,        :default => "",    :null => false
    t.string  "itunes_url",  :limit => 250,        :default => "",    :null => false
    t.text    "description", :limit => 2147483647,                    :null => false
    t.string  "image_url",   :limit => 250,                           :null => false
    t.string  "author",      :limit => 140,                           :null => false
    t.string  "keywords",    :limit => 200,                           :null => false
    t.string  "duration",    :limit => 10,                            :null => false
    t.boolean "is_listed",                         :default => false, :null => false
    t.integer "category_id"
  end

  add_index "podcasts_topic", ["category_id"], :name => "podcasts_topic_42dc49bc"
  add_index "podcasts_topic", ["slug"], :name => "slug", :unique => true

  create_table "podcasts_topic_categories", :force => true do |t|
    t.integer "topic_id",    :null => false
    t.integer "category_id", :null => false
  end

  add_index "podcasts_topic_categories", ["category_id"], :name => "category_id_refs_id_159cb4f1192b4e5f"
  add_index "podcasts_topic_categories", ["topic_id", "category_id"], :name => "topic_id", :unique => true

  create_table "press_releases_release", :force => true do |t|
    t.string   "short_title",  :limit => 240,        :default => "", :null => false
    t.string   "slug",         :limit => 50,         :default => "", :null => false
    t.string   "long_title",   :limit => 240,        :default => "", :null => false
    t.text     "body",         :limit => 2147483647,                 :null => false
    t.datetime "published_at",                                       :null => false
  end

  add_index "press_releases_release", ["slug"], :name => "press_releases_release_slug"

  create_table "programs_kpccprogram", :force => true do |t|
    t.string  "slug",                :limit => 40,                            :null => false
    t.string  "title",               :limit => 60,                            :null => false
    t.text    "teaser",              :limit => 2147483647,                    :null => false
    t.text    "description",         :limit => 2147483647,                    :null => false
    t.string  "host",                :limit => 150,        :default => "",    :null => false
    t.string  "airtime",             :limit => 300,                           :null => false
    t.string  "air_status",          :limit => 10,                            :null => false
    t.string  "podcast_url",         :limit => 300,        :default => "",    :null => false
    t.string  "rss_url",             :limit => 300,        :default => "",    :null => false
    t.string  "twitter_url",         :limit => 300,        :default => "",    :null => false
    t.string  "facebook_url",        :limit => 300,        :default => "",    :null => false
    t.text    "sidebar",             :limit => 2147483647,                    :null => false
    t.boolean "display_episodes",                          :default => false, :null => false
    t.boolean "display_segments",                                             :null => false
    t.integer "blog_id"
    t.string  "video_player",        :limit => 20
    t.string  "audio_dir",           :limit => 50
    t.integer "missed_it_bucket_id"
    t.string  "quick_slug",          :limit => 40
  end

  add_index "programs_kpccprogram", ["blog_id"], :name => "programs_kpccprogram_472bc96c"
  add_index "programs_kpccprogram", ["missed_it_bucket_id"], :name => "programs_kpccprogram_d12628ce"
  add_index "programs_kpccprogram", ["slug"], :name => "slug", :unique => true
  add_index "programs_kpccprogram", ["title"], :name => "title", :unique => true

  create_table "programs_otherprogram", :force => true do |t|
    t.string "slug",        :limit => 40,                         :null => false
    t.string "title",       :limit => 60,                         :null => false
    t.text   "teaser",      :limit => 2147483647,                 :null => false
    t.text   "description", :limit => 2147483647,                 :null => false
    t.string "host",        :limit => 150,        :default => "", :null => false
    t.string "produced_by", :limit => 50,                         :null => false
    t.string "airtime",     :limit => 300,                        :null => false
    t.string "air_status",  :limit => 10,                         :null => false
    t.string "web_url",     :limit => 300,        :default => "", :null => false
    t.string "podcast_url", :limit => 300,        :default => "", :null => false
    t.string "rss_url",     :limit => 300,        :default => "", :null => false
    t.text   "sidebar",     :limit => 2147483647,                 :null => false
  end

  add_index "programs_otherprogram", ["slug"], :name => "slug", :unique => true
  add_index "programs_otherprogram", ["title"], :name => "title", :unique => true

  create_table "rails_content_map", :id => false, :force => true do |t|
    t.integer "id",         :null => false
    t.string  "class_name", :null => false
  end

  create_table "rails_contentbase_contentcategory", :id => false, :force => true do |t|
    t.integer "id",           :default => 0, :null => false
    t.integer "category_id",                 :null => false
    t.integer "content_id",                  :null => false
    t.string  "content_type"
  end

  create_table "rails_contentbase_featuredcomment", :id => false, :force => true do |t|
    t.integer  "id",                                 :default => 0,                     :null => false
    t.integer  "bucket_id",                                                             :null => false
    t.integer  "status",                             :default => 0,                     :null => false
    t.datetime "published_at",                       :default => '2012-01-11 12:35:43', :null => false
    t.string   "username",     :limit => 50,                                            :null => false
    t.text     "excerpt",      :limit => 2147483647,                                    :null => false
    t.integer  "content_id",                                                            :null => false
    t.string   "content_type"
  end

  create_table "rails_contentbase_misseditcontent", :id => false, :force => true do |t|
    t.integer "id",           :default => 0,  :null => false
    t.integer "bucket_id",                    :null => false
    t.integer "content_id",                   :null => false
    t.string  "content_type",                 :null => false
    t.integer "position",     :default => 99, :null => false
  end

  create_table "rails_layout_homepagecontent", :id => false, :force => true do |t|
    t.integer "id",           :default => 0,  :null => false
    t.integer "homepage_id",                  :null => false
    t.integer "content_id",                   :null => false
    t.string  "content_type",                 :null => false
    t.integer "position",     :default => 99, :null => false
  end

  create_table "rails_media_audio", :id => false, :force => true do |t|
    t.integer "id",                                 :default => 0,      :null => false
    t.integer "content_id",                                             :null => false
    t.string  "content_type",                                           :null => false
    t.string  "mp3",          :limit => 100
    t.text    "description",  :limit => 2147483647
    t.string  "byline",       :limit => 150,        :default => "KPCC", :null => false
    t.integer "enco_number"
    t.date    "enco_date"
    t.integer "position",                           :default => 0,      :null => false
    t.integer "duration"
    t.integer "size"
  end

  create_table "rails_media_link", :id => false, :force => true do |t|
    t.integer "id",                          :default => 0,  :null => false
    t.integer "content_id",                                  :null => false
    t.string  "content_type",                                :null => false
    t.string  "title",        :limit => 150, :default => "", :null => false
    t.string  "link",         :limit => 300,                 :null => false
    t.string  "link_type",    :limit => 10,                  :null => false
    t.string  "sort_order",   :limit => 2,   :default => "", :null => false
  end

  create_table "rails_media_related", :id => false, :force => true do |t|
    t.integer "id",           :default => 0, :null => false
    t.integer "content_id",                  :null => false
    t.string  "content_type"
    t.integer "related_id",                  :null => false
    t.string  "related_type"
    t.integer "flag",         :default => 0, :null => false
  end

  create_table "rails_media_uploadedaudio", :id => false, :force => true do |t|
    t.integer "id",                                   :default => 0, :null => false
    t.integer "content_id",                                          :null => false
    t.string  "content_type",                                        :null => false
    t.string  "mp3_file",       :limit => 100,                       :null => false
    t.text    "description",    :limit => 2147483647,                :null => false
    t.string  "source",         :limit => 150,                       :null => false
    t.boolean "allow_download",                                      :null => false
    t.string  "sort_order",     :limit => 2,                         :null => false
    t.integer "duration"
    t.integer "size"
  end

  create_table "schedule_program", :force => true do |t|
    t.integer "day",                             :null => false
    t.integer "kpcc_program_id"
    t.integer "other_program_id"
    t.string  "program",          :limit => 150, :null => false
    t.string  "url",              :limit => 200, :null => false
    t.time    "start_time",                      :null => false
    t.time    "end_time",                        :null => false
  end

  add_index "schedule_program", ["kpcc_program_id"], :name => "schedule_program_kpcc_program_id"
  add_index "schedule_program", ["other_program_id"], :name => "schedule_program_other_program_id"

  create_table "shows_episode", :force => true do |t|
    t.integer  "show_id",                            :null => false
    t.date     "air_date",                           :null => false
    t.string   "headline",     :limit => 140,        :null => false
    t.text     "body",         :limit => 2147483647, :null => false
    t.datetime "published_at",                       :null => false
    t.integer  "status",                             :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "shows_episode", ["show_id"], :name => "shows_episode_show_id"

  create_table "shows_rundown", :force => true do |t|
    t.integer "episode_id",    :null => false
    t.integer "segment_id",    :null => false
    t.integer "segment_order", :null => false
  end

  add_index "shows_rundown", ["episode_id"], :name => "shows_rundown_episode_id"
  add_index "shows_rundown", ["segment_id"], :name => "shows_rundown_segment_id"

  create_table "shows_segment", :force => true do |t|
    t.integer  "show_id",                                                    :null => false
    t.string   "headline",             :limit => 200,                        :null => false
    t.string   "slug",                 :limit => 50,                         :null => false
    t.text     "teaser",               :limit => 2147483647,                 :null => false
    t.text     "body",                 :limit => 2147483647,                 :null => false
    t.string   "locale",               :limit => 5,          :default => "", :null => false
    t.datetime "created_at"
    t.integer  "status",                                                     :null => false
    t.string   "segment_asset_scheme", :limit => 10
    t.string   "short_headline",       :limit => 100
    t.datetime "published_at",                                               :null => false
    t.integer  "enco_number"
    t.date     "audio_date",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  add_index "shows_segment", ["show_id"], :name => "shows_segment_show_id"
  add_index "shows_segment", ["slug"], :name => "shows_segment_slug"

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
    t.integer "django_content_type_id",                                        :null => false
    t.string  "content_type",           :limit => 20, :default => "BlogEntry"
  end

  add_index "taggit_taggeditem", ["content_id"], :name => "taggit_taggeditem_829e37fd"
  add_index "taggit_taggeditem", ["django_content_type_id"], :name => "taggit_taggeditem_e4470c6e"
  add_index "taggit_taggeditem", ["tag_id"], :name => "taggit_taggeditem_3747b463"

  create_table "users_userprofile", :force => true do |t|
    t.integer "userid",                    :null => false
    t.string  "nickname",   :limit => 50,  :null => false
    t.string  "firstname",  :limit => 50
    t.string  "lastname",   :limit => 50
    t.string  "location",   :limit => 120
    t.string  "image_file", :limit => 100
    t.string  "email",      :limit => 75
  end

  add_index "users_userprofile", ["nickname"], :name => "nickname", :unique => true
  add_index "users_userprofile", ["userid"], :name => "userid", :unique => true

end
