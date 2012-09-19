#= require scprbase

$ ->
    for field in $("form.simple_form input[name*='[slug]']")
        new scpr.AutoSlugField(field: field)

class scpr.AutoSlugField
    DefaultOptions:
        titleAttributes: ["title", "headline", "title", "name"]
    
    constructor: (options) ->
        @options = _.defaults options||{}, @DefaultOptions
        
        @slugField  = $ @options.field
        @titleAttrs = @options.titleAttributes

        # Loop through title attributes and find the first one that matches
        for attr in @titleAttrs
            @titleField = $ @slugField.closest("form").find("input[name*='[#{attr}]']")[0]
            break if !_.isEmpty(@titleField)

        # If we found a matching field, 
        # and if the slug field is empty when the page loads,
        # register a keyup event for it
        if @titleField and _.isEmpty(@slugField.val())
            @titleField.on
                keyup: (event) => @updateSlug($(event.target).val())
    
    updateSlug: (value) ->
        @slugField.val @slugify(value)
    
    slugify: (str) ->
        str.toLowerCase()
           .replace(/\s+/g, "-")     # Spaces -> `-`
           .replace(/-{2,}/g, '-')   # Fix accidental double-hyphens
           .replace(/[^\w\-]+/g, '') # Remove non-word characters/hyphen
           .replace(/^-+/, '')       # Trim hyphens from beginning
           .replace(/-+$/, '')       # Trim hyphens from end
