module Api::Public::V2
  class BucketsController < BaseController
    before_filter :sanitize_slug, only: [:show]

    #---------------------------

    def index
      @buckets = MissedItBucket.all
      respond_with @buckets
    end

    #---------------------------

    def show
      @bucket = MissedItBucket.where(slug: @slug).first

      if !@bucket
        render_not_found and return false
      end

      respond_with @bucket
    end
  end
end
