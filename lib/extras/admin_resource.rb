module AdminResource
  def administrate!
    extend ClassMethods
  end
  
  module ClassMethods
    include ActiveSupport::Inflector
    
    DEFAULTS = [
      order: "id desc",
      per_page: 25
    ]
    
    attr_reader :list_fields, :list_order, :list_per_page
    
    def list_fields=(fields=[])
      # If no fields are passed in, just use every column.
      if fields.blank?
        fields = column_names.map { |col| [col.to_s] }
      end
      
      # Force a hash into the array if one wasn't given,
      # and then reverse-merge some default values.
      fields.each do |f|
        f.push({}) if !f[1]
        f[1].reverse_merge!(title: f[0].titleize)
      end
      
      # The first column will be linked if no link is specified
      if !fields.any? { |f| f[1]['link'] == true }
        fields[0][1].merge!(link: true)
      end
      
      @list_fields = fields
    end
        
    def list_order=(order)
      order ||= DEFAULTS[:order]
      @list_order = order
    end
    
    def list_per_page=(per_page)
      per_page ||= DEFAULTS[:per_page]
      @list_per_page = per_page
    end
  end
end

ActiveRecord::Base.extend AdminResource
