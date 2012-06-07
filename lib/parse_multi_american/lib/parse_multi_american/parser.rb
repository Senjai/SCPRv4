module MultiAmerican
  include ActiveSupport::Inflector
  
  NODE_MAP = {
    posts: { xpath: "item",
             scprv4_class: BlogEntry,
             xml_ar_map: {
        
             }
           },
    
    authors: { xpath: "wp:author",
               scprv4_class: Bio,
               xml_ar_map: { 
                 
               }
             },
               
    categories: { xpath: "wp:category",
                  scprv4_class: Category,
                  xml_ar_map: {
                    
                  }
                },
                  
    tags: { xpath: "wp:tag",
            scprv4_class: Tag,
            xml_ar_map: {
              tag_slug: :slug,
              tag_name: :name
            }
          },
            
    terms: { xpath: "wp:term" }
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
      klass = nattr[:scprv4_class]
      new_records = []
              
      @doc.xpath("//#{nattr[:xpath]}").each do |element|
        builder = {}
        
        element.children.reject { |c| !nattr[:xml_ar_map].keys.include? c.name.to_sym }.each do |child|
          puts "#{child.name} : #{child.content}"
          builder.merge!(nattr[:xml_ar_map][child.name.to_sym] => child.content)
          puts builder
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