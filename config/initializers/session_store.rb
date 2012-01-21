# Be sure to restart your server when you modify this file.

class JSONVerifier < ActiveSupport::MessageVerifier
  def verify(signed_message)
    raise InvalidSignature if signed_message.blank?

    data, digest = signed_message.split("--")
    if data.present? && digest.present? && secure_compare(digest, generate_digest(data))
      Rails.logger.debug("initial session data is #{data}")
      
      ActiveSupport::JSON.decode(Base64.decode64(data))
    else
      raise InvalidSignature
    end
  end

  def generate(value)
    # If it isn't present, add in session_expiry to support django
    if value.is_a?(Hash) && !value.has_key?("_session_expiry")
      # expire in 30 days
      value['_session_expiry'] = (Time.now() + 30*86400).strftime("%s")
    end
    
    data = Base64.encode64(ActiveSupport::JSON.encode(value))
    "#{data}--#{generate_digest(data)}"
  end
end

module ActionDispatch
  class Cookies
    class SignedCookieJar
      def initialize(parent_jar, secret)
        ensure_secret_secure(secret)
        @parent_jar = parent_jar
        @verifier   = JSONVerifier.new(secret)
      end
    end
  end
end
      

Scprv4::Application.config.session_store :cookie_store, key: '_scprv4_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Scprv4::Application.config.session_store :active_record_store
