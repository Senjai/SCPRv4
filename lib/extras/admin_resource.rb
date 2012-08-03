module AdminResource
  
  DEFAULTS = {
    list_order: "id desc",
    list_per_page: 25,
    excluded_fields: ["id"]
  }

  TITLE_ATTRIBS = [:name, :short_headline, :title, :headline]
  
  
  # -----------------------
  
  def administrate
    extend ClassMethods
    include InstanceMethods
  end
  
  # -----------------------
  
  module ClassMethods
    
    def list_fields
      if !@list_fields
        self.list_fields = column_names.map { |col| [col] }
      end
      @list_fields
    end
    
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
        
    # -----------------------
    
    def list_order
      @list_order || DEFAULTS[:list_order]
    end
    
    def list_order=(order)
      @list_order = order
    end

    # -----------------------
    
    def list_per_page
      # Need to check if defined, because we might want to
      # pass `nil` to limit (specifying no limit).
      defined?(@list_per_page) ? @list_per_page : DEFAULTS[:list_per_page]
    end
    
    def list_per_page=(per_page)
      if per_page == "all"
        per_page = nil
      else
        per_page = per_page.to_i
      end
      
      @list_per_page = per_page
    end
    
    # -----------------------    
    
    def fields
      if only_fields.present?
        only_fields
      elsif excluded_fields.present?
        column_names - excluded_fields
      else
        column_names - DEFAULTS[:excluded_fields]
      end
    end
    
    # -----------------------

    attr_accessor :excluded_fields, :only_fields
  end
  
  # -----------------------
  
  module InstanceMethods
    
    def to_title
      title_method = TITLE_ATTRIBS.find { |a| self.respond_to?(a) }
      title_method ? self.send(title_method) : "#{self.class.name.titleize} ##{self.id}"
    end
  end
end

ActiveRecord::Base.extend AdminResource
