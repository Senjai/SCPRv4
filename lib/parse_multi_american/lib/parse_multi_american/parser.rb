module WP
  include ActiveSupport::Inflector
  
  NODE_MAP = {
    post: { xpath: "item",             
             xml_ar_map: {
               title: :title,
               pubDate: :published_at,
               "content:encoded" => :content,
               excerpt: :teaser,
               status: :status,
               post_name: :slug
             }
           },
    
    author: { xpath: "wp:author",
               xml_ar_map: { 
                 
               }
             },
               
    category: { xpath: "wp:category",
                  xml_ar_map: {
                    
                  }
                },
                  
    tag: { xpath: "wp:tag",
            xml_ar_map: {
              tag_slug: :slug,
              tag_name: :name
            }
          },
            
    term: { xpath: "wp:term" }
  }
  
  class Parser
    attr_reader :posts, :authors, :categories, :tags, :terms
    
    def initialize(file)
      @doc = Nokogiri::XML(File.open(file))
    end
    
    def parse_to_xml(attrib)
      parsed_xml = @doc.xpath("//#{NODE_MAP[attrib.to_sym][:xpath]}")
      instance_variable_set("@#{attrib.to_s}_xml", parsed_xml)
    end
    
    def parse_to_objects(attrib)
      nattr = NODE_MAP[attrib.to_sym]
      klass = ['WP', attrib.to_s.camelize].join("::").constantize
      
      new_records = []
      @doc.xpath("//#{nattr[:xpath]}").each do |element|
        builder = {}
        
        element.children.reject { |c| !nattr[:xml_ar_map].keys.include? c.name.to_sym }.each do |child|
          builder.merge!(nattr[:xml_ar_map][child.name.to_sym] => child.content)
        end
        
        new_records.push klass.new(builder)
      end
      
      instance_variable_set("@#{attrib.to_s.pluralize}", new_records)
    end
    
    def self.strip_cdata(attrib)
      match = attrib.match(/<!\[CDATA\[(.+?)\]\]>/)[1]
    end
  end
end
