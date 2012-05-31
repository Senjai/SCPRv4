# Be sure to restart your server when you modify this file.

class YAMLVerifier < ActiveSupport::MessageVerifier
  def generate(value)
    # If it isn't present, add in session_expiry to support django
    if value.is_a?(Hash) && !value.has_key?("_session_expiry")
      # expire in 30 days
      value['_session_expiry'] = (Time.now() + 30*86400).strftime("%s")
    end
    
    data = ::Base64.strict_encode64(@serializer.dump(value))
    "#{data}--#{generate_digest(data)}"
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
