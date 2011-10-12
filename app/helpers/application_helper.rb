module ApplicationHelper  
  def render_asset(content,context)
    # short circuit if it's obvious we're getting nowhere
    if !content || !content.respond_to?("assets") || !content.assets.any?
      return ''
    end

    # look for a scheme on the content object
    scheme = content["#{context}_asset_scheme"] || "default"

    # set up our template precendence
    tmplt_opts = [
      "#{context}/#{scheme}",
      "default/#{scheme}",
      "#{context}/default",
      "default/default"
    ]
    
    partial = tmplt_opts.detect { |t| self.lookup_context.exists?(t,["shared/assets"],true) }

    render :partial => "shared/assets/#{partial}", :object => content.assets, :as => :assets
  end
  
  #----------
  
  def byline(content,links = true)
    if !content || !content.respond_to?("byline_elements")
      return ""
    end
    
    bylines = content.byline_elements.flatten.compact

    if links
      bylines = bylines.collect do |b|
        if b.is_a? Bio
          (link_to b.name, bio_path(b.slugged_name))
        else
          b
        end
      end
    end
    
    if bylines.length > 1
      return [bylines[0..-2].join(" & "),bylines[-1]].join(" | ").html_safe
    else
      return bylines[0]
    end
  end
end
