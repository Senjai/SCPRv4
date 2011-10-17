# This class won't be used until we're ready to start writing objects via 
# Rails.  For now, we have to rely on Mercer to handle expiration

class ContentBaseSweeper < ActionController::Caching::Sweeper
  observe ContentBase
  
  def after_save(content)
    ActionController::Base.cache_store.expire_obj(content)
  end  
end