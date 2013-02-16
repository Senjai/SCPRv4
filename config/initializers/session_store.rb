# Be sure to restart your server when you modify this file.

class YAMLVerifier < ActiveSupport::MessageVerifier
  def verify(signed_message)
    raise InvalidSignature if signed_message.blank?

    data, digest = signed_message.split("--")
    if data.present? && digest.present? && secure_compare(digest, generate_digest(data))
      # First load with @serializer (YAML), if there is a YAML syntax error, then decode with JSON
      begin
        @serializer.load(::Base64.decode64(data))
      rescue Psych::SyntaxError
        Rails.logger.info "Caught YAML syntax error. Decoding with JSON."
        ActiveSupport::JSON.decode(Base64.decode64(data.gsub('%3D','=')))    
      end
    else
      raise InvalidSignature
    end
  end
  
  def generate(value)
    data = ::Base64.strict_encode64(@serializer.dump(convert(value)))
    "#{data}--#{generate_digest(data)}"
  end


  def convert(value)
    # If it isn't present, add in session_expiry to support django
    if value.is_a?(Hash)
       if !value.has_key?("_session_expiry")
         value['_session_expiry'] = (Time.now() + 30*86400).strftime("%s") # expire in 30 days
       end       
    end
    
    return value    
  end
end


module ActionDispatch
  class Cookies
    class SignedCookieJar
      def initialize(parent_jar, secret)
        ensure_secret_secure(secret)
        @parent_jar = parent_jar
        @verifier   = YAMLVerifier.new(secret, serializer: YAML)
      end
    end
  end
end

Scprv4::Application.config.session_store :cookie_store, key: '_scprv4_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Scprv4::Application.config.session_store :active_record_store
