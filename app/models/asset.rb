class Asset < ActiveResource::Base
  self.site = "http://a.scpr.org/api/"
  self.element_name = 'asset'
  self.include_root_in_json = false
  
  def tag(size)
    if !self.tags
      return nil
    end
    
    self.tags.send(size.to_s).html_safe
  end
  
  def asset
    return self
  end
  
  #----------
  
  def url_domain 
    if !self.url
      return nil
    end
    
    domain = URI.parse(self.url).host
    
    return (domain == 'www.flickr.com') ? 'Flickr' : domain
  end
  
  #----------

  class << self
      @@auth_token = 'droQQ2LcESKeGPzldQr7'
            
      #----------

      #def find(*arguments)
      #  arguments = append_auth_token_to_params(*arguments)
      #  super(*arguments)
      #end
            
      def element_path(id, prefix_options = {}, query_options = nil)
        super(id, *apply_auth_token(prefix_options, query_options))
      end

      def collection_path(prefix_options = {}, query_options = nil)
        super(*apply_auth_token(prefix_options, query_options))
      end

      #def append_auth_token_to_params(*arguments)
      #  opts = arguments.last.is_a?(Hash) ? arguments.pop : {}
      #  opts = opts.has_key?(:params) ? opts : opts.merge(:params => {}) 
      #  opts[:params] = opts[:params].merge(:auth_token => @@auth_token)
      #  arguments << opts
      #  arguments
      #end
      
      def apply_auth_token(prefix_options, query_options)
            if query_options
              [prefix_options, query_options.merge(:auth_token => @@auth_token)]
            else
              [prefix_options.merge(:auth_token => @@auth_token)]
            end
          end
      
      
    end
end