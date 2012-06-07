module AdminResource
  def administrate!
    extend ClassMethods
  end
  
  module ClassMethods
    include ActiveSupport::Inflector
    
    # Defaults
    def list_fields
      fields = []
      column_names.each { |a| fields.push({ attr: a, title: a.titleize }) }
      fields[1].merge!(link: true)
      fields
    end
    
    def list_order
      "id"
    end
    
    def list_per_page
      25
    end
    
  end
end

ActiveRecord::Base.extend AdminResource
