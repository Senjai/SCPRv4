module CacheHelper
  
  # ----------------------
  # archive_cache
  # Only cache if the date is in the past
  def archive_cache(date, key, &block)
    if date.to_i < Time.now.beginning_of_day.to_i
      content_cache key do
        yield
      end
    else
      yield
    end
  end

  # ----------------------
  
end