module WP  
  class Admin::MultiAmericanController < Admin::BaseController
    require 'will_paginate/array'
    def index
      @doc = WP::Document.new("#{Rails.root}/lib/multi_american/XML/full_dump.xml")
      
      @all_posts = @doc.parse_to_objects(:post)
      @posts = @all_posts.paginate(page: params[:posts_page], per_page: 20)
      
      @all_tags = @doc.parse_to_objects(:tag)
      @tags = @all_tags.paginate(page: params[:tags_page], per_page: 100)
    end
  end
end
