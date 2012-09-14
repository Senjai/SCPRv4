class CacheExpirationObserver < ActiveRecord::Observer
  observe ContentBase
  def after_save(content)
    # do nothing
  end
end
