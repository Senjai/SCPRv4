module AdminResource

  LIST_DEFAULTS = {
    list_order: "id desc",
    list_per_page: 25
  }

  TITLE_ATTRIBS = [:name, :short_headline, :title, :headline]
  
  def administrate!
    Scprv4::Application.config.admin_models.push self
    extend ClassMethods
    include InstanceMethods
  end
  
  module ClassMethods
    attr_reader :list_fields, :list_order, :list_per_page
        
    def list_fields=(fields=[])
      if fields.present? 
        fields.each do |f|
          f[0] = f[0].to_s

          # Force a hash into the array if one wasn't given,
          # and then reverse-merge some default values.
          f.push({}) if !f[1]
          f[1].symbolize_keys!
          f[1].reverse_merge!(title: f[0].titleize, display_helper: "display_#{f[0]}")
        end

        # The first column will be linked if no link is specified
        if !fields.any? { |f| f[1][:link] == true }
          fields[0][1].merge!(link: true)
        end
      end
      
      @list_fields = fields
    end
    
    def list_fields
      if !@list_fields
        self.list_fields = column_names.map { |col| [col] }
      end
      @list_fields
    end
        
    def list_order=(order)
      order ||= DEFAULTS[:list_order]
      @list_order = order
    end
    
    def list_per_page=(per_page)
      per_page ||= DEFAULTS[:list_per_page]
      @list_per_page = per_page.to_i
    end
  end
  
  module InstanceMethods
    def to_title
      title_method = TITLE_ATTRIBS.find { |a| self.respond_to?(a) }
      title_method ? self.send(title_method) : "#{self.class.name.titleize} ##{self.id}"
    end
  end
end

ActiveRecord::Base.extend AdminResource
