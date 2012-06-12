module WP
  include ActiveSupport::Inflector
  
  NODE_MAP = {
    post: { xpath: "item",  
            scprv4_class: "BlogEntry",
            wp_class: "Post",
             xml_ar_map: {
               title: :title,
               pubDate: :published_at,
               "content:encoded" => :content,
               "excerpt:encoded" => :teaser,
               status: :status,
               post_name: :slug,
               post_id: :wp_id,
               post_type: :post_type
             }
           },
    
    author: { xpath: "wp:author",
              scprv4_class: "Bio",
              wp_class: "Author",
               xml_ar_map: { 
                 
               }
             },
               
    category: { xpath: "wp:category",
                scprv4_class: "Category",
                wp_class: "Category",
                  xml_ar_map: {
                    
                  }
                },
                  
    tag: { xpath: "wp:tag",
           scprv4_class: "Tag",
           wp_class: "Tag",
            xml_ar_map: {
              tag_slug: :slug,
              tag_name: :name,
              term_id: :wp_id
            }
          },
            
    term: { xpath: "wp:term" }
  }
  
  class Document
    attr_reader :posts, :authors, :categories, :tags, :terms
    
    def initialize(file)
      @doc = Nokogiri::XML(File.open(file))
      @title = @doc.at_xpath("/rss/channel/title").content
      @pubDate = @doc.at_xpath("/rss/channel/pubDate").content
    end
    
    attr_reader :title, :pubDate
    
    def parse_to_xml(attrib)
      parsed_xml = @doc.xpath("//#{NODE_MAP[attrib.to_sym][:xpath]}")
      instance_variable_set("@#{attrib.to_s}_xml", parsed_xml)
    end
    
    def parse_to_objects(attrib)
      nattr = NODE_MAP[attrib.to_sym]
      klass = nattr[:scprv4_class].to_s.constantize
      local_klass = ["WP", nattr[:wp_class]].join("::").constantize
      new_records = []
      @doc.xpath("//#{nattr[:xpath]}").each do |element|
        builder = {}
        
        element.children.reject { |c| !nattr[:xml_ar_map].keys.include? c.name.to_sym }.each do |child|
          builder.merge! local_klass.filter_values(child.name.to_sym, child.content)
        end
        
        builder.merge! local_klass::DEFAULTS
        new_records.push klass.new(builder)
      end
      
      instance_variable_set("@#{attrib.to_s.pluralize}", new_records)
    end
    
    def self.strip_cdata(attrib)
      match = attrib.match(/<!\[CDATA\[(.+?)\]\]>/)[1]
    end
  end
end
